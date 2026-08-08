object dbmGame: TdbmGame
  OldCreateOrder = False
  Height = 252
  Width = 427
  object conGame: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=Drive' +
      ' and Drop.mdb;Mode=Share Deny None;Persist Security Info=False;J' +
      'et OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB' +
      ':Database Password="";Jet OLEDB:Engine Type=5;Jet OLEDB:Database' +
      ' Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Gl' +
      'obal Bulk Transactions=1;Jet OLEDB:New Database Password="";Jet ' +
      'OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=Fa' +
      'lse;Jet OLEDB:Don'#39't Copy Locale on Compact=False;Jet OLEDB:Compa' +
      'ct Without Replica Repair=False;Jet OLEDB:SFP=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 40
    Top = 32
  end
  object qryGame: TADOQuery
    Connection = conGame
    Parameters = <>
    Left = 104
    Top = 32
  end
  object dscGame: TDataSource
    DataSet = qryGame
    Left = 168
    Top = 32
  end
  object tblDeliveries: TADOTable
    Active = True
    Connection = conGame
    CursorType = ctStatic
    TableName = 'tblDeliveries'
    Left = 288
    Top = 160
  end
  object tblLocations: TADOTable
    Active = True
    Connection = conGame
    CursorType = ctStatic
    TableName = 'tblLocations'
    Left = 216
    Top = 160
  end
end
