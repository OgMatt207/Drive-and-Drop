object frmSignUp: TfrmSignUp
  Left = 0
  Top = 0
  Caption = 'SignUp'
  ClientHeight = 326
  ClientWidth = 589
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblLogin: TLabel
    Left = 480
    Top = 296
    Width = 101
    Height = 16
    Cursor = crHandPoint
    Caption = 'Have an Account?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = lblLoginClick
    OnMouseEnter = lblLoginMouseEnter
    OnMouseLeave = lblLoginMouseLeave
  end
  object lblGameName: TLabel
    Left = 176
    Top = 24
    Width = 252
    Height = 24
    Caption = 'DRIVE AND DROP'
    Font.Charset = OEM_CHARSET
    Font.Color = clGreen
    Font.Height = -27
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnlSignUp: TPanel
    Left = 194
    Top = 72
    Width = 217
    Height = 185
    Color = cl3DDkShadow
    ParentBackground = False
    TabOrder = 0
    object lblSignUp: TLabel
      Left = 72
      Top = 8
      Width = 74
      Height = 25
      Caption = 'Sign Up'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtUsername: TEdit
      Left = 48
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Username'
    end
    object edtPassword: TEdit
      Left = 48
      Top = 83
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Password'
    end
    object edtConfirmPassword: TEdit
      Left = 48
      Top = 110
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Confirm Password'
    end
    object btnSignUp: TButton
      Left = 64
      Top = 137
      Width = 89
      Height = 25
      Caption = 'Create Account'
      TabOrder = 3
      OnClick = btnSignUpClick
    end
  end
end
