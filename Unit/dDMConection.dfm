object DMConection: TDMConection
  OldCreateOrder = True
  OnCreate = DMConectionCreate
  Height = 92
  Width = 231
  object FDTransacaoPadrao: TFDTransaction
    Connection = FDConexaoPadrao
    Left = 152
    Top = 8
  end
  object FDConexaoPadrao: TFDConnection
    ConnectionName = 'FBConnection'
    Params.Strings = (
      'Database=C:\EcoCentauro\BancoFB2.5\ECOCENTAURO.FDB'
      'Password=masterkey'
      'User_Name=SYSDBA'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Transaction = FDTransacaoPadrao
    Left = 40
    Top = 8
  end
end
