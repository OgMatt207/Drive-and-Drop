unit DeliveryTab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, clsDelivery, clsDeliveryPoint, DB, DBTables;

type
  TfrmDeliveries = class(TForm)
    lbxDeliveries: TListBox;
    btnDelivery: TButton;
    btnClose: TButton;
    lblMaxLoad: TLabel;
    lblCargoType: TLabel;
    lblReward: TLabel;
    lblTime: TLabel;
    lblMass: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnDeliveryClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbxDeliveriesClick(Sender: TObject);
  private
    { Private declarations }
    arrDeliveries: array of TDelivery;
    procedure LoadDeliveries;
    procedure ClearDeliveries;
  public
    { Public declarations }
  end;

var
  frmDeliveries: TfrmDeliveries;
  arrCargoType : array [0..9] of string = ('Mail','Food','Electronics','Confidential Documents','Tools','Spare Parts','Medical Supplies','Frozen Goods','Pallets','Packages');

Const
  GRID_WIDTH : integer = 136;
  GRID_HEIGHT : integer = 101;

implementation

uses
  Game, DataBase;

{$R *.dfm}

procedure TfrmDeliveries.FormShow(Sender: TObject);
var
  I: Integer;
begin
  lbxDeliveries.Items.Clear;
  ClearDeliveries;
  LoadDeliveries;

  // Populate ListBox with delivery details
  for I := 0 to Length(arrDeliveries) - 1 do
  begin
    lbxDeliveries.Items.Add(arrDeliveries[I].GetCargoType);
  end;
//Added units for load capacity
  lblMaxLoad.Caption := 'Max load on current vehicle: ' + IntToStr(frmGame.PlayerVehicle.GetVehicle.GetMaxCapacity) + ' KG';
end;

procedure TfrmDeliveries.lbxDeliveriesClick(Sender: TObject);
begin
//Added units
 if lbxDeliveries.ItemIndex <> -1 then
 begin
   lblCargoType.Caption := 'Type: ' + arrDeliveries[lbxDeliveries.ItemIndex].GetCargoType;
   lblReward.Caption := 'Reward: ' + IntToStr(arrDeliveries[lbxDeliveries.ItemIndex].GetReward) + '$';
   lblTime.Caption := 'Time Limit: ' + IntToStr(arrDeliveries[lbxDeliveries.ItemIndex].GetTimeLimit) + 's';
   lblMass.Caption := 'Cargo Mass: ' + IntToStr(arrDeliveries[lbxDeliveries.ItemIndex].GetCargoMass) + ' KG';
 end;

end;

procedure TfrmDeliveries.btnDeliveryClick(Sender: TObject);
begin
//Validation
  if lbxDeliveries.ItemIndex <> -1 then
  begin
//Validation
    if frmGame.PlayerVehicle.GetVehicle.GetMaxCapacity >= arrDeliveries[lbxDeliveries.ItemIndex].GetCargoMass then
    begin
      frmGame.ActiveDelivery := arrDeliveries[lbxDeliveries.ItemIndex];
      frmGame.ActiveDelivery.GetPickUp.Render;
      frmGame.tmrMovement.Enabled := True;
      frmGame.tmrCollisions.Enabled := True;
      frmGame.tmrDelivery.Enabled := True;
      frmDeliveries.Hide;
    end
    else begin
      MessageDlg('Cargo is too heavy for current vehicle',mtWarning,[mbOK],0);   //Validation message
    end;

  end
  else
  begin
    MessageDlg('Please select a delivery before continuing',mtWarning,[mbOK],0); //validation message

  end;
end;

procedure TfrmDeliveries.btnCloseClick(Sender: TObject);
begin
  frmGame.tmrMovement.Enabled := True;
  frmGame.tmrCollisions.Enabled := True;
  frmGame.tmrDelivery.Enabled := True;
  frmDeliveries.Hide;
end;

procedure TfrmDeliveries.LoadDeliveries;
var
  sCargoType : string;
  PickUpID, DropOffID: Integer;
  ArrayIndex: Integer;
  iTimeLimit, iReward, iMass: Integer;
  Pickup, DropOff: TDeliveryPoint;
  bPickUp, bDropOff: Boolean;
begin
  Randomize;

  ArrayIndex := 0;
  Pickup := nil;
  DropOff := nil;

  with dbmGame do
  begin
    tblDeliveries.First;

    while not tblDeliveries.Eof do
    begin
      PickUpID := tblDeliveries['PickUp_ID'];
      DropOffID := tblDeliveries['DropOff_ID'];
      iTimeLimit := tblDeliveries['TimeLimit'];
      iReward := tblDeliveries['Reward'];
      iMass := tblDeliveries['Mass'];

      bPickUp := False;
      bDropOff := False;

      // Find PickUp location
      tblLocations.First;
      while (not tblLocations.Eof) and (not bPickUp) do
      begin
        if PickUpID = tblLocations['Location_ID'] then
        begin
          Pickup := TDeliveryPoint.Create(tblLocations['PosX'] * GRID_WIDTH + (GRID_WIDTH Div 4), tblLocations['PosY'] * GRID_HEIGHT + (GRID_HEIGHT Div 4), 32, 32, True);
          bPickUp := True;
        end;
        tblLocations.Next;
      end;

      // Find DropOff location
      tblLocations.First;
      while (not tblLocations.Eof) and (not bDropOff) do
      begin
        if DropOffID = tblLocations['Location_ID'] then
        begin
          DropOff := TDeliveryPoint.Create(tblLocations['PosX'] * GRID_WIDTH + (GRID_WIDTH Div 4), tblLocations['PosY'] * GRID_HEIGHT + (GRID_HEIGHT Div 4), 32, 32, False);
          bDropOff := True;
        end;
        tblLocations.Next;
      end;

      // Create delivery if both locations are valid
      //Validation
      if bPickUp and bDropOff then
      begin
        Randomize;
        SetLength(arrDeliveries, Length(arrDeliveries) + 1);
        sCargoType := arrCargoType[Random(10)];
        arrDeliveries[ArrayIndex] := TDelivery.Create(sCargoType, Pickup, DropOff, iMass, iTimeLimit, iReward);
        Inc(ArrayIndex);
      end;

      tblDeliveries.Next;
    end;
  end;
end;

procedure TfrmDeliveries.ClearDeliveries;
var
  I: Integer;
begin
  for I := 0 to Length(arrDeliveries) - 1 do
  begin
    arrDeliveries[I].Free;
  end;
  SetLength(arrDeliveries, 0);
end;

procedure TfrmDeliveries.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearDeliveries;
end;

end.
