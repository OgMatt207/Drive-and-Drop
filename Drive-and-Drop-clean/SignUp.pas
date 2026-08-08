unit SignUp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSignUp = class(TForm)
    pnlSignUp: TPanel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    edtConfirmPassword: TEdit;
    btnSignUp: TButton;
    lblSignUp: TLabel;
    lblLogin: TLabel;
    lblGameName: TLabel;
    procedure btnSignUpClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure lblLoginMouseEnter(Sender: TObject);
    procedure lblLoginMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;

implementation

{$R *.dfm}

uses
DataBase,VehicleDealership,Game,Login;

procedure TfrmSignUp.btnSignUpClick(Sender: TObject);
var
sUsername,sPassword,sQuery : string;
begin

sUsername := edtUsername.Text;
sPassword := edtPassword.Text;

if sUsername = 'Admin' then
begin
  MessageDlg('Cannot use Admin as username',mtWarning,[mbOK],0);
  Exit;
end
else if Length(sPassword) < 5 then
begin
  MessageDlg('The Password must be have at least 5 characters!',mtWarning,[mbOk],0);
  edtPassword.SetFocus;
  Exit;
end;

if edtPassword.Text = edtConfirmPassword.Text then
begin

  //Look if username exists
  sQuery := 'SELECT Username FROM tblPlayers WHERE Username = "' + sUsername + '"';

  with dbmGame do
  begin
    qryGame.SQL.Text := sQuery;
    qryGame.Open;

    if qryGame.IsEmpty then
    begin
      //Make account
sQuery := 'INSERT INTO tblPlayers ([Username], [Password], [Money]) ' +
          'VALUES ("' + sUsername + '", "' + sPassword + '", 1000)';
      qryGame.SQL.Text := SQuery;
      qryGame.ExecSQL;
      MessageDlg('Account made',mtInformation,[mbOK],0);

      //Load Details
      sQuery := 'SELECT * FROM tblPlayers WHERE username = "' + sUsername + '" AND password = "' + sPassword + '"';
      with dbmGame do
      begin
        qryGame.SQL.Text := sQuery;
        qryGame.Open;
        frmGame.PlayerID := qryGame['Player_ID'];
        frmGame.PlayerUsername := qryGame['Username'];
        frmGame.PlayerMoney := qryGame['Money'];
      end;

      //Go to Dealership to buy a vehicle
      frmSignUp.Hide;
      frmDealership.Show;
      MessageDlg('Buy a vehicle',mtInformation,[mbOK],0);
    end
    else begin
      MessageDlg('Username already taken',mtWarning,[mbOK],0);
    end;

  end;

end
else begin
  MessageDlg('The passwords are not the same',mtWarning,[mbOk],0);
end;

end;

procedure TfrmSignUp.lblLoginClick(Sender: TObject);
begin
edtUsername.Text := '';
edtPassword.Text := '';
edtConfirmPassword.Text := '';
frmSignUp.Hide;
frmLogin.Show;
end;

procedure TfrmSignUp.lblLoginMouseEnter(Sender: TObject);
begin
lblLogin.Font.Style := [fsUnderline];
end;

procedure TfrmSignUp.lblLoginMouseLeave(Sender: TObject);
begin
lblLogin.Font.Style := [];
end;

end.
