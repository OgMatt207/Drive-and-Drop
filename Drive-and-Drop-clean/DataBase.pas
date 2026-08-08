unit DataBase;

interface

uses
  SysUtils, Classes, DB, ADODB, FMTBcd, SqlExpr;

type
  TdbmGame = class(TDataModule)
    conGame: TADOConnection;
    qryGame: TADOQuery;
    dscGame: TDataSource;
    tblDeliveries: TADOTable;
    tblLocations: TADOTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dbmGame: TdbmGame;

implementation

{$R *.dfm}

end.
