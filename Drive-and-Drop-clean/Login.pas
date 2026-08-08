unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmLogin = class(TForm)
    pnlLogin: TPanel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    lblHowToPlay: TLabel;
    lblSignUp: TLabel;
    lblLogin: TLabel;
    lblGameName: TLabel;
    procedure btnLoginClick(Sender: TObject);
    procedure lblSignUpMouseEnter(Sender: TObject);
    procedure lblSignUpMouseLeave(Sender: TObject);
    procedure lblSignUpClick(Sender: TObject);
    procedure lblHowToPlayClick(Sender: TObject);
    procedure lblHowToPlayMouseEnter(Sender: TObject);
    procedure lblHowToPlayMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
Admin,DataBase,Garage,Game,SignUp;

{$R *.dfm}

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
sUsername,sPassword,sSQL : string;
begin

sUsername := edtUsername.Text;
sPassword := edtPassword.Text;

//Validate Input

if (sUsername = '') OR (sPassword = '') then
begin
  MessageDlg('Please enter Username and Password!',mtWarning,[mbOK],0);
  edtUsername.SetFocus;
  Exit;
end
else if Length(sPassword) < 5 then
begin
  MessageDlg('The Password must be have at least 5 characters!',mtWarning,[mbOk],0);
  edtPassword.SetFocus;
  Exit;
end;

//Check if admin is logging in

if (sUsername = 'Admin') AND (sPassword = 'AdminPassword') then
begin
  Showmessage('Welcome Admin');
  edtUsername.Text := 'Username';
  edtPassword.Text := 'Password';
  frmAdmin.Show;
  frmLogin.Hide;
  Exit;
end;

//Query database

sSQL := 'SELECT * FROM tblPlayers WHERE username = "' + sUsername + '" AND password = "' + sPassword + '"';

with dbmGame do
begin
  qryGame.SQL.Text := sSQL;
  qryGame.Open;

  if not qryGame.IsEmpty then
  begin
    qryGame.First; //Incase there is somehow multiple results
    frmGame.PlayerID := qryGame['Player_ID'];
    frmGame.PlayerUsername := qryGame['username'];
    frmGame.PlayerMoney := qryGame['money'];
    edtUsername.Text := 'Username';
    edtPassword.Text := 'Password';
    frmGarage.Show;
    frmLogin.Hide;
  end
  else begin
      MessageDlg('Invalid username or password.',mtWarning,[mbOK],0);
      edtPassword.Clear;
      edtPassword.SetFocus;
  end;
end;

end;

procedure TfrmLogin.lblHowToPlayClick(Sender: TObject);
begin
MessageDlg('1.Use arrow keys to move' + #13
    + '2.Press space to show deliveries menu while in game' + #13
    + '3.Complete Deliveries to get money' + #13
    + '4.Use Money to refuel your vehicles and buy vehicles' + #13
     ,mtInformation,[mbOK],0);
end;

procedure TfrmLogin.lblHowToPlayMouseEnter(Sender: TObject);
begin
lblHowToPlay.Font.Style := [fsUnderline];
end;

procedure TfrmLogin.lblHowToPlayMouseLeave(Sender: TObject);
begin
lblHowToPlay.Font.Style := [];
end;

procedure TfrmLogin.lblSignUpClick(Sender: TObject);
begin
frmLogin.Hide;
frmSignUp.Show;
end;

procedure TfrmLogin.lblSignUpMouseEnter(Sender: TObject);
begin
lblSignUP.Font.Style := [fsUnderline];
end;

procedure TfrmLogin.lblSignUpMouseLeave(Sender: TObject);
begin
lblSignUP.Font.Style := [];
end;

end.
