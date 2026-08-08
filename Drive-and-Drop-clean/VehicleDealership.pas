unit VehicleDealership;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls,clsVehicle, Grids, DBGrids, jpeg;

type
  TfrmDealership = class(TForm)
    pnlDetails: TPanel;
    imgNext: TImage;
    imgPrevious: TImage;
    imgVehicle: TImage;
    lblName: TLabel;
    lblSpeed: TLabel;
    lblFuelCapacity: TLabel;
    lblVehicleCost: TLabel;
    lblMoney: TLabel;
    imgBuyVehicle: TImage;
    imgGarage: TImage;
    lblLoadCapacity: TLabel;
    imgBackGround: TImage;
    lblArrayIndex: TLabel;
    procedure imgNextClick(Sender: TObject);
    procedure imgPreviousClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgBuyVehicleClick(Sender: TObject);
    procedure imgGarageClick(Sender: TObject);
  private
    { Private declarations }
    arrVehicles : array [0..20] of TVehicle;
    Index : integer;
    CurrentIndex : integer;
    procedure LoadDetails();
    procedure LoadVehicles;
    procedure LoadVehicleImage(ArrayIndex : integer);
  public
    { Public declarations }
  end;

var
  frmDealership: TfrmDealership;

implementation

{$R *.dfm}

uses
Game,DataBase,Garage;

{ TForm3 }


procedure TfrmDealership.FormShow(Sender: TObject);
begin
LoadVehicles;
CurrentIndex := 0;
LoadDetails;
lblMoney.Caption := 'Cash: ' + IntToStr(frmGame.PlayerMoney) + '$';
imgBackground.Width := frmDealership.Width;
imgBackground.Height := frmDealership.Height;
imgBackground.SendToBack;
end;

procedure TfrmDealership.imgBuyVehicleClick(Sender: TObject);
var
sQuery : string;
begin

if frmGame.PlayerMoney < arrVehicles[CurrentIndex].GetCost then
begin
  MessageDlg('You dont have enough money',mtWarning,[mbOk],0);
  Exit;
end;

//Check if player exists in the database
  sQuery := 'SELECT * FROM tblPLayers WHERE Player_ID = ' + IntToStr(frmGame.PlayerID);
  with dbmGame do
  begin
      qryGame.SQL.Text := SQuery;
      qryGame.Open;

      if qryGame.IsEmpty then
      begin
        MessageDlg('PlayerID not found in tblPlayers',mtError,[mbOk],0);
        Exit;
      end;
  end;

//Check if player already has the vehicle
  //Complex selection query, e.g. using AND/OR/LIKE/HAVING
  sQuery := 'SELECT * FROM tblPLayerVehicles WHERE Player_ID = ' + IntToStr(frmGame.PlayerID) + ' AND Vehicle_ID = ' + IntToStr(arrVehicles[CurrentIndex].GetID);
  with dbmGame do
  begin
      qryGame.SQL.Text := SQuery;
      qryGame.Open;

      if not qryGame.IsEmpty then
      begin
        MessageDlg('You already have this vehicle',mtWarning,[mbOk],0);
        Exit;
      end;
  end;
//Check if Player has enough space to buy a new vehicle
  sQuery := 'SELECT * FROM tblPLayerVehicles WHERE Player_ID = ' + IntToStr(frmGame.PlayerID);
  with dbmGame do
  begin
      qryGame.SQL.Text := SQuery;
      qryGame.Open;

      if qryGame.RecordCount >= 10 then
      begin
        MessageDlg('You can only have 10 vehicles at a time',mtWarning,[mbOk],0);
        Exit;
      end;
  end;

//Insert new record for tblPlayerVehicles
  sQuery := 'INSERT INTO tblPlayerVehicles(Player_ID,Vehicle_ID,Deliveries_Completed,Milelage,Current_Fuel) '
          + 'VALUES(' + IntToStr(frmGame.PlayerID) + ',' + IntToStr(arrVehicles[CurrentIndex].GetID) + ',0,0,' + StringReplace(
                FloatToStrF(arrVehicles[CurrentIndex].GetMaxFuel, ffFixed, 8, 2),
                ',', '.', [rfReplaceAll]) +')';

  with dbmGame do
  begin
    qryGame.SQL.Text := sQuery;
    qryGame.ExecSQL;
  end;

