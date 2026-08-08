unit clsGameObject;

interface

uses
ExtCtrls,Dialogs,SysUtils;

type
  TGameObject = class
  protected
    fImage : TImage; // Will be accessed by TDeliveryPoint
  private
    fType : string; //Road,tree etc
    fX : integer;
    fY : Integer;  // Position on the map
    fWidth : integer;
    fHeight: Integer;
    fCollidable : boolean;
    procedure IntializeImage;
  public
    constructor Create(sType : string;X,Y,Width,Height: Integer;Collidable : boolean);
    //Accessors
    function GetType : string;
    function GetX: Integer;
    function GetY: Integer;
    function GetWidth: integer;
    function GetHeight: integer;
    function GetCollidable : boolean;
    //Mutators
    procedure SetType(sType : string);
    //Auxlillary
    procedure Render(); virtual; // Draw the object (can be overridden)
  end;

implementation

uses
Game,Admin;

{ TGameObject }

constructor TGameObject.Create(sType: string; X, Y, Width, Height: Integer;Collidable : boolean);
begin
  Self.fType := sType;
  Self.fX := X;
  Self.fY := Y;
  Self.fWidth := Width;
  Self.fHeight := Height;
  Self.fCollidable := Collidable;
  IntializeImage;
end;


procedure TGameObject.IntializeImage;
begin
  fImage := TImage.Create(nil);  //Default Form to show on/Parent
  with fImage do
  begin
    Parent := frmGame;  //Assign it to game form/screen
    Top := fY;
    Left := fX;
    Width := fWidth;
    Height := fHeight;
   // Transparent := True;
    Stretch := True;
    Visible := True;
    Enabled := True;

  end;
end;

procedure TGameObject.SetType(sType: string);
begin
 fType := sType;
end;

function TGameObject.GetCollidable: boolean;
begin
Result := fCollidable;
end;

function TGameObject.GetHeight: Integer;
begin
  Result := fHeight;
end;

function TGameObject.GetWidth: Integer;
begin
  Result := fWidth;
end;

function TGameObject.GetX: Integer;
begin
  Result := fX;
end;

function TGameObject.GetY: Integer;
begin
  Result := fY;
end;

function TGameObject.GetType: string;
begin
  Result := fType;
end;

procedure TGameObject.Render;
var
  sFilePath: string;
begin
  sFilePath := fType + '.png';

  if FileExists(sFilePath) then
  begin
    fImage.Picture.LoadFromFile(sFilePath);
    fImage.BringToFront;
  end
  else begin
    MessageDlg('Image not found: ' + sFilePath, mtWarning, [mbOK], 0);
  end;
end;


end.
