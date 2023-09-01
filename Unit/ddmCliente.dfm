object dmCliente: TdmCliente
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 293
  Width = 276
  object qryConexaoPadrao: TFDQuery
    Connection = DMConection.FDConexaoPadrao
    Left = 58
    Top = 19
  end
  object qryAuxiliar: TFDQuery
    Connection = DMConection.FDConexaoPadrao
    Left = 60
    Top = 69
  end
  object qryEstado: TFDQuery
    Connection = DMConection.FDConexaoPadrao
    SQL.Strings = (
      'SELECT ID_ESTADO,'
      '       SIGLA,'
      '       NOME,'
      '       IBGE'
      'FROM ESTADO')
    Left = 60
    Top = 120
  end
  object qryEmpresa: TFDQuery
    Connection = DMConection.FDConexaoPadrao
    SQL.Strings = (
      'SELECT ID_EMPRESA,'
      '       NOMEFANTASIA,'
      '       CNPJ,'
      '       UF'
      'FROM EMPRESAS')
    Left = 60
    Top = 172
  end
  object qryCliente: TFDQuery
    Connection = DMConection.FDConexaoPadrao
    SQL.Strings = (
      'SELECT CL.ID_CLIENTE,'
      '       CL.ID_EMPRESA,'
      '       CL.NOME,'
      '       EM.NOMEFANTASIA AS EMPRESA,'
      '       CL.TIPOPESSOA,'
      '       CL.TELEFONES,'
      '       CL.DOCUMENTO,'
      '       CL.RG,'
      '       CL.UF,'
      '       CL.DATANASCIMENTO,'
      '       CL.DATACADASTRO'
      'FROM CLIENTES CL'
      '     INNER JOIN EMPRESAS EM ON EM.ID_EMPRESA = CL.ID_EMPRESA'
      ''
      '')
    Left = 60
    Top = 224
  end
  object dsConexaoPadrao: TDataSource
    DataSet = qryConexaoPadrao
    Left = 169
    Top = 21
  end
  object dsEstado: TDataSource
    DataSet = qryEstado
    Left = 169
    Top = 123
  end
  object dsAuxiliar: TDataSource
    DataSet = qryAuxiliar
    Left = 169
    Top = 71
  end
  object dsEmpresa: TDataSource
    DataSet = qryEmpresa
    Left = 169
    Top = 176
  end
  object dsCliente: TDataSource
    DataSet = qryCliente
    Left = 169
    Top = 228
  end
end
