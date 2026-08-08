unit Admin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, DBGrids, Spin,IOUtils,PngImage;

type
  TfrmAdmin = class(TForm)
    pgcAdmin: TPageControl;
    Players: TTabSheet;
    btnSaveMap: TButton;
    Vehicles: TTabSheet;
    DeliveryMissions: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    lblAdmin: TLabel;
    btnRemove_Player: TButton;
    btnFleetValue: TButton;
    btnSortUsername: TButton;
    btnResetPlayer: TButton;
    btnDeliveries_Done: TButton;
    lblSort: TLabel;
    lblGeneralStats: TLabel;
    lblSelectedPlayer: TLabel;
    btnAverageDeliveries: TButton;
    pnlMap: TPanel;
    rgpGameObjects: TRadioGroup;
    edtVehicleName: TEdit;
    sedLoadCapacity: TSpinEdit;
    sedSpeed: TSpinEdit;
    sedCost: TSpinEdit;
    btnAddVehicle: TButton;
    btnSortPrice: TButton;
    btnDeleteVehicle: TButton;
    edtImagePath: TEdit;
    btnGetImagePath: TButton;
    imgVehicle: TImage;
    lbxPickUP: TListBox;
    lbxDropOff: TListBox;
    btnPickUpAdd: TButton;
    btnPickUpRemove: TButton;
    btnDropOffAdd: TButton;
    btnDropOffRemove: TButton;
    lblPickUp: TLabel;
    lblDropOff: TLabel;
    edtTimeLimit: TEdit;
    edtReward: TEdit;
    edtMass: TEdit;
    rgpDirection: TRadioGroup;
    imgPickUp: TImage;
    imgDropOff: TImage;
    btnInvalidPoints: TButton;
    lblDeliveryPoints: TLabel;
    lblDeivery: TLabel;
    edtFuelCapacity: TEdit;
    lblTimeLimit: TLabel;
    lblReward: TLabel;
    lblMass: TLabel;
    btnUpdateDelivery: TButton;
    btnAddDelivery: TButton;
    lblID: TLabel;
    imgBack: TImage;
    btnMilelage: TButton;
    lblVehicleName: TLabel;
    lblLoadCapacity: TLabel;
    lblFuelCapacity: TLabel;
    lblSpeed: TLabel;
    lblCost: TLabel;
    lblNote: TLabel;
    btnExpensiveVehiclesOwned: TButton;
    btnSearchUsername: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnRemove_PlayerClick(Sender: TObject);
    procedure btnSortUsernameClick(Sender: TObject);
    procedure btnResetPlayerClick(Sender: TObject);
    procedure btnFleetValueClick(Sender: TObject);
    procedure btnDeliveries_DoneClick(Sender: TObject);
    procedure btnAverageDeliveriesClick(Sender: TObject);
    procedure PlayersShow(Sender: TObject);
    procedure DeliveryMissionsShow(Sender: TObject);
    procedure VehiclesShow(Sender: TObject);
    procedure btnSaveMapClick(Sender: TObject);
    procedure btnSortPriceClick(Sender: TObject);
    procedure btnDeleteVehicleClick(Sender: TObject);
    procedure btnAddVehicleClick(Sender: TObject);
    procedure btnGetImagePathClick(Sender: TObject);
    procedure lbxDropOffClick(Sender: TObject);
    procedure lbxPickUPClick(Sender: TObject);
    procedure btnPickUpRemoveClick(Sender: TObject);
    procedure btnPickUpAddClick(Sender: TObject);
    procedure btnDropOffRemoveClick(Sender: TObject);
    procedure btnDropOffAddClick(Sender: TObject);
    procedure DeliveryMissionsHide(Sender: TObject);
    procedure btnInvalidPointsClick(Sender: TObject);
    procedure rgpGameObjectsClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btnUpdateDeliveryClick(Sender: TObject);
    procedure btnAddDeliveryClick(Sender: TObject);
    procedure imgBackClick(Sender: TObject);
    procedure btnMilelageClick(Sender: TObject);
    procedure lblDeiveryClick(Sender: TObject);
    procedure btnExpensiveVehiclesOwnedClick(Sender: TObject);
    procedure btnSearchUsernameClick(Sender: TObject);
  private
    { Private declarations }
    //Parrell arrays
    arrAdminMap : array [0..9,0..6] of Char;
    arrMapImages : array [0..9,0..6] of TImage;
    //Map Editor
    bAddingPickUp : boolean;
    bAddingDropOff : boolean;
    procedure ImageClicked(Sender : TObject);
    procedure LoadAdminMap;
    function SetImage(sType: string; x,y : integer): TImage;
    procedure RenderAdminMap;
    procedure ShowPickUpImg(iPosx,iPosy : integer);
    procedure ShowDropOffImg(iPosx,iPosy : integer);
    //Database
    procedure ShowPlayerDB;
    procedure ShowVehicleDB;
    procedure ShowDeliveriesDB;
    procedure RotatePngImage(sSourceFilePath,sDestFilePath : string);
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;

const
  MAP_PATH : string = 'Map.txt';
  GRID_WIDTH : integer = 31;
  GRID_HEIGHT : integer = 31;

implementation

{$R *.dfm}

uses
DataBase,Login;

{ TfrmAdmin }

