object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'Login'
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
  object lblSignUp: TLabel
    Left = 486
    Top = 299
    Width = 95
    Height = 19
    Cursor = crHandPoint
    Caption = 'Make account'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = lblSignUpClick
    OnMouseEnter = lblSignUpMouseEnter
    OnMouseLeave = lblSignUpMouseLeave
  end
  object lblHowToPlay: TLabel
    Left = 266
    Top = 231
    Width = 85
    Height = 19
    Cursor = crHandPoint
    Caption = 'How to play'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = lblHowToPlayClick
    OnMouseEnter = lblHowToPlayMouseEnter
    OnMouseLeave = lblHowToPlayMouseLeave
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
  object pnlLogin: TPanel
    Left = 194
    Top = 72
    Width = 217
    Height = 153
    Color = cl3DDkShadow
    ParentBackground = False
    TabOrder = 0
    object lblLogin: TLabel
      Left = 80
      Top = 8
      Width = 50
      Height = 25
      Caption = 'Login'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtUsername: TEdit
      Left = 48
      Top = 52
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Player123'
    end
    object edtPassword: TEdit
      Left = 48
      Top = 79
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'password123'
    end
    object btnLogin: TButton
      Left = 72
      Top = 106
      Width = 75
      Height = 25
      Caption = 'Login'
      TabOrder = 2
      OnClick = btnLoginClick
    end
  end
end
