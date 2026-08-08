unit clsVehicle;

interface

type
  TVehicle = class
  private
    fID : integer; //From database
    fName : string;
    fCost : integer;
    fSpeed : integer;
    fFuel: real;  // Current fuel level in litre
    fMaxFuel: real;
    fCapacity : integer; //Current load level in kg
    fMaxCapacity : integer;
    fRefillCost: integer;  // Cost of refilling the vehicle per litre
  public
    constructor Create(ID : integer;Name : string; Cost,Speed : integer; Fuel,MaxFuel : real; MaxCapacity,RefillCost: integer);
    //Accessors
    function GetID : integer;
    function GetName : string;
    function GetCost : integer;
    function GetFuel: real;
    function GetSpeed : integer;
    function GetMaxFuel: real;
    function GetCurrentCapacity : integer;
    function GetMaxCapacity : integer;
    function GetRefillCost: integer;
    //Mutators
    procedure DepleteFuel;
    //Auxillery
    procedure Refill;
    procedure LoadCargo(weight : integer);
    procedure UnloadCargo(weight : integer);
  end;

implementation

{ TVehicle }

constructor TVehicle.Create(ID : integer;Name : string; Cost,Speed : integer; Fuel,MaxFuel : real; MaxCapacity,RefillCost: integer);
begin
  Self.fID := ID;
  Self.fName := Name;
  Self.fCost := Cost;
  Self.fSpeed := Speed;
  Self.fFuel := Fuel;
  Self.fCapacity := 0;
  Self.fMaxFuel := MaxFuel;
  Self.fMaxCapacity := MaxCapacity;
  Self.fRefillCost := RefillCost;
end;

procedure TVehicle.DepleteFuel;
begin
  Self.fFuel := fFuel - 0.1;
end;

function TVehicle.GetName: string;
begin
  Result := fName;
end;

function TVehicle.GetSpeed: integer;
begin
  Result := fSpeed;
end;

function TVehicle.GetCost: integer;
begin
  Result := fCost;
end;

function TVehicle.GetCurrentCapacity: integer;
begin
  Result := fCapacity;
end;

function TVehicle.GetFuel: real;
begin
  Result := fFuel;
end;

function TVehicle.GetID: integer;
begin
  Result := fID;
end;

function TVehicle.GetMaxFuel: real;
begin
  Result := fMaxFuel;
end;

function TVehicle.GetMaxCapacity: integer;
begin
  Result := fMaxCapacity;
end;

function TVehicle.GetRefillCost: integer;
begin
  Result := Round(fRefillCost * (fMaxFuel - fFuel));
end;

procedure TVehicle.Refill;
begin
  Self.fFuel := fMaxFuel;  // Refills the vehicle to max capacity
end;

procedure TVehicle.LoadCargo(weight: integer);
begin
  if fCapacity + weight <= fMaxCapacity then
  begin
    fCapacity := fCapacity + weight;
  end;
end;

procedure TVehicle.UnloadCargo(weight: integer);
begin

  fCapacity := fCapacity - weight;

end;

//Auxillary



end.

