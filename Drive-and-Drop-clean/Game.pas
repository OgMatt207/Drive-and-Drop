unit Game;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,clsVehicleController, pngimage,
  clsGameObject,clsVehicle,clsDelivery,
  clsDeliveryPoint;

type
  TfrmGame = class(TForm)
    imgPlayerVehicle: TImage;
    lblMoney: TLabel;
    tmrMovement: TTimer;
    lblSpeed: TLabel;
    lblRotation: TLabel;
    tmrCollisions: TTimer;
    lblFuel: TLabel;
    lblLoad: TLabel;
    tmrDelivery: TTimer;
    lblTimeRemaining: TLabel;
    imgFuelIcon: TImage;
    imgFuelGauge: TImage;
    imgMoneyIcon: TImage;
    imgFuelGaugeBorder: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tmrMovementTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrCollisionsTimer(Sender: TObject);
    procedure tmrDeliveryTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure imgFuelGaugeBorderMouseEnter(Sender: TObject);
    procedure imgFuelGaugeMouseEnter(Sender: TObject);
  private
    { Private declarations }
    arrMap : array of array of TGameObject; //Keep track of static/normal objects
    arrInteractiveObjects : array of TGameObject; //Store interactive objects
    iMilelage : integer;

    //iActiveDeliveries : integer;

    bMovingUp,bMovingRight,bMovingDown,bMovingLeft : boolean;
    procedure RenderCar(CarImage : TImage;iRotation : integer); //Only Vehicle Image and its rotation.The position is not accounted for
    procedure UpdateUI;
    procedure LoadMap;
    procedure RenderMap;
    procedure InteractWithFuelStation();
    procedure InteractWithGarage();
    function CheckCollision(Vehicle: TVehicleController; GameObject : TGameObject): boolean;
    function InsideMap : boolean;
    procedure SpawnPlayer();
    procedure SaveGame();
  public
    { Public declarations }
    PlayerID : integer;
    PlayerMoney : integer;
    PlayerUsername : string;
    PlayerVehicle : TVehicleController; //Needs to be access by garage form
    ActiveDelivery : TDelivery;
  end;

var
  frmGame: TfrmGame;

const
  MAP_PATH : string = 'Map.txt';
  GRID_WIDTH : integer = 136;
  GRID_HEIGHT : integer = 101;

implementation

uses
DataBase,DeliveryTab,Garage;

{$R *.dfm}

function TfrmGame.InsideMap: boolean;
begin

if (PlayerVehicle.GetX > frmGame.Width) OR (PlayerVehicle.GetX < 0) OR (PlayerVehicle.GetY > frmGame.Height) OR (PlayerVehicle.GetY < 0) then
begin
  Result := False;
end
else begin
  Result := True;
end;

end;

procedure TfrmGame.InteractWithFuelStation();
var
  iCost: Integer;
  iResponse: Integer;
begin
  iCost := PlayerVehicle.GetVehicle.GetRefillCost;

  iResponse := MessageDlg('Refill Vehicle for ' + IntToStr(iCost) + '$?', mtConfirmation, [mbYes, mbNo], 0);

  if iResponse = mrYes then
  begin
    if PlayerMoney >= iCost then
    begin
      PlayerVehicle.GetVehicle.Refill;
      PlayerMoney := PlayerMoney - iCost;
      SaveGame;
    end
    else
    begin
      MessageDlg('Not enough money to refill', mtWarning, [mbOK], 0);
    end;
  end;

end;

procedure TfrmGame.InteractWithGarage();
var
iResponse : integer;
begin
  iResponse := MessageDlg('Enter Garage?', mtConfirmation, [mbYes, mbNo], 0);

  if iResponse = mrYes then
  begin
    SaveGame;
    frmGame.Hide;
    frmGarage.show;
  end;

end;

function TfrmGame.CheckCollision(Vehicle: TVehicleController; GameObject : TGameObject): Boolean;
var
  PlayerRect, ObjectRect: TRect;