//Map Editor related Code
procedure TfrmAdmin.ShowPickUpImg(iPosX,iPosY: integer);
begin
  imgPickUp.Left := iPosX * GRID_WIDTH + (GRID_WIDTH Div 4);
  imgPickUP.Top := iPosY * GRID_HEIGHT + (GRID_HEIGHT Div 4);
  imgPickUp.Visible := True;
  imgPickUp.Picture.LoadFromFile('PickUp.png');
  imgPickUp.BringToFront;
end;

procedure TfrmAdmin.ShowDropOffImg(iPosX,iPosY: integer);
begin
  imgDropOff.Left := iPosX * GRID_WIDTH + (GRID_WIDTH Div 4);
  imgDropOff.Top := iPosY * GRID_HEIGHT + (GRID_HEIGHT Div 4);
  imgDropOff.Visible := True;
  imgDropOff.Picture.LoadFromFile('DropOff.png');
  imgDropOff.BringToFront;
end;

procedure TfrmAdmin.LoadAdminMap;
var
tMap : textfile;
sLine : string;
X,Y,i : integer;      //x means columns and y means rows
begin

  Y := 0;

  if not FileExists(MAP_PATH) then
  begin
    MessageDlg('Error!,' + MAP_PATH + 'not found. Make a file',mtError,[mbOk],0);
  end
  else begin
    AssignFile(tMAp,MAP_PATH);
    Reset(tMap);

    while not Eof(tMap) do
    begin
      ReadLn(tMap,sLine);
      X := 0;

      for I := 1 to Length(sLine) do
        begin
          case sLine[I] of
          'R','B','T','X','G','F' :
            begin
              if x > 9 then break; //Make sure to only copy within array bounds
              arrAdminMap[x,y] := sLine[I];
            end;
          ' ' :  arrAdminMap[x,y] := 'X'//Place holder;
          end;
          x := x + 1;
        end;

      Inc(Y);
      if y > 6 then break;  //Make sure to only copy within array bounds

    end;
  end;

  CloseFile(tMap);

end;

function TfrmAdmin.SetImage(sType: string; x,y : integer): TImage;
var
GameObjectImage : TImage;
begin

GameObjectImage := TImage.Create(Self);

with GameObjectImage do
begin
  Parent := pnlMap;
  Left := x * GRID_WIDTH;
  Top := y * GRID_HEIGHT;
  Width :=  GRID_WIDTH;
  Height := GRID_HEIGHT;
  Picture.LoadFromFile(sType + '.png');
  Visible := True;
  Stretch := True;
  Enabled := True;
  OnClick := ImageClicked;
end;
Result := GameObjectImage;

end;

procedure TfrmAdmin.RenderAdminMap;
var
x,y : integer;
begin
  //Loop by columns first
  for x := 0 to 9 do
  begin
    for y := 0 to 6 do   //then rows
    begin
      if arrAdminMap[x,y] <> ' ' then
      begin
          case arrAdminMap[x,y] of
          'R' : arrMapImages[x,y] := SetImage('Road',x,y);
          'B' : arrMapImages[x,y] := SetImage('Building',x,y);
          'T' : arrMapImages[x,y] := SetImage('Tree',x,y);
          'X' : arrMapImages[x,y] := SetImage('Barrier',x,y);
          'G' : arrMapImages[x,y] := SetImage('Garage',x,y);
          'F' : arrMapImages[x,y] := SetImage('Fuel Station',x,y);
          end;
      end;
    end;
  end;

end;

procedure TfrmAdmin.ImageClicked(Sender: TObject);
var
ClickedImage : TImage;
x,y : integer; //Indexes for array
sQuery,sType : string; //For adding a PickUp or DropOff point on the clicked image location
begin

ClickedImage := TImage(Sender); //Store the image that was clicked

//Get Grid/Index position by doing the reverse when setting the images position in SetImage()
x := ClickedImage.Left div GRID_WIDTH;
y := ClickedImage.Top div GRID_HEIGHT;

  // First validate that the click/Index is within the array/Map bounds
  if (x < 0) or (x > 9) or (y < 0) or (y > 6) then
  begin
    Exit;
  end;
    //Check if Admin is not trying to add a new delivery point
    if (bAddingPickUp = False) AND (bAddingDropOff = False) then
    begin
      //Change Map and Image Data

      case rgpGameObjects.ItemIndex of
        -1 : begin
          MessageDlg('Select a Game Object to change to.',mtWarning,[mbOK],0);
          Exit;
        end;
        0 : begin
          arrAdminMap[x,y] := 'R';
          arrMapImages[x,y] := SetImage('Road',x,y);
        end;
        1 : begin
          arrAdminMap[x,y] := 'B';
          arrMapImages[x,y] := SetImage('Building',x,y);
        end;
        2 : begin
          arrAdminMap[x,y] := 'X';
          arrMapImages[x,y] := SetImage('Barrier',x,y);
        end;
        3 : begin
          arrAdminMap[x,y] := 'T';
          arrMapImages[x,y] := SetImage('Tree',x,y);
        end;
        4 : begin
          arrAdminMap[x,y] := 'G';
          arrMapImages[x,y] := SetImage('Garage',x,y);
        end;
        5 : begin
          arrAdminMap[x,y] := 'F';
          arrMapImages[x,y] := SetImage('Fuel Station',x,y);
        end;
      end;

    end //The admin is adding a new delivery point
    else begin

      //Validate Position
      if arrAdminMap[x,y] = 'R' then
      begin

        if (bAddingPickUP = True) AND (bAddingDropOff = False) then
        begin
          sType := 'PickUp';
        end
        else if (bAddingDropOff = True) AND(bAddingPickUp = False) then
        begin
          sType := 'DropOff';
        end
        else begin
          MessageDlg('An error has occured',mtError,[mbOk],0);
          Exit;
        end;


        sQuery := 'INSERT INTO tblLocations (Type,PosX,PosY)'
                 +' VALUES("' + sType + '",' + IntToStr(X) + ',' + IntToStr(Y) + ')';
        dbmGame.qryGame.SQL.Text := SQuery;
        dbmGame.qryGame.ExecSQL;

        bAddingPickUP := False;
        bAddingDropOff := False;

        //Show Delivery point Image
        if sType = 'PickUP' then
        begin
          ShowPickUpImg(x,y);
        end
        else if sType = 'DropOff' then
        begin
          ShowDropOffImg(x,y);
        end;

        //Update listbox and table
        ShowDeliveriesDB;
        DeliveryMissionsShow(Self);

      end
      else begin
        MessageDlg('You can only add a delivery point on a road',mtWarning,[mbOk],0);
      end;

    end;

