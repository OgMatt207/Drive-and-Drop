unit clsDelivery;

interface

uses
 clsVehicle,clsDeliveryPoint, StdCtrls;

type
  TDelivery = class
  private
    fCargoType: string;
    fCargoMass: integer;
    fTimeLimit: Integer;  // Original time limit
    fTimeRemaining: Integer;  // Countdown for the delivery
    fPick_Up: TDeliveryPoint;
    fDrop_Off: TDeliveryPoint;
    fRewardMoney: integer;
    fActive: boolean;
  public
    constructor Create(CargoType: string; PickLocation, DropLocation: TDeliveryPoint;
      Mass, TimeLimit, Reward: integer);

    // Accessors
    function GetCargoType: string;
    function GetCargoMass: integer;
    function GetTimeLimit: integer;
    function GetTimeRemaining : integer;
    function GetReward: integer;
    function GetPickUp : TDeliveryPoint;
    function GetDropOff : TDeliveryPoint;
    function IsActive: boolean;

    // Mutators
    procedure Activate;
    procedure Deactivate;
    procedure UpdateTime;

    // Auxiliary
  end;

implementation

{ TDelivery }

constructor TDelivery.Create(CargoType: string; PickLocation, DropLocation: TDeliveryPoint;
  Mass, TimeLimit, Reward: integer);
begin
  Self.fCargoType := CargoType;
  Self.fCargoMass := Mass;
  Self.fTimeLimit := TimeLimit;
  Self.fTimeRemaining := TimeLimit;
  Self.fPick_Up := PickLocation;
  Self.fDrop_Off := DropLocation;
  Self.fRewardMoney := Reward;
  Self.fActive := False;
end;

procedure TDelivery.Deactivate;
begin
  fActive := False;
end;

// Accessor methods
function TDelivery.GetCargoType: string;
begin
  Result := fCargoType;
end;

function TDelivery.GetDropOff: TDeliveryPoint;
begin
  Result := fDrop_Off;
end;

function TDelivery.GetPickUp: TDeliveryPoint;
begin
  Result := fPick_Up;
end;

function TDelivery.GetCargoMass: integer;
begin
  Result := fCargoMass;
end;

function TDelivery.GetTimeLimit: integer;
begin
  Result := fTimeLimit;
end;

function TDelivery.GetTimeRemaining: integer;
begin
  Result := fTimeRemaining;
end;

function TDelivery.GetReward: integer;
begin
  Result := fRewardMoney;
end;

function TDelivery.IsActive: boolean;
begin
  Result := fActive;
end;

procedure TDelivery.UpdateTime;
begin
fTimeRemaining := fTimeRemaining - 1;
end;

// Mutator methods
procedure TDelivery.Activate;
begin
  fActive := True;
end;



end.