//Update Player's money
  frmGame.PlayerMoney := frmGame.PlayerMoney - arrVehicles[CurrentIndex].GetCost;
  sQuery := 'UPDATE tblPlayers SET [Money] = ' + IntToStr(frmGame.PlayerMoney) + ' WHERE [Player_ID] = ' + IntToStr(frmGame.PlayerID);
  with dbmGame do
  begin
    qryGame.SQL.Text := sQuery;
    qryGame.ExecSQL;
  end;
  lblMoney.Caption := 'Cash: ' + IntToStr(frmGame.PlayerMoney) + '$';

  MessageDlg('You successfully bought the vehicle',mtInformation,[mbOK],0);
end;

procedure TfrmDealership.imgGarageClick(Sender: TObject);
begin
  frmDealership.Hide;
  frmGarage.show;
end;

procedure TfrmDealership.imgNextClick(Sender: TObject);
begin

 if CurrentIndex < Index then
 begin
    Inc(CurrentIndex);
    LoadDetails;
 end;

end;

procedure TfrmDealership.imgPreviousClick(Sender: TObject);
begin

 if CurrentIndex > 0 then
 begin
    Dec(CurrentIndex);
    LoadDetails;
 end;

end;

procedure TfrmDealership.LoadDetails;
begin
//Added units for Fuel and load capacity
  if (CurrentIndex > -1) AND (Index > -1) then
  begin
   lblName.Caption := 'Name: ' + arrVehicles[CurrentIndex].GetName;
   lblSpeed.Caption := 'Speed: ' + IntToStr(arrVehicles[CurrentIndex].GetSpeed);
   lblFuelCapacity.Caption := 'Fuel Capacity: ' + FloatToStr(arrVehicles[CurrentIndex].GetMaxFuel) + 'L';
   lblLoadCapacity.Caption := 'Load Capacity: ' + IntToStr(arrVehicles[CurrentIndex].GetMaxCapacity) + 'KG';
   lblVehicleCost.Caption := 'Cost: ' + IntToStr(arrVehicles[CurrentIndex].GetCost) + '$';
   lblArrayIndex.Caption := IntToStr(CurrentIndex + 1) + '/' + IntToStr(Index + 1);
   LoadVehicleImage(CurrentIndex);
  end;

end;

procedure TfrmDealership.LoadVehicleImage(ArrayIndex: integer);
begin

  if FileExists('Vehicles/' + arrVehicles[ArrayIndex].GetName + '_Right.png') then
  begin
    imgVehicle.Picture.LoadFromFile('Vehicles/' + arrVehicles[ArrayIndex].GetName + '_Right.png');
  end
  else begin
    MessageDlg('The car does not have an image,using default image',mtWarning,[mbOk],0);
    imgVehicle.Picture.LoadFromFile('Vehicles/Car Template_Right.png');
  end;

end;

procedure TfrmDealership.LoadVehicles;
var
  SQuery,sName: String;
  iVehicleID, iCost, iMaxCapacity, iSpeed: integer;
  iMaxFuel : real;
begin
  Index := -1;
  SQuery := 'SELECT * FROM tblVehicles';

  with dbmGame do
  begin
    qryGame.SQL.Text := SQuery;
    qryGame.Open;

    if qryGame.IsEmpty then
    begin
      MessageDlg('No data found in tblVehicles',mtError,[mbOK],0);
      Exit;
    end;

    qryGame.First;

    while not qryGame.Eof do
    begin
      iVehicleID := qryGame['Vehicle_ID'];
      sName := qryGame['Vehicle_Name'];
      iCost := qryGame['Cost'];
      iMaxFuel := qryGame['Fuel_Capacity'];
      iMaxCapacity := qryGame['Load_Capacity'];
      iSpeed := qryGame['Speed'];

      // Create the vehicle and add to the array
      Index := Index + 1;
      arrVehicles[Index] := TVehicle.Create(iVehicleID,sName, iCost, iSpeed, 0, iMaxFuel, iMaxCapacity, 5);

      qryGame.Next;
    end;

  end;
end;

end.