end;

procedure TfrmAdmin.imgBackClick(Sender: TObject);
begin
frmAdmin.Hide;
frmLogin.Show;
end;

procedure TfrmAdmin.rgpGameObjectsClick(Sender: TObject);
begin
imgPickUP.Visible := False;
imgDropOff.Visible := False;
imgPickUp.Enabled := False;
imgDropOff.Enabled := False;
bAddingPickUp := False;
bAddingDropOff := False;

end;

procedure TfrmAdmin.btnSaveMapClick(Sender: TObject);
var
x,y : integer;
sLine : string;
tMap : textfile;
begin

if not FileExists(MAP_PATH) then
begin
  MessageDlg('Error!,' + MAP_PATH + 'not found. Make a file',mtError,[mbOk],0);
  Exit;
end;

AssignFile(tMAp,MAP_PATH);
Rewrite(tMap);

//We loop by getting the entire characters of row first of the array then move to next row
for y := 0 to 6 do //thats why we put rows first
begin
  for x := 0 to 9 do //Copy current row (columns) into the string
  begin
    sLine := sLine + arrAdminMap[x,y];
  end;
  Writeln(tMap,sLine);
  sLine := '';
end;

CloseFile(tMap);
Messagedlg('Map saved',mtInformation,[mbOk],0);

end;

//Player Database related Code
procedure TfrmAdmin.ShowPlayerDB;
var
sQuery : string;
begin

sQuery := 'SELECT * FROM tblPlayers';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;
  //selecing a reocrd
procedure TfrmAdmin.btnRemove_PlayerClick(Sender: TObject);
var
sQuery : string;
iPlayerID : integer;
begin
//Delete a record from a table
  //Get the selected record's primary key
iPlayerID := DBGrid3.DataSource.DataSet['Player_ID'];

sQuery := 'DELETE FROM tblPlayers WHERE Player_ID = '+ IntToStr(iPlayerID);
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

sQuery := 'DELETE FROM tblPlayerVehicles WHERE Player_ID = '+ IntToStr(iPlayerID);
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

ShowPlayerDB;

end;

procedure TfrmAdmin.btnResetPlayerClick(Sender: TObject);
var
sQuery : string;
iPlayerID : integer;
begin
//Delete a record from a table
//Edit selected fields in a record

  //Get the selected record's primary key
iPlayerID := DBGrid3.DataSource.DataSet['Player_ID'];
//Reset Player's money
sQuery := 'UPDATE tblPlayers SET [Money] = 0 WHERE [Player_ID] = '+ IntToStr(iPlayerID);
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;
//Delete Player's Vehicles
sQuery := 'DELETE FROM tblPlayerVehicles WHERE Player_ID = '+ IntToStr(iPlayerID);
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

ShowPlayerDB;

end;

procedure TfrmAdmin.btnSearchUsernameClick(Sender: TObject);
var
sQuery,sString : string;
begin
//Complex selection query, e.g. using AND/OR/LIKE/HAVING
//Search for data in a table
sString := Inputbox('Searching Player','Enter characters you want to search','');
sQuery := 'SELECT * FROM tblPlayers WHERE username LIKE "%' + sString + '%"';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;
end;
  //Sorting data
procedure TfrmAdmin.btnSortUsernameClick(Sender: TObject);
var
sQuery : string;
begin
//Sort records in a table
sQuery := 'SELECT * FROM tblPlayers ORDER BY username';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

procedure TfrmAdmin.btnDeliveries_DoneClick(Sender: TObject);
var
sQuery : string;
begin
//At least TWO queries using calculations, such as minimum, maximum, sum and average
//At least ONE query involving two tables
sQuery := 'SELECT username, COUNT(*) AS [Amount of vehicles owned], SUM(Deliveries_Completed) AS [Total Deliveries Done] '
        + 'FROM tblPlayers, tblPlayerVehicles WHERE tblPlayers.Player_ID = tblPlayerVehicles.Player_ID '
        + 'Group By username ORDER BY SUM(Deliveries_Completed) DESC';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

