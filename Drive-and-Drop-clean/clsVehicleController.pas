unit clsVehicleController;

interface

uses
clsVehicle,Math;

type TVehicleController = class
  private
  fVehicle : TVehicle;
  fPosX : Double;
  fPosY : Double;
  fAcceleration : integer;
  fRotation : integer;
  fSpeed : Integer;
  fMaxSpeed : integer;
  const
  FRICTION : integer = 2;
  public
  constructor Create(PlayerVehicle : TVehicle; PosX,PosY : integer);
  //Accessors
  function GetVehicle : TVehicle;
  function GetX : integer;
  function GetY : integer;
  function GetSpeed : integer;
  function GetRotation : integer;
  //Mutators
  procedure RotateLeft;
  procedure RotateRight;
  procedure RotateUP;
  procedure RotateDown;
  procedure SetOppositeRotation;
  procedure SetPosx(Posx : integer);
  procedure SetPosy(Posy : integer);
  //Auxilary
  procedure ApplySpeed;
  procedure ApplyBrake;
  procedure ApplyFriction;
  procedure StopVehicle;
  procedure UpdatePosition;

end;

implementation

constructor TVehicleController.Create(PlayerVehicle : TVehicle; PosX,PosY : integer);
begin
Self.fVehicle := PlayerVehicle;
Self.fPosX := PosX;
Self.fPosY := PosY;
Self.fAcceleration := fVehicle.GetSpeed;
Self.fRotation := 0;
Self.fSpeed := 0;
Self.fMaxSpeed := fVehicle.GetSpeed * 10;
end;

//Accessors
function TVehicleController.GetX: integer;
begin
Result := Trunc(fPosX);
end;

function TVehicleController.GetY: integer;
begin
Result := Trunc(fPosY);
end;

function TVehicleController.GetRotation: integer;
begin
Result := fRotation;
end;

function TVehicleController.GetSpeed: integer;
begin
Result := fSpeed;
end;

function TVehicleController.GetVehicle: TVehicle;
begin
Result := fVehicle;
end;

//Mutators
procedure TVehicleController.RotateDown;
begin

  if (fRotation = 270) AND (fSpeed <> 0) then
  begin
    ApplyBrake;
    if fSpeed = 0 then
    begin
      fRotation := 90;
    end;
  end
  else begin
    fRotation := 90;
  end;

end;

procedure TVehicleController.RotateLeft;
begin

  if (fRotation = 0) AND (fSpeed <> 0) then
  begin
    ApplyBrake;
    if fSpeed = 0 then
    begin
      fRotation := 180;
    end;
  end
  else begin
    fRotation := 180;
  end;

end;

procedure TVehicleController.RotateRight;
begin

  if (fRotation = 180) AND (fSpeed <> 0) then
  begin
    ApplyBrake;
    if fSpeed = 0 then
    begin
      fRotation := 0;
    end;
  end
  else begin
    fRotation := 0;
  end;

end;

procedure TVehicleController.RotateUP;
begin

  if (fRotation = 90) AND (fSpeed <> 0) then
  begin
    ApplyBrake;
    if fSpeed = 0 then
    begin
      fRotation := 270;
    end;
  end
  else begin
    fRotation := 270;
  end;

end;

procedure TVehicleController.SetOppositeRotation;
begin
fSpeed := -30;
UpdatePosition;
fSpeed := 0;
end;

procedure TVehicleController.SetPosx(Posx: integer);
begin
fPosx := Posx;
end;

procedure TVehicleController.SetPosy(Posy: integer);
begin
fPosy := Posy;
end;

procedure TVehicleController.StopVehicle;
begin
Self.fSpeed := 0;
end;

//Auxliary
procedure TVehicleController.ApplySpeed;
begin

if Self.fVehicle.GetFuel > 0 then
begin
  Self.fSpeed := Self.fSpeed + Self.fAcceleration;
  Self.fVehicle.DepleteFuel;
end
else begin
  ApplyFriction;
end;


if fSpeed > fMaxSpeed then
begin
  Self.fSpeed := fMaxSpeed;
end;

end;

procedure TVehicleController.ApplyBrake;
var
BrakeForce : integer;
begin
BrakeForce := 5;

if Self.fSpeed > 0 then
begin
  Self.fSpeed := Self.fSpeed - FRICTION - BrakeForce;
end;

if Self.fSpeed < 0 then
begin
  Self.fSpeed := 0;
end;

end;

procedure TVehicleController.ApplyFriction;
begin
Self.fSpeed := Self.fSpeed - FRICTION;

if Self.fSpeed < 0 then
begin
  Self.fSpeed := 0;
end;

end;

procedure TVehicleController.UpdatePosition;
begin
fPosX := fPosX + fSpeed * Cos(DegToRad(fRotation));
fPosY := fPosY + fSpeed * Sin(DegToRad(fRotation));
end;

end.
