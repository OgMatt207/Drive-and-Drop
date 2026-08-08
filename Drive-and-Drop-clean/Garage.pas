unit Garage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, pngimage,clsVehicle,clsVehicleController,
  jpeg;

type
  TfrmGarage = class(TForm)
    imgVehicle: TImage;
    imgLogOut: TImage;
    imgNext: TImage;
    imgPrevious: TImage;
    imgSellVehicle: TImage;
    imgDrive: TImage;
    lblName: TLabel;
    lblSpeed: TLabel;
    lblCurrentFuel: TLabel;
    lblVehicleCost: TLabel;
    lblMoney: TLabel;
    lblLoadCapacity: TLabel;
    imgDealership: TImage;
    imgBackground: TImage;
    pnlDetails: TPanel;
    lblArrayIndex: TLabel;
    procedure imgLogOutClick(Sender: TObject);
    procedure imgDriveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgNextClick(Sender: TObject);
    procedure imgPreviousClick(Sender: TObject);
    procedure imgSellVehicleClick(Sender: TObject);
    procedure imgDealershipClick(Sender: TObject);
  private
    { Private declarations }
    arrVehicles : array [0..9] of TVehicle;
    Index : integer;
    CurrentIndex : integer;
    procedure LoadPlayerVehicles(PlayerID : integer);
    procedure LoadDetails();
    procedure LoadVehicleImage(ArrayIndex : integer);
  public
    { Public declarations }
  end;

var
  frmGarage: TfrmGarage;

implementation

uses
Game,DataBase,VehicleDealership,Login;

{$R *.dfm}

procedure TfrmGarage.LoadVehicleImage(ArrayIndex: integer);
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

procedure TfrmGarage.LoadDetails();
begin
//Added units for Fuel and load capacity
  if (CurrentIndex > -1) AND (Index > -1) then
  begin
    lblName.Caption := 'Name: ' + arrVehicles[CurrentIndex].GetName;
    lblSpeed.Caption := 'Speed: ' + IntToStr(arrVehicles[CurrentIndex].GetSpeed);
    lblCurrentFuel.Caption := 'Current Fuel: ' + FloatToStr(arrVehicles[CurrentIndex].GetFuel) + ' L';
    lblLoadCapacity.Caption := 'Load Capacity: ' + IntToStr(arrVehicles[CurrentIndex].GetMaxCapacity) + ' KG';
    lblVehicleCost.Caption := 'Cost: ' + IntToStr(arrVehicles[CurrentIndex].GetCost) + '$';
    lblArrayIndex.Caption := IntToStr(CurrentIndex + 1) + '/' + IntToStr(Index + 1);
    LoadVehicleImage(CurrentIndex);
  end;

end;

procedure TfrmGarage.LoadPlayerVehicles(PlayerID: integer);
var
  SQuery,sName: String;
  i,iVehicleID, iCost, iMaxCapacity, iSpeed: integer;
  iMaxFuel,  iCurrent_Fuel: real;
begin

  //Reset array
  for I := 0 to Length(arrVehicles) - 1 do
  begin
    arrVehicles[I].Free;
  end;

//At least ONE dynamic query using a variable
//At least ONE query involving two tables
  Index := -1;
  SQuery := 'SELECT tblPlayerVehicles.Vehicle_ID, tblPlayerVehicles.Deliveries_Completed, ' +
            'tblPlayerVehicles.Milelage, tblPlayerVehicles.Current_Fuel, ' +
            'tblVehicles.Vehicle_Name, tblVehicles.Load_Capacity, ' +
            'tblVehicles.Fuel_Capacity, tblVehicles.Speed, tblVehicles.Cost ' +
            'FROM tblPlayerVehicles INNER JOIN tblVehicles ON ' + // Perform an INNER JOIN to combine data from both tables
            'tblPlayerVehicles.Vehicle_ID = tblVehicles.Vehicle_ID ' + //Check if Foreign and Primary Key values are the same before Joining
            'WHERE tblPlayerVehicles.Player_ID = ' + IntToStr(PlayerID); // Filter results where Player_ID equals to the specific player)

    //https://www.w3schools.com/Sql/sql_join.asp This explains the JOIN statement so
    //that i only need to use 1 query component and query once since i join relevent data
    //from both tables into one result

  with dbmGame do
  begin
    qryGame.SQL.Text := SQuery;
    qryGame.Open;

    if qryGame.IsEmpty then
    begin
      MessageDlg('You do not have any vehicles. Buy one at the Dealership',mtError,[mbOk],0);
      Exit;
    end;

    qryGame.First;
    //Add all player vehicles into the array
    while not (qryGame.Eof) AND (Index < 9) do
    begin
      iVehicleID := qryGame['Vehicle_ID'];
      iCurrent_Fuel := qryGame['Current_Fuel'];
      sName := qryGame['Vehicle_Name'];
      iCost := qryGame['Cost'];
      iMaxFuel := qryGame['Fuel_Capacity'];
      iMaxCapacity := qryGame['Load_Capacity'];
      iSpeed := qryGame['Speed'];

      // Create the vehicle and add to the array
      Index := Index + 1;
      arrVehicles[Index] := TVehicle.Create(iVehicleID,sName, iCost, iSpeed, iCurrent_Fuel, iMaxFuel, iMaxCapacity, 5);


      qryGame.Next;
    end;

  end;
