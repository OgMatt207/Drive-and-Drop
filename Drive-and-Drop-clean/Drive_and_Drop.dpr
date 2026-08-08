program Drive_and_Drop;

uses
  Forms,
  Game in 'Game.pas' {frmGame},
  clsVehicleController in 'clsVehicleController.pas',
  clsVehicle in 'clsVehicle.pas',
  clsGameObject in 'clsGameObject.pas',
  DataBase in 'DataBase.pas' {dbmGame: TDataModule},
  clsDelivery in 'clsDelivery.pas',
  clsDeliveryPoint in 'clsDeliveryPoint.pas',
  DeliveryTab in 'DeliveryTab.pas' {frmDeliveries},
  Garage in 'Garage.pas' {frmGarage},
  Login in 'Login.pas' {frmLogin},
  Admin in 'Admin.pas' {frmAdmin},
  VehicleDealership in 'VehicleDealership.pas' {frmDealership},
  SignUp in 'SignUp.pas' {frmSignUp};

{$R *.res}

begin
  Application.Initialize;
 // Application.MainFormOnTaskbar := True;
  Application.Title := 'Drive And Drop';
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmGarage, frmGarage);
  Application.CreateForm(TfrmGame, frmGame);
  Application.CreateForm(TfrmDealership, frmDealership);
  Application.CreateForm(TfrmAdmin, frmAdmin);
  Application.CreateForm(TfrmDeliveries, frmDeliveries);
  Application.CreateForm(TdbmGame, dbmGame);
  Application.Run;
end.