begin
  // Get the bounding rectangles of the Player and object
  PlayerRect.Left := Vehicle.GetX;
  PlayerRect.Top := Vehicle.GetY;
  PlayerRect.Right := Vehicle.GetX + imgPlayerVehicle.Width;
  PlayerRect.Bottom := Vehicle.GetY + imgPlayerVehicle.Height;

  ObjectRect.Left := GameObject.GetX;
  ObjectRect.Top := GameObject.GetY;
  ObjectRect.Right := GameObject.GetX + GameObject.GetWidth;
  ObjectRect.Bottom := GameObject.GetY + GameObject.GetHeight;

  // Check for intersection between the bounding rectangles
  Result := IntersectRect(PlayerRect, PlayerRect, ObjectRect);
end;

procedure TfrmGame.LoadMap;
var
tMap : Textfile;
sLine : string;
i : integer;
x,y : integer; //Used for 2d array indexes
InteractiveIndex : integer;
begin

y := 0;
InteractiveIndex := 0;

SetLength(arrMap,100,100);
SetLength(arrInteractiveObjects,25);

if FileExists(MAP_PATH) then
begin
  AssignFile(tMap,MAP_PATH);
  Reset(tMap);

  while not eof(tMap) do
  begin
    Readln(tMap,sline);
    x := 0;

    for I := 1 to Length(sLine) do
    begin
      case sLine[I] of
      'R' : arrMap[x,y] := TGameObject.Create('Road',x * GRID_WIDTH,y * GRID_HEIGHT,GRID_WIDTH,GRID_HEIGHT,False);
      'B' : arrMap[x,y] := TGameObject.Create('Building',x * GRID_WIDTH,y * GRID_HEIGHT,GRID_WIDTH,GRID_HEIGHT,True);
      'T' : arrMap[x,y] := TGameObject.Create('Tree',x * GRID_WIDTH,y * GRID_HEIGHT,GRID_WIDTH,GRID_HEIGHT,True);
      'X' : arrMap[x,y] := TGameObject.Create('Barrier',x * GRID_WIDTH,y * GRID_HEIGHT,GRID_WIDTH,GRID_HEIGHT,True);
      'G' :  begin
        arrInteractiveObjects[InteractiveIndex] := TGameObject.Create('Garage',x * GRID_WIDTH,y * GRID_HEIGHT,GRID_WIDTH,GRID_HEIGHT,True);
        InteractiveIndex := InteractiveIndex + 1;
      end;
      'F' :  begin
        arrInteractiveObjects[InteractiveIndex] := TGameObject.Create('Fuel Station',x * GRID_WIDTH,y * GRID_HEIGHT,GRID_WIDTH,GRID_HEIGHT,True);
        InteractiveIndex := InteractiveIndex + 1;
      end;
      else arrMap[x,y] := nil;
      end;
      x := x + 1;
    end;

    y := y + 1;
  end;
  CloseFile(tMap);