end;

procedure TfrmGarage.FormShow(Sender: TObject);
begin
  LoadPlayerVehicles(frmGame.PlayerID);
  CurrentIndex := 0;
  LoadDetails;
  lblMoney.Caption := 'Cash: ' + IntToStr(frmGame.PlayerMoney) + '$';
  imgBackground.Width := frmDealership.Width;
  imgBackground.Height := frmDealership.Height;
  imgBackground.SendToBack;
end;

procedure TfrmGarage.imgLogOutClick(Sender: TObject);
begin
  frmGarage.Hide;
  frmLogin.Show;
end;

procedure TfrmGarage.imgNextClick(Sender: TObject);
begin

 if CurrentIndex < Index then
 begin
    Inc(CurrentIndex);
    LoadDetails;
 end
 else begin
  //Wrap around to the beginning of the array
   CurrentIndex := 0;
   LoadDetails;
 end;

end;

procedure TfrmGarage.imgPreviousClick(Sender: TObject);
begin

 if CurrentIndex > 0 then
 begin
    Dec(CurrentIndex);
    LoadDetails;
 end
 else begin
  //Wrap around to the end of the array
   CurrentIndex := Index;
   LoadDetails;
 end;

end;

procedure TfrmGarage.imgSellVehicleClick(Sender: TObject);
var
I : integer;
sQuery : string;
iMoney : integer;
begin
//Delete a record from a table
//Edit selected fields in a record
if Index = 0 then
begin
  MessageDlg('You cannot sell this vehicle, You only have 1 Vehicle.',mtWarning,[mbOk],0);
  Exit;
end
else if Index = -1 then
begin
  MessageDlg('You do not have a vehicle',mtWarning,[mbOk],0);
  frmDealership.Show;
  frmGarage.Hide;
  Exit;
end;

iMoney := arrVehicles[CurrentIndex].getCost div 2; //You get halve the value

//Remove from database
      //Complex selection query, e.g. using AND/OR/LIKE/HAVING
      //At least ONE dynamic query using a variable
sQuery := 'DELETE FROM tblPlayerVehicles WHERE Player_ID = ' + IntToStr(frmGame.PlayerID) + ' AND Vehicle_ID = ' + IntToStr(arrVehicles[CurrentIndex].GetID);
  with dbmGame do
  begin
    qryGame.SQL.Text := SQuery;
    qryGame.ExecSQL;
  end;

//Remove from array
for I := CurrentIndex to Index - 1 do
begin
  arrVehicles[CurrentIndex] := arrVehicles[CurrentIndex + 1];
end;

arrVehicles[Index] := nil;
Dec(Index);

frmGame.PlayerMoney := frmGame.PlayerMoney + iMoney;

//Money Cap
if frmGame.PlayerMoney > 9999 then
begin
  frmGame.PlayerMoney := 9999;
end;

//Update Database
sQuery := 'UPDATE tblPlayers SET [Money] = ' + IntToStr(frmGame.PlayerMoney) + ' WHERE [Player_ID] = ' + IntToStr(frmGame.PlayerID);
  with dbmGame do
  begin
    qryGame.SQL.Text := SQuery;
    qryGame.ExecSQL;
  end;
  lblMoney.Caption := 'Cash: ' + IntToStr(frmGame.PlayerMoney) + '$';

MessageDlg('Car Sold',mtInformation,[mbOk],0);

LoadPlayerVehicles(frmGame.PlayerID);
CurrentIndex := 0;
LoadDetails;
end;

procedure TfrmGarage.imgDealershipClick(Sender: TObject);
begin
frmGarage.Hide;
frmDealership.Show;
end;

procedure TfrmGarage.imgDriveClick(Sender: TObject);
var
SelectedVehicle : TVehicle;
begin

  if Index = -1 then
  begin
    MessageDlg('You do not have a vehicle',mtWarning,[mbOk],0);
    frmDealership.Show;
    frmGarage.Hide;
  end
  else begin
    SelectedVehicle := arrVehicles[CurrentIndex];
                                                  //Spawn Player procedure in frmGame will handle the position of the vehicle
    frmGame.PlayerVehicle := TVehicleController.Create(SelectedVehicle,-1,-1);
    frmGarage.Hide;
    frmGame.Show;
  end;

end;

end.
