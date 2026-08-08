unit clsDeliveryPoint;

interface

uses
clsGameObject,ExtCtrls,Dialogs,SysUtils;

type TDeliveryPoint = class(TGameObject)
  private
   fIsPickup : boolean; //is it PickUp or Dropoff
  public
    constructor Create(X, Y, Width, Height: Integer; bPickup: boolean);
    function IsPickup : boolean;
    procedure Render; override;
    procedure Unload;
end;

implementation

constructor TDeliveryPoint.Create(X, Y, Width, Height: Integer; bPickup: boolean);
begin
  inherited Create('DeliveryPoint', X, Y, Width, Height,True); // Call inherited constructor
  Self.fIsPickup := bPickUp;
end;

function TDeliveryPoint.IsPickUp: boolean;
begin
  Result := fIsPickup;
end;

procedure TDeliveryPoint.Render;
var
  sFilePath: string;
begin
  if fIsPickUp then
  begin
    sFilePath := 'PickUp.png';
  end
  else begin
    sFilePath := 'DropOff.png';
  end;

  if FileExists(sFilePath) then
  begin
    Self.fImage.Picture.LoadFromFile(sFilePath);
  end
  else begin
    MessageDlg('Image not found: ' + sFilePath, mtWarning, [mbOK], 0);
  end;
end;

procedure TDeliveryPoint.Unload;
begin
  Self.fImage.Picture := nil;
end;

end.