procedure TfrmAdmin.btnMilelageClick(Sender: TObject);
var
sQuery : string;
begin
//At least TWO queries using calculations, such as minimum, maximum, sum and average
//At least ONE query involving two tables
sQuery := 'SELECT username, SUM(Milelage) AS [Total Distance Driven] '
        + 'FROM tblPlayers, tblPlayerVehicles WHERE tblPlayers.Player_ID = tblPlayerVehicles.Player_ID '
        + 'Group By username ORDER BY SUM(Milelage) DESC';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;
end;

  //Showing Stats
procedure TfrmAdmin.btnFleetValueClick(Sender: TObject);
var
sQuery : string;
begin
//At least TWO queries using calculations, such as minimum, maximum, sum and average
//At least ONE query involving two tables
//Shows the total value of vehicles that the player owns
sQuery := 'SELECT username, FORMAT(SUM(Cost),"0$") AS [Fleet Value] FROM tblPlayers,tblPlayerVehicles,tblVehicles '
          + 'WHERE tblPlayerVehicles.Vehicle_ID = tblVehicles.Vehicle_ID '
          + 'AND tblPlayers.Player_ID = tblPlayerVehicles.Player_ID '
          + 'GROUP BY username ORDER BY SUM(Cost) DESC';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

procedure TfrmAdmin.btnAverageDeliveriesClick(Sender: TObject);
var
sQuery : string;
iPlayerCount : integer;
begin
//At least TWO queries using calculations, such as minimum, maximum, sum and average
//At least ONE query involving two tables
ShowPlayerDB;//will shows all Players
iPlayerCount := dbmGame.qryGame.RecordCount;

if iPlayerCount = 0 then
begin
  MessageDlg('No players found in tblPlayers',mtError,[mbOK],0);
  Exit;
end;

sQuery := 'SELECT SUM(Deliveries_Completed) AS [Total Deliveries Done], '
        + '"' + IntToStr(iPlayerCount) + '" AS [Total Players], '
        + 'FORMAT(SUM(Deliveries_Completed)/' + IntToStr(iPlayerCount) + ',"0.00") AS [Average Deliveries Done Per Player] '
        + 'FROM tblPlayers,tblPlayerVehicles WHERE tblPlayers.Player_ID = tblPlayerVehicles.Player_ID';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

//Vehicles Database related Code
procedure TfrmAdmin.ShowVehicleDB;
var
sQuery : string;
begin

sQuery := 'SELECT * FROM tblVehicles';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

procedure TfrmAdmin.btnGetImagePathClick(Sender: TObject);
var
Dialog : TOpenDialog;
begin

Dialog := TOpenDialog.Create(self);
Dialog.Filter := 'All Video Files (*.png)|*.png';

if Dialog.Execute then
begin
  edtImagePath.Text := Dialog.FileName;
  if FileExists(edtImagePath.Text) then
  begin

  end;
  ImgVehicle.Picture.LoadFromFile(edtImagePath.Text);
end;

end;

procedure TfrmAdmin.RotatePngImage(sSourceFilePath, sDestFilePath: string);
var
PngImage : TPngImage;
BitMap,RotatedBitMap : TBitMap;
x: Integer;
y: Integer;
begin

//Create objects
PngImage := TPngImage.Create;
BitMap := TBitMap.Create;
RotatedBitMap := TBitMap.Create;


PngImage.LoadFromFile(sSourceFilePath);

//Convert PngImage to the BitMap
BitMap.Assign(PngImage);
BitMap.PixelFormat := pf32bit;

//Intialise RotatedBitmAp
RotatedBitMap.Height := BitMap.Width;
RotatedBitMap.Width := BitMap.Height;
RotatedBitMap.PixelFormat := pf32bit;

//Rotate BitMap by 90
  for y := 0 to BitMap.Height - 1 do
  begin

    for x := 0 to BitMap.Width - 1 do
    begin         //The Colour of the old pixel will be copied to the rotated position
      RotatedBitMap.Canvas.Pixels[BitMap.Height - 1 - y,x] := Bitmap.Canvas.Pixels[x, y]
    end;

  end;

// Save the rotated image as PNG
PngImage.Assign(RotatedBitmap);
PngImage.SaveToFile(sDestFilePath);

end;

procedure TfrmAdmin.btnAddVehicleClick(Sender: TObject);
var
sName,sDirection,sSourcePath,sDestPath,sQuery : string;
iLoadCapacity,iSpeed,iCost : integer;
rFuelCapacity : real;
bImageSuccess : boolean;
begin
//Insert a new record to a table
bImageSuccess := True;
sName := edtVehicleName.Text;
iLoadCapacity := sedLoadCapacity.Value;
//Validation
try
  rFuelCapacity := StrToFloat(edtFuelCapacity.Text);
except
  MessageDlg('Fuel capacity must be a real number',mtError,[mbOK],0);
  Exit;
end;

iSpeed := sedSpeed.Value;
iCost := sedCost.Value;
//Validation
if (iCost > 9999) OR (iCost < 0) then
begin
  MessageDlg('Cost must be less than 10000$ and more than 0$',mtWarning,[mbOK],0);
  Exit;
end;

sSourcePath := edtImagePath.Text;

//Check if name already exists
sQuery := 'SELECT Vehicle_Name FROM tblVehicles WHERE Vehicle_Name = "' + sName + '"';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;