end
else begin
  MessageDlg('There is no map file. Contact admin to fix/make map.' + #13 + 'Closing Game',mtError,[mbOK],0);
  Close;
end;

end;

procedure TfrmGame.RenderMap();
var
I,k: Integer;
j: Integer;
begin

  for I := Low(arrMap) to High(arrMap) do  //columns /x
  begin             //arrName[I] means a single row * iterates only within the current row (I).
    for j := Low(arrMap[I]) to High(arrMap[I]) do  //rows /y
    begin
      if arrMap[I,J] <> nil then
      begin
        arrMap[I,J].Render;
      end;
    end;
  end;

  //Load Interactive objects

  for k := 0 to High(arrInteractiveObjects) do
  begin
    if arrInteractiveObjects[k] <> nil then
    begin
      arrInteractiveObjects[k].Render();
    end;
  end;

end;

procedure TfrmGame.SaveGame;
var
sQuery : string;
begin

with dbmGame do begin
  //Save Money
  sQuery := 'UPDATE tblPLayers SET [Money] = ' + IntToStr(PlayerMoney) + ' WHERE Player_ID = ' + IntToStr(PlayerID);
  qryGame.SQL.Text := sQuery;
  qryGame.ExecSQL;

  //PlayerVehicles Stats
sQuery := 'UPDATE tblPlayerVehicles SET [Milelage] = [Milelage] + ' + IntToStr(iMilelage)
          + ', [Current_Fuel] = ' + StringReplace(
                FloatToStrF(PlayerVehicle.GetVehicle.GetFuel, ffFixed, 8, 2),
                ',', '.', [rfReplaceAll])
          + ' WHERE [Player_ID] = ' + IntToStr(PlayerID)
          + ' AND [Vehicle_ID] = ' + IntToStr(PlayerVehicle.GetVehicle.GetID);
  qryGame.SQL.Text := sQuery;
  qryGame.ExecSQL;
end;

// Reset iMilelage after saving
iMilelage := 0;

end;

procedure TfrmGame.SpawnPlayer;
var
  I: Integer;
  k: Integer;
begin

    //Find a road to spawn player
    
    for I := Low(arrMap) to High(arrMap) do
    begin
      for k := Low(arrMap[I]) to High(arrMap[I]) do
      begin

        if arrMap[I,K] <> nil then
        begin

          if arrMap[I,k].GetType = 'Road' then
          begin
            PlayerVehicle.SetPosx(I * GRID_WIDTH + (GRID_WIDTH div 4));
            PlayerVehicle.SetPosy(k * GRID_HEIGHT + (GRID_HEIGHT div 4));
            Exit;
          end;

        end;
        
      end;//Inner For
    end;//Outer For

end;

procedure TfrmGame.RenderCar(CarImage: TImage; iRotation: Integer);
var
sVehicleImageName : string;
begin
  //validation
  //Check if all directions of Vehicle image exists
  if (FileExists('Vehicles/' + PlayerVehicle.GetVehicle.GetName + '_Right.png'))
  AND (FileExists('Vehicles/' + PlayerVehicle.GetVehicle.GetName + '_Up.png'))
  AND (FileExists('Vehicles/' + PlayerVehicle.GetVehicle.GetName + '_Down.png'))
  AND (FileExists('Vehicles/' + PlayerVehicle.GetVehicle.GetName + '_Left.png')) then
  begin
    sVehicleImageName := PlayerVehicle.GetVehicle.GetName;
  end
  else begin
    sVehicleImageName := 'Car Template';
  end;

  //Render Car
    // Determine which image to load based on rotation
  if (iRotation = 0)then
  begin
    CarImage.Picture.LoadFromFile('Vehicles/' + sVehicleimageName + '_Right.png');
  end
  else if iRotation = 90 then
  begin
    CarImage.Picture.LoadFromFile('Vehicles/' + sVehicleimageName + '_Down.png');
  end
  else if iRotation = 180 then
  begin
    CarImage.Picture.LoadFromFile('Vehicles/' + sVehicleimageName + '_Left.png');
  end
  else if iRotation = 270 then
  begin
    CarImage.Picture.LoadFromFile('Vehicles/' + sVehicleimageName + '_Up.png');
  end
  else
  begin
    // Default image if something goes wrong
    CarImage.Picture.LoadFromFile('Vehicles/Car Template_Right.png');
  end;

end;

procedure TfrmGame.FormDestroy(Sender: TObject);
begin
  PlayerVehicle.Free; // Clean up the PlayerVehicle object
end;

procedure TfrmGame.FormHide(Sender: TObject);
begin
tmrMovement.Enabled := False;
tmrCollisions.Enabled := False;
tmrDelivery.Enabled := False;
end;

procedure TfrmGame.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

case Key of
vk_Up : bMovingUp := True;
vk_Right : bMovingRight := True;
vk_Down : bMovingDown := True;
vk_Left :bMovingLeft := True ;
vk_escape : Close;
VK_SPACE : begin
    if Assigned(ActiveDelivery) then
    begin
      ActiveDelivery.GetPickUp.Unload;
      ActiveDelivery.GetDropOff.Unload;
      ActiveDelivery := nil;
    end;
    tmrMovement.Enabled := false;
    tmrCollisions.Enabled := false;
    tmrDelivery.Enabled := false;
    frmDeliveries.show;
    end;
end;

end;

procedure TfrmGame.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

case Key of
vk_Up : bMovingUp := False;
vk_Right : bMovingRight := False;
vk_Down : bMovingDown := False;
vk_Left :bMovingLeft := False;
end;

end;

procedure TfrmGame.FormShow(Sender: TObject);
begin

bMovingUp := False;
bMovingRight := False;
bMovingDown := False;
bMovingLeft := False;
iMilelage := 0;

LoadMap;
RenderMap;
ActiveDelivery := nil;
imgPlayerVehicle.BringToFront;
lblLoad.BringToFront;
lblRotation.BringToFront;
lblSpeed.BringToFront;
lblMoney.BringToFront;
lblFuel.BringToFront;
lblTimeRemaining.BringToFront;
imgMoneyIcon.BringToFront;
imgFuelIcon.BringToFront;
imgFuelGauge.BringToFront;
imgFuelGaugeBorder.BringToFront;

SpawnPlayer;

tmrMovement.Enabled := True;
tmrCollisions.Enabled := True;
tmrDelivery.Enabled := True;
end;
//Tool hints
procedure TfrmGame.imgFuelGaugeBorderMouseEnter(Sender: TObject);
begin
imgFuelGaugeBorder.Hint := FloatToStrF(PlayerVehicle.GetVehicle.GetFuel,ffGeneral,10,8) + ' L';
imgFuelGaugeBorder.ShowHint := true;
end;
//Tool hints
procedure TfrmGame.imgFuelGaugeMouseEnter(Sender: TObject);
begin
imgFuelGauge.Hint := FloatToStrF(PlayerVehicle.GetVehicle.GetFuel,ffGeneral,10,8) + ' L';
imgFuelGauge.ShowHint := true;
end;

procedure TfrmGame.tmrMovementTimer(Sender: TObject);
begin

//Allow player to go to garage if they have no fuel left to drive
if (bMovingUp OR bMovingDown OR bMovingRight OR bMovingLeft) AND (PlayerVehicle.GetVehicle.GetFuel <= 0) then
begin
  bMovingUp := False;
  bMovingRight := False;
  bMovingLeft := False;
  bMovingDown := False;
  MessageDlg('You ran out of fuel!',mtWarning,[mbOK],0);
  SaveGame;
  frmGame.Hide;
  frmGarage.show;
end;

//Note that the vehicle will only render its image when the vehicle has move to save processing when player does nothing
if bMovingUp then
begin
  PlayerVehicle.RotateUP;
  PlayerVehicle.ApplySpeed;
  RenderCar(imgPlayerVehicle,PlayerVehicle.GetRotation);
end
else if bMovingDown then
begin
  PlayerVehicle.RotateDown;
  PlayerVehicle.ApplySpeed;
  RenderCar(imgPlayerVehicle,PlayerVehicle.GetRotation);
end;

if bMovingRight then
begin
  PlayerVehicle.RotateRight;
  PlayerVehicle.ApplySpeed;
  RenderCar(imgPlayerVehicle,PlayerVehicle.GetRotation);
end
else if bMovingLeft then
begin
  PlayerVehicle.RotateLeft;
  PlayerVehicle.ApplySpeed;
  RenderCar(imgPlayerVehicle,PlayerVehicle.GetRotation);
end;

if not(bMovingUp OR bMovingDown OR bMovingRight OR bMovingLeft) then
begin
  PlayerVehicle.ApplyFriction;
  RenderCar(imgPlayerVehicle,PlayerVehicle.GetRotation);
end;

//Get new position of vehicle
PlayerVehicle.UpdatePosition;
if not InsideMap then
begin
  //Respawn player
  SpawnPlayer;
  PlayerVehicle.StopVehicle;
end;
iMilelage := iMilelage + Round(Sqrt(Sqr(PlayerVehicle.GetX - imgPlayerVehicle.Left) + Sqr(PlayerVehicle.GetY - imgPlayerVehicle.Top))) DIV 10;
//Show new position of Vehicle
imgPlayerVehicle.Left := PlayerVehicle.GetX;
imgPlayerVehicle.Top := PlayerVehicle.GetY;
//Update GUI
UpdateUI;
end;

procedure TfrmGame.tmrCollisionsTimer(Sender: TObject);
var
I,j : integer;
sQuery : string;
begin

//Check for interactive collisions
for I := Low(arrInteractiveObjects) to High(arrInteractiveObjects) do
begin
  if arrInteractiveObjects[I] = nil then
  begin
    break;
  end;

  if CheckCollision(PlayerVehicle,arrInteractiveObjects[I]) then
  begin
    if arrInteractiveObjects[I].GetType = 'Fuel Station' then
    begin
      PlayerVehicle.SetOppositeRotation;
      bMovingUp := False;
      bMovingRight := False;
      bMovingLeft := False;
      bMovingDown := False;
      InteractWithFuelStation;
    end
    else if arrInteractiveObjects[I].GetType = 'Garage' then
    begin
      PlayerVehicle.SetOppositeRotation;
      bMovingUp := False;
      bMovingRight := False;
      bMovingLeft := False;
      bMovingDown := False;
      InteractWithGarage;
    end;

  end;
end;

//Check if player interacts with PickUp or DropOff points
if Assigned(ActiveDelivery) then
begin

  if (CheckCollision(PlayerVehicle,ActiveDelivery.GetPickUp)) AND not (ActiveDelivery.IsActive) then
  begin
    //Start deliveery
    ActiveDelivery.Activate;
    Activedelivery.GetPickUp.Unload;
    ActiveDelivery.GetDropOff.Render;
    Exit;
  end;

  if (CheckCollision(PlayerVehicle,ActiveDelivery.GetDropOff)) AND (ActiveDelivery.IsActive) then
  begin
    //Complete Deilvery
    lblTimeRemaining.Caption := '';
    ActiveDelivery.Deactivate;
    ActiveDelivery.GetDropOff.Unload;
    PlayerMoney := PlayerMoney + ActiveDelivery.GetReward;
    //Money Cap
    if frmGame.PlayerMoney > 9999 then
    begin
      frmGame.PlayerMoney := 9999;
    end;
    ActiveDelivery := nil;
    sQuery := 'UPDATE tblPlayerVehicles SET [Deliveries_Completed] = [Deliveries_Completed] + 1 '
          + 'WHERE [Player_ID] = ' + IntToStr(PlayerID)
          + ' AND [Vehicle_ID] = ' + IntToStr(PlayerVehicle.GetVehicle.GetID);
    dbmGame.qryGame.SQL.Text := sQuery;
    dbmGame.qryGame.ExecSQL;
    //Reset Player input (because of a bug)
    bMovingUp := False;
    bMovingRight := False;
    bMovingDown := False;
    bMovingLeft := False;
    Showmessage('Delivery completed');
    SaveGame;
  end;


end;

//Lastly check check for map collisions
for I := Low(arrMap) to High(arrmap) do
begin
  for j := Low(arrMap[I]) to High(arrMap[I]) do
  begin
    if arrMap[I,J] <> nil then
    begin
      if arrMap[I,J].GetCollidable = True then
      begin
        if CheckCollision(PlayerVehicle,arrMap[I,J]) then
        begin
          bMovingUp := False;
          bMovingRight := False;
          bMovingLeft := False;
          bMovingDown := False;
          PlayerVehicle.SetOppositeRotation;
        end;
      end;
    end;
  end;

end;



end;

procedure TfrmGame.tmrDeliveryTimer(Sender: TObject);
begin
// Decrease time remainging for delivery

if not Assigned(ActiveDelivery) then
begin
   Exit;
end;

if ActiveDelivery.IsActive then
begin
  ActiveDelivery.UpdateTime;
  lblTimeRemaining.Caption := IntToStr(ActiveDelivery.GetTimeRemaining);
  lblTimeRemaining.Refresh;

  if ActiveDelivery.GetTimeRemaining <= 0 then
  begin
    lblTimeRemaining.Caption := '';
    ActiveDelivery.Deactivate;
    ActiveDelivery.GetPickUp.Unload;
    ActiveDelivery.GetDropOff.Unload;
    ActiveDelivery := nil;
    //Reset Player input (because of a bug)
    bMovingUp := False;
    bMovingRight := False;
    bMovingDown := False;
    bMovingLeft := False;
    Showmessage('Delivery failed');
    SaveGame;
  end;

end;

end;

procedure TfrmGame.UpdateUI;
begin
//Debuggig info not shown in game
lblFuel.Caption := 'Fuel: ' + FloatToStr(PlayerVehicle.GetVehicle.GetFuel);
lblRotation.Caption := 'Rotation: ' + IntToStr(PlayerVehicle.GetRotation);
lblLoad.Caption := 'Load: ' + IntToStr(PlayerVehicle.GetVehicle.getCurrentCapacity);

//Show info
lblSpeed.Caption := IntToStr(PlayerVehicle.GetSpeed) + ' Km/H';
lblMoney.Caption := IntToStr(PlayerMoney);
//Current Fuel divide by Max fuel Multiply by max Width
//Ensures that there this the same width across all vehicles that have max fuel
imgFuelGauge.Width := Trunc(PlayerVehicle.GetVehicle.GetFuel / PlayerVehicle.GetVehicle.GetMaxFuel * 250);
end;

end.