if Not dbmGame.qryGame.IsEmpty then
begin
  MessageDlg('Vehicle name already exists',mtWarning,[mbOk],0);
  ShowVehicleDB;
  Exit;
end;

//Confirmation
if MessageDlg('Add new Vehicle?',mtWarning,[mbYes,mbNo],0) = mrNo then
begin
  MessageDlg('Cancelled.',mtInformation,[mbOk],0);
  Exit;
end;

//Add to Database
sQuery := 'Insert INTO tblVehicles ([Vehicle_Name] ,[Load_Capacity], [Fuel_Capacity], [Speed], [Cost]) Values ('
        + '"' + sName + '",'
        + IntToStr(iLoadCapacity) + ','
        + StringReplace(
                FloatToStrF(rFuelCapacity, ffFixed, 8, 2),
                ',', '.', [rfReplaceAll]) + ','
        + IntToStr(iSpeed) + ','
        + IntToStr(iCost) + ')';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.ExecSQL;

//Copy the image to the project folder
 //Validation
  if rgpDirection.ItemIndex <> -1 then
  begin
    sDirection := rgpDirection.Items[rgpDirection.ItemIndex];
  end
  else MessageDlg('Direction not selected',mtWarning,[mbOk],0);
                                    //Chosen Direction
  sDestPath := 'Vehicles\' + sName + '_' + sDirection + '.png';
 //Validation
  if FileExists(sSourcePath) then
  begin

   imgVehicle.Picture.LoadFromFile(sSourcePath);

    try
      TFile.Copy(sSourcePath, sDestPath, True);
    except
      MessageDlg('Failed to copy vehicle image to the game folder',mtError,[mbOK],0);
      bImageSuccess := False;
    end;

    //Create 3 other images that are rotated from the original
    case rgpDirection.ItemIndex of
    0 : begin // Up
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Right.png');
      sDestPath := 'Vehicles\' + sName + '_Right.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Down.png');
      sDestPath := 'Vehicles\' + sName + '_Down.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Left.png');
    end;
    1 : begin // Right
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Down.png');
      sDestPath := 'Vehicles\' + sName + '_Down.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Left.png');
      sDestPath := 'Vehicles\' + sName + '_Left.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Up.png');
    end;
    2 : begin // Down
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Left.png');
      sDestPath := 'Vehicles\' + sName + '_Left.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Up.png');
      sDestPath := 'Vehicles\' + sName + '_Up.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + '_Right.png');
    end;
    3 : begin // Left
      RotatePngImage(sDestPath,'Vehicles\' + sName + 'Up.png');
      sDestPath := 'Vehicles\' + sName + '_Up.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + 'Right.png');
      sDestPath := 'Vehicles\' + sName + '_Right.png';
      RotatePngImage(sDestPath,'Vehicles\' + sName + 'Down.png');
    end
    else MessageDlg('Direction not selected',mtWarning,[mbOk],0);
    end; //Case

  end // If fileExists
  else begin
    MessageDlg('File not found.',mtWarning,[mbOk],0);
    bImageSuccess := False;
  end;

  if bImageSuccess = False then
  begin
    MessageDlg('Failed to make Vehicle images. Manually put the png images in the Vehicles Folder',mtError,[mbOK],0);
  end
  else begin
    MessageDlg('Vehicle and images successfully added',mtInformation,[mbOK],0);
  end;

  ShowVehicleDB;

end;

procedure TfrmAdmin.btnSortPriceClick(Sender: TObject);
var
sQuery : string;
begin
//Sort records in a table
sQuery := 'SELECT * FROM tblVehicles ORDER BY Cost';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

procedure TfrmAdmin.btnExpensiveVehiclesOwnedClick(Sender: TObject);
var
sQuery : string;
begin
//Complex selection query, e.g. using AND/OR/LIKE/HAVING
sQuery := 'SELECT Vehicle_Name, Cost, COUNT(*) AS [Number of players] ' +
          'FROM tblVehicles, tblPlayerVehicles ' +
          'WHERE tblPlayerVehicles.Vehicle_ID = tblVehicles.Vehicle_ID ' +
          'GROUP BY Vehicle_Name, Cost ' +
          'HAVING Cost >= 1000';

with dbmGame do
begin
  qryGame.SQL.Text := sQuery;
  qryGame.Open;
end;

end;

procedure TfrmAdmin.btnDeleteVehicleClick(Sender: TObject);
var
sQuery : string;
iVehicleID : integer;
begin
//Delete a record from a table
iVehicleID := DBGrid2.DataSource.DataSet['Vehicle_ID'];

if MessageDlg('Delete Vehicle ID:' + IntToStr(iVehicleID) + '?',mtWarning,[mbYes,mbNo],0) = mrNo then
begin
  MessageDlg('Cancelled.',mtInformation,[mbOk],0);
  Exit;
end;

sQuery := 'DELETE FROM tblVehicles WHERE Vehicle_ID = ' + IntToStr(iVehicleID);
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.ExecSQL;

sQuery := 'DELETE FROM tblPlayerVehicles WHERE Vehicle_ID = ' + IntToStr(iVehicleID);
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.ExecSQL;

MessageDlg('Vehicle deleted from the game.',mtInformation,[mbOk],0);

ShowVehicleDB;

end;

//Deliveries Database related Code
procedure TfrmAdmin.ShowDeliveriesDB;
var
sQuery : string;
begin

sQuery := 'SELECT * FROM tblDeliveries';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

end;

procedure TfrmAdmin.lblDeiveryClick(Sender: TObject);
begin
ShowDeliveriesDB;
end;

procedure TfrmAdmin.DBGrid1CellClick(Column: TColumn);
var
sPickUpID,sDropOffID : string;
I: Integer;
begin

edtTimeLimit.Text := DBGrid1.DataSource.DataSet['TimeLimit'];
edtReward.Text := DBGrid1.DataSource.DataSet['Reward'];
edtMass.Text := DBGrid1.DataSource.DataSet['Mass'];
lblID.Caption := DBGrid1.DataSource.DataSet['Delivery_ID'];
lblID.Visible := True;

sPickUpID := DBGrid1.DataSource.DataSet['PickUP_ID'];
sDropOffID := DBGrid1.DataSource.DataSet['DropOff_ID'];

//Get the listbox indexes
lbxPickUP.ItemIndex := 0;
lbxDropOff.ItemIndex := 0;

for I := 0 to lbxPickUP.Items.Count - 1 do
begin
  if lbxPickUP.Items[I] = sPickUPID then
  begin
    lbxPickUP.ItemIndex := I;
  end;
end;

for I := 0 to lbxDropOff.Items.Count - 1 do
begin
  if lbxDropOff.Items[I] = sDropOffID then
  begin
    lbxDropOff.ItemIndex := I;
  end;
end;

//Then Show PickUP and DropOff points on the map
lbxPickUPClick(Self);
lbxDropOffClick(Self);

btnUpdateDelivery.Enabled := True;
btnAddDelivery.Enabled := False;

end;

procedure TfrmAdmin.btnAddDeliveryClick(Sender: TObject);
var
iTimeLimit,iReward,iMass,PickUP_ID,DropOff_ID : integer;
iPosx,iPosy : integer;
sQuery : string;
begin
//Insert a new record to a table
if MessageDlg('Add new delivery?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
begin
  //Reset Input
  MessageDlg('Cancelled',mtInformation,[mbOK],0);
  edtTimeLimit.Text := '';
  edtReward.Text := '';
  edtMass.Text := '';
  //Show Locations images
  imgPickUP.Visible := False;
  imgDropOff.Visible := False;
  ShowDeliveriesDB;
  Exit;
end;

//Validate input
if (edtTimeLimit.Text <> '') AND (edtReward.Text <> '') AND (edtMass.Text <> '') then
begin
  iTimeLimit := StrToInt(edtTimeLimit.Text);
  iReward := StrToInt(edtReward.Text);
  iMass := StrToInt(edtMass.Text)
end
else begin
  MessageDlg('Do not leave any fields empty!',mtWarning,[mbOk],0);
  Exit;
end;
//Validation
if (lbxPickUP.ItemIndex = -1) OR (lbxDropOff.ItemIndex = -1) then
begin
  MessageDlg('Select PickUP and DropOff locations from the listboxes',mtWarning,[mbOK],0);
  Exit;
end;

PickUP_ID := StrToInt(lbxPickUP.Items[lbxPickUP.ItemIndex]);
DropOff_ID := StrToInt(lbxDropOff.Items[lbxDropOff.ItemIndex]);

//Validate PickUP and DropOff to see if they are not in the same location
  //Get the 2 records from tblLocation
sQuery := 'SELECT Posx,Posy FROM tblLocations WHERE Location_ID = ' + IntToStr(PickUP_ID)
          + ' OR Location_ID = ' + IntToStr(DropOff_ID);
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;


dbmGame.qryGame.First;
//Location 1
iPosx := dbmGame.qryGame['Posx'];
iPosy := dbmGame.qryGame['Posy'];
dbmGame.qryGame.Next; //Location 2

if (iPosx = dbmGame.qryGame['Posx']) AND (iPosy = dbmGame.qryGame['Posy']) then
begin
  MessageDlg('PickUp and DropOff Locations are at the same position!',mtWarning,[mbOK],0);
  Exit;
end;

//Add new Delivery
sQuery := 'INSERT INTO tblDeliveries (PickUP_ID,DropOff_ID,TimeLimit,Reward,Mass) Values('
          + IntToStr(PickUP_ID) + ','
          + IntToStr(DropOff_ID) + ','
          + IntToStr(iTimeLimit) + ','
          + IntToStr(iReward) + ','
          + IntToStr(iMass)
          + ')';

dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.ExecSQL;

ShowDeliveriesDB;

MessageDlg('Delivery added',mtInformation,[mbOK],0);
//Reset Input
edtTimeLimit.Text := '';
edtReward.Text := '';
edtMass.Text := '';
//Reset Locations images
imgPickUP.Visible := False;
imgDropOff.Visible := False;
imgPickUp.Enabled := False;
imgDropOff.Enabled := False;
end;

procedure TfrmAdmin.btnUpdateDeliveryClick(Sender: TObject);
var
iTimeLimit,iReward,iMass,PickUP_ID,DropOff_ID : integer;
iPosx,iPosy : integer;
sQuery : string;
begin
//Edit selected fields in a record
if MessageDlg('Update selected delivery?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
begin
  //Reset Input
  MessageDlg('Cancelled',mtInformation,[mbOK],0);
  edtTimeLimit.Text := '';
  edtReward.Text := '';
  edtMass.Text := '';
  lblID.Visible := False;
  btnUpdateDelivery.Enabled := False;
  btnAddDelivery.Enabled := True;
  //Hide Locations images
  imgPickUP.Visible := False;
  imgDropOff.Visible := False;
  ShowDeliveriesDB;
  Exit;
end;

//Validate input
if (edtTimeLimit.Text <> '') AND (edtReward.Text <> '') AND (edtMass.Text <> '') then
begin
  iTimeLimit := StrToInt(edtTimeLimit.Text);
  iReward := StrToInt(edtReward.Text);
  iMass := StrToInt(edtMass.Text)
end
else begin
  MessageDlg('Do not leave any fields empty!',mtWarning,[mbOk],0);
  Exit;
end;

PickUP_ID := StrToInt(lbxPickUP.Items[lbxPickUP.ItemIndex]);
DropOff_ID := StrToInt(lbxDropOff.Items[lbxDropOff.ItemIndex]);

//Validate PickUP and DropOff to see if they are not in the same location
  //Get the 2 records from tblLocation
sQuery := 'SELECT Posx,Posy FROM tblLocations WHERE Location_ID = ' + IntToStr(PickUP_ID)
          + ' OR Location_ID = ' + IntToStr(DropOff_ID);
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;


dbmGame.qryGame.First;//Location 1
iPosx := dbmGame.qryGame['Posx'];
iPosy := dbmGame.qryGame['Posy'];
dbmGame.qryGame.Next; //Location 2

if (iPosx = dbmGame.qryGame['Posx']) AND (iPosy = dbmGame.qryGame['Posy']) then
begin
  MessageDlg('PickUp and DropOff Locations are at the same position!',mtWarning,[mbOK],0);
  Exit;
end;

//Update Delivery
sQuery := 'UPDATE tblDeliveries SET ' +
          '[PickUp_ID] = ' + IntToStr(PickUP_ID) + ',' +
          '[DropOff_ID] = ' + IntToStr(DropOff_ID) + ',' +
          '[TimeLimit] = ' + IntToStr(iTimeLimit) + ',' +
          '[Reward] = ' + IntToStr(iReward) + ',' +
          '[Mass] = ' + IntToStr(iMass) +
          ' WHERE Delivery_ID = ' + lblID.Caption;

dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.ExecSQL;

ShowDeliveriesDB;

MessageDlg('Update succesfull',mtInformation,[mbOK],0);
//Reset Input
edtTimeLimit.Text := '';
edtReward.Text := '';
edtMass.Text := '';
lblID.Visible := False;
btnUpdateDelivery.Enabled := False;
btnAddDelivery.Enabled := True;
//Reset Locations images
imgPickUP.Visible := False;
imgDropOff.Visible := False;
imgPickUp.Enabled := False;
imgDropOff.Enabled := False;

end;

//Delivery points/tblLocations related code
procedure TfrmAdmin.btnInvalidPointsClick(Sender: TObject);
var
sQuery : String;
PK,Posx,Posy,iCount,I : integer;
arrLocationPKs : array of integer;
begin
iCount := 0;
SetLength(arrLocationPKs,0);

sQuery := 'SELECT * FROM tblLocations';
with dbmGame do
begin
  qryGame.SQL.Text := sQuery;
  qryGame.Open;

  qryGame.First;

  while not(qryGame.Eof) do
  begin
    PK := qryGame['Location_ID'];
    Posx := qryGame['PosX'];
    Posy := qryGame['PosY'];

    if arrAdminMap[Posx,Posy] <> 'R' then
    begin
      SetLength(arrLocationPKs,Length(arrLocationPKs) + 1);
      arrLocationPKs[iCount] := PK;
      Inc(iCount);
    end;

    qryGame.Next;
  end;

end;

if iCount = 0 then
begin
  MessageDlg('All delivery points are valid',mtInformation,[mbOk],0);
end
else begin

    for I := 0 to iCount do
    begin
      //Delete Deliveries that contain an invalid Point
      sQuery := 'DELETE FROM tblDeliveries WHERE PickUP_ID = ' + IntToStr(arrLocationPKs[I]) + ' OR DropOff_ID = ' + IntToStr(arrLocationPKs[I]);
      dbmGame.qryGame.SQL.Text := SQuery;
      dbmGame.qryGame.ExecSQL;
      //Delete invaid Point
      sQuery := 'DELETE FROM tblLocations WHERE Location_ID = ' + IntToStr(arrLocationPKs[I]);
      dbmGame.qryGame.SQL.Text := SQuery;
      dbmGame.qryGame.ExecSQL;
    end;

    MessageDlg(IntToStr(iCount) + ' invalid delivery points deleted',mtInformation,[mbOk],0);
end;

//Update listbox and table
ShowDeliveriesDB;
DeliveryMissionsShow(Self);

end;

procedure TfrmAdmin.btnPickUpAddClick(Sender: TObject);
begin
bAddingPickUP := True;
bAddingDropOff := False;
imgPickUp.Visible := False;
lbxPickUp.ItemIndex := -1;
end;

procedure TfrmAdmin.btnDropOffAddClick(Sender: TObject);
begin
bAddingDropOff := True;
bAddingPickUP := False;
imgDropOff.Visible := False;
lbxDropOff.ItemIndex := -1;
end;

procedure TfrmAdmin.btnPickUpRemoveClick(Sender: TObject);
var
LocationID : string;
sQuery : string;
begin

if lbxPickUp.ItemIndex = -1 then
begin
  MessageDlg('Select PickUP Point from the listobx',mtWarning,[mbOk],0);
  Exit;
end;

LocationID := lbxPickUP.Items[lbxPickUP.ItemIndex];

//Delete Deliveries that contain the Delivery Point
sQuery := 'DELETE FROM tblDeliveries WHERE PickUP_ID = ' + LocationID + ' OR DropOff_ID = ' + LocationID;
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

sQuery := 'DELETE FROM tblLocations WHERE Location_ID = ' + LocationID;
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

lbxPickUP.Items.Delete(lbxPickUP.ItemIndex);

ShowDeliveriesDB;

end;

procedure TfrmAdmin.btnDropOffRemoveClick(Sender: TObject);
var
LocationID : string;
sQuery : string;
begin

if lbxDropOff.ItemIndex = -1 then
begin
  MessageDlg('Select DropOff Point from the listobx',mtWarning,[mbOk],0);
  Exit;
end;

LocationID := lbxDropOff.Items[lbxDropOff.ItemIndex];

//Delete Deliveries that contain the Delivery Point
sQuery := 'DELETE FROM tblDeliveries WHERE PickUP_ID = ' + LocationID + ' OR DropOff_ID = ' + LocationID;
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

sQuery := 'DELETE FROM tblLocations WHERE Location_ID = ' + LocationID;
dbmGame.qryGame.SQL.Text := SQuery;
dbmGame.qryGame.ExecSQL;

lbxDropOff.Items.Delete(lbxDropOff.ItemIndex);

ShowDeliveriesDB;

end;

procedure TfrmAdmin.lbxPickUPClick(Sender: TObject);
var
LocationID : integer;
sQuery : string;
Posx,Posy : integer;
begin

if lbxPickUP.ItemIndex <> -1 then
begin
  LocationID := StrToInt(lbxPickUP.Items[lbxPickUP.ItemIndex]);

  sQuery := 'SELECT Posx,PosY FROM tblLocations WHERE Location_ID = ' + IntToStr(LocationID);
  dbmGame.qryGame.SQL.Text := sQuery;
  dbmGame.qryGame.Open;

  Posx := dbmGame.qryGame['PosX'];
  Posy := dbmGame.qryGame['PosY'];

  ShowPickUpImg(Posx,Posy);
end;

end;

procedure TfrmAdmin.lbxDropOffClick(Sender: TObject);
var
LocationID : integer;
sQuery : string;
Posx,Posy : integer;
begin

if lbxDropOff.ItemIndex <> -1 then
begin
  LocationID := StrToInt(lbxDropOff.Items[lbxDropOff.ItemIndex]);

  sQuery := 'SELECT Posx,PosY FROM tblLocations WHERE Location_ID = ' + IntToStr(LocationID);
  dbmGame.qryGame.SQL.Text := sQuery;
  dbmGame.qryGame.Open;

  Posx := dbmGame.qryGame['PosX'];
  Posy := dbmGame.qryGame['PosY'];
                                            //Show in the center of Grid
  ShowDropOffImg(Posx,Posy);
end;

end;

//Tabsheets and Form show code
procedure TfrmAdmin.FormShow(Sender: TObject);
begin
//intialize images
imgPickUp.Width := 15;
imgPickUp.Height := 15;
imgDropOff.Width := 15;
imgDropOff.Height := 15;
imgPickUP.Visible := True;
imgDropOff.Visible := True;
imgPickUp.Enabled := True;
imgDropOff.Enabled := True;

bAddingPickUP := False;
bAddingDropOff := False;

LoadAdminMap;
RenderAdminMap;
ShowPlayerDB;
end;

procedure TfrmAdmin.PlayersShow(Sender: TObject);
begin
  ShowPlayerDB;
end;

procedure TfrmAdmin.VehiclesShow(Sender: TObject);
begin
ShowVehicleDB;
end;

procedure TfrmAdmin.DeliveryMissionsHide(Sender: TObject);
begin

bAddingPickUp := False;
bAddingDropOff := False;

end;

procedure TfrmAdmin.DeliveryMissionsShow(Sender: TObject);
var
sQuery : string;
begin
ShowDeliveriesDb;
lbxPickUp.Items.Clear;
lbxDropOff.Items.Clear;
//Load Delivery points when Delivery tab is shown
sQuery := 'SELECT Location_ID,Type FROM tblLocations';
dbmGame.qryGame.SQL.Text := sQuery;
dbmGame.qryGame.Open;

  with dbmGame do
  begin
    qryGame.First;

    while not(qryGame.Eof) do
    begin

      if qryGame['Type'] = 'PickUp' then
      begin
        lbxPickUP.Items.Add(IntToStr(qryGame['Location_ID']));
      end
      else if qryGame['Type'] = 'DropOff' then
      begin
        lbxDropOff.Items.Add(IntToStr(qryGame['Location_ID']));
      end;

      qryGame.Next

    end;

  end;

  ShowDeliveriesDB;

end;

end.
