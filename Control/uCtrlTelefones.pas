unit uCtrlTelefones;

interface
uses MidasLib, Windows, Messages, SysUtils, System.Classes, Graphics, Controls, Forms, Dialogs,
     Gauges, DB,  SqlExpr, DBClient, ddb, ddmCliente, eInterface.Model.Interfaces;

type

  TCtrlTelefones = class(TObject)

  private
    FMensagemInfo   : string;
    FId_Telefone    : Integer;
    FId_Cliente     : Integer;
    FNome           : String;
    FDDD            : String;
    FTelefone       : String;
    FRamal          : String;
    FId_Tipo        : Integer;
    FDescricao      : String;

    function GetDDD: String;
    function GetId_Cliente: Integer;
    function GetId_Telefone: Integer;
    function GetId_Tipo: Integer;
    function GetMensagemInfo: String;
    function GetRamal: String;
    function GetTelefone: String;

    procedure SetDDD(const Value: String);
    procedure SetId_Cliente(const Value: Integer);
    procedure SetId_Telefone(const Value: Integer);
    procedure SetId_Tipo(const Value: Integer);
    procedure SetMensagemInfo(const Value: String);
    procedure SetRamal(const Value: String);
    procedure SetTelefone(const Value: String);
    function GetDescricao: String;
    function GetNome: String;
    procedure SetDescricao(const Value: String);
    procedure SetNome(const Value: String);



  public

    DataModule : TdmCliente;

    procedure IniciarProperty(Action: Boolean);
    procedure Processar(Processo: Integer);

    function MontaSqlTelefones(AId_Cliente : Integer = -9): string;
    function MontaSqlProcurarTelefone(AId_Cliente: Integer): string;
    function MontaSqlTipoTelefone: string;

    function ApplyCdsInsertTelefone(var AId_Telefone: Integer): Boolean;
    function ApplyCdsEditTelefone(AId_Telefone, AId_Cliente: Integer): Boolean;
    function ApplyCdsDeleteTelefone(AId_Telefone, AId_Cliente: Integer): Boolean;

    property MensagemInfo   : String  read GetMensagemInfo   write SetMensagemInfo;

    property Id_Telefone    : Integer read GetId_Telefone    write SetId_Telefone;
    property Id_Cliente     : Integer read GetId_Cliente     write SetId_Cliente;
    property Nome           : String  read GetNome           write SetNome;
    property DDD            : String  read GetDDD            write SetDDD;
    property Telefone       : String  read GetTelefone       write SetTelefone;
    property Ramal          : String  read GetRamal          write SetRamal;
    property Id_Tipo        : Integer read GetId_Tipo        write SetId_Tipo;
    property Descricao      : String  read GetDescricao      write SetDescricao;

    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses uSistemaIB, uFuncoes;

{ TCtrlTelefones }

constructor TCtrlTelefones.Create;
begin
  DataModule      := TdmCliente.Create(NIL);
  FMensagemInfo   := '';
  FId_Telefone    := 0;
  FId_Cliente     := 0;
  FDDD            := '';
  FTelefone       := '';
  FRamal          := '';
  FId_Tipo        := 0;
end;

destructor TCtrlTelefones.Destroy;
begin
  inherited;
  FreeAndNil(DataModule);
end;

function TCtrlTelefones.GetDDD: String;
begin
  Result := FDDD;
end;

function TCtrlTelefones.GetDescricao: String;
begin
  Result := FDescricao;
end;

function TCtrlTelefones.GetId_Cliente: Integer;
begin
  Result := FId_Cliente;
end;

function TCtrlTelefones.GetId_Telefone: Integer;
begin
  Result := FId_Telefone;
end;

function TCtrlTelefones.GetId_Tipo: Integer;
begin
  Result := FId_Tipo;
end;

function TCtrlTelefones.GetMensagemInfo: String;
begin
  Result := FMensagemInfo;
end;

function TCtrlTelefones.GetNome: String;
begin
  Result := FNome;
end;

function TCtrlTelefones.GetRamal: String;
begin
  Result := FRamal;
end;

function TCtrlTelefones.GetTelefone: String;
begin
  Result := FTelefone;
end;

procedure TCtrlTelefones.IniciarProperty(Action: Boolean);
begin
  if not Action then
  begin
    FMensagemInfo   := '';
    FId_Telefone    := 0;
    FId_Cliente     := 0;
    FNome           := '';
    FDDD            := '';
    FTelefone       := '';
    FRamal          := '';
    FId_Tipo        := 0;
    FDescricao      := '';
  end
  else
  begin
    FMensagemInfo := 'Sucesso';
    FId_Telefone    := DataModule.qryTelefone.FieldByName('ID_TELEFONE').AsInteger;
    FId_Cliente     := DataModule.qryTelefone.FieldByName('ID_EMPRESA').AsInteger;
    FNome           := DataModule.qryTelefone.FieldByName('NOME').AsString;
    FDDD            := DataModule.qryTelefone.FieldByName('DDD').AsString;
    FTelefone       := DataModule.qryTelefone.FieldByName('TELEFONE').AsString;
    FRamal          := DataModule.qryTelefone.FieldByName('RAMAL').AsString;
    FId_Tipo        := DataModule.qryTelefone.FieldByName('ID_TIPO').AsInteger;
    FDescricao      := DataModule.qryTelefone.FieldByName('DESCRICAO').AsString;
  end;
end;

function TCtrlTelefones.MontaSqlTelefones(AId_Cliente: integer): string;
var
    sql  : TStringList;
begin
  sql := TStringList.Create;
  try
    sql.Clear;
    sql.Add('SELECT T.ID_TELEFONE, ');
    sql.Add('       T.ID_CLIENTE,  ');
    sql.Add('       CL.NOME,       ');
    sql.Add('       T.DDD,         ');
    sql.Add('       T.TELEFONE,    ');
    sql.Add('       T.RAMAL,       ');
    sql.Add('       T.ID_TIPO,     ');
    sql.Add('       TF.DESCRICAO   ');
    sql.Add('FROM TELEFONES T      ');
    sql.Add('     INNER JOIN CLIENTES     CL ON CL.ID_CLIENTE = T.ID_CLIENTE');
    sql.Add('     INNER JOIN TIPOTELEFONE TF ON TF.ID_TIPO    = T.ID_TIPO');

    if (AId_Cliente <> -9)then
    begin
      sql.Add('                          ');
      sql.Add('WHERE ID_CLIENTE = ' + IntToStr(AId_Cliente));
    end;

//    Sql.SaveToFile('C:\EcoCentauro\Consultas\MontaSqlTelefones.Txt');

    Result := sql.Text;
  finally
    FreeAndNil(sql);
  end;
end;

function TCtrlTelefones.MontaSqlProcurarTelefone(AId_Cliente: Integer): string;
var
    sql  : TStringList;
begin
  sql := TStringList.Create;
  try
    sql.Clear;
    sql.Add('SELECT T.ID_TELEFONE AS IDRETORNO, ');
    sql.Add('       T.ID_TELEFONE,              ');
    sql.Add('       T.ID_TELEFONE,              ');
    sql.Add('       CL.NOME,                    ');
    sql.Add('       T.TELEFONE                  ');
    sql.Add('FROM TELEFONES T INNER JOIN CLIENTES CL ON CL.ID_CLIENTE = T.ID_CLIENTE');
    if (AId_Cliente <> -9) then
      sql.Add('WHERE ID_CLIENTE = ' + IntToStr(AId_Cliente));

//    Sql.SaveToFile('C:\EcoCentauro\Consultas\MontaSqlProcurarTelefone.Txt');

    Result := sql.Text;
  finally
    FreeAndNil(sql);
  end;
end;

function TCtrlTelefones.MontaSqlTipoTelefone: string;
var
    sql  : TStringList;
begin
  sql := TStringList.Create;
  try
    sql.Clear;
    sql.Add('SELECT ID_TIPO,   ');
    sql.Add('       DESCRICAO  ');
    sql.Add('FROM TIPOTELEFONE ');

//    Sql.SaveToFile('C:\EcoCentauro\Consultas\MontaSqlTipoTelefone.Txt');

    Result := sql.Text;
  finally
    FreeAndNil(sql);
  end;
end;

procedure TCtrlTelefones.Processar(Processo: Integer);
var
    iId_Telefone : Integer;
begin
   case Processo of
     1: begin
          iId_Telefone := 0;
          ApplyCdsInsertTelefone(iId_Telefone);
        end;
     2: begin
         ApplyCdsEditTelefone(Id_Telefone, Id_Cliente);
        end;
     4: begin
          ApplyCdsDeleteTelefone(Id_Telefone, Id_Cliente);
        end;
   end;
end;

procedure TCtrlTelefones.SetDDD(const Value: String);
begin
  FDDD := Value;
end;

procedure TCtrlTelefones.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TCtrlTelefones.SetId_Cliente(const Value: Integer);
begin
  FId_Cliente := Value;
end;

procedure TCtrlTelefones.SetId_Telefone(const Value: Integer);
begin
  FId_Telefone := Value;
end;

procedure TCtrlTelefones.SetId_Tipo(const Value: Integer);
begin
  FId_Tipo := Value;
end;

procedure TCtrlTelefones.SetMensagemInfo(const Value: String);
begin
  FMensagemInfo := Value;
end;

procedure TCtrlTelefones.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TCtrlTelefones.SetRamal(const Value: String);
begin
  FRamal := Value;
end;

procedure TCtrlTelefones.SetTelefone(const Value: String);
begin
  FTelefone := Value;
end;

function TCtrlTelefones.ApplyCdsDeleteTelefone(AId_Telefone, AId_Cliente: Integer): Boolean;
var
  DataModule : TdmCliente;
begin
  DataModule := TdmCliente.Create(nil);
  DataModule.DataModule.FDConexaoPadrao.StartTransaction;
  try
    try
      DataModule.DataModule.FDTransacaoPadrao.StartTransaction;
      DataModule.qryConexaoPadrao.Close;
      DataModule.qryConexaoPadrao.SQL.Clear;
      DataModule.qryConexaoPadrao.SQL.Add('Delete From TELEFONES ');
      DataModule.qryConexaoPadrao.SQL.Add('Where (Id_Telefone = ' + IntToStr(AId_Telefone) + ')');
      DataModule.qryConexaoPadrao.SQL.Add('  And (Id_Cliente  = ' + IntToStr(AId_Cliente)  + ')');

//      DataModule.qryConexaoPadrao.SQL.SaveToFile('C:\EcoCentauro\Consultas\ApplyCdsDeleteTelefone.Txt');

      DataModule.qryConexaoPadrao.ExecSQL;
      DataModule.DataModule.FDConexaoPadrao.Commit;

      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        DataModule.DataModule.FDConexaoPadrao.Rollback;
      end;
    end;
  finally
    DataModule.qryConexaoPadrao.Close;
    FreeAndNil(DataModule);
  end;
end;

function TCtrlTelefones.ApplyCdsEditTelefone(AId_Telefone, AId_Cliente: Integer): Boolean;
var
  DataModule : TdmCliente;
begin
  DataModule := TdmCliente.Create(nil);
  DataModule.DataModule.FDConexaoPadrao.StartTransaction;
  try
    try
      DataModule.qryConexaoPadrao.Close;
      DataModule.qryConexaoPadrao.SQL.Clear;
      DataModule.qryConexaoPadrao.SQL.Add('UpDate TELEFONES SET ');
      DataModule.qryConexaoPadrao.SQL.Add('        ID_CLIENTE     = ' + IntToStr(Id_Cliente)      + ', ');
      DataModule.qryConexaoPadrao.SQL.Add('        DDD            = ' + QuotedStr(DDD)            + ', ');
      DataModule.qryConexaoPadrao.SQL.Add('        TELEFONE       = ' + QuotedStr(Telefone)       + ', ');
      DataModule.qryConexaoPadrao.SQL.Add('        RAMAL          = ' + QuotedStr(Ramal)          + ', ');
      DataModule.qryConexaoPadrao.SQL.Add('        ID_TIPO        = ' + IntToStr(Id_Tipo)         + ') ');
      DataModule.qryConexaoPadrao.SQL.Add('Where (Id_Telefone = ' + IntToStr(AId_Telefone) + ')');
      DataModule.qryConexaoPadrao.SQL.Add('  And (Id_Cliente  = ' + IntToStr(AId_Cliente)  + ')');

//      DataModule.qryConexaoPadrao.SQL.SaveToFile('C:\EcoCentauro\Consultas\ApplyCdsEditCliente.Txt');

      DataModule.qryConexaoPadrao.ExecSQL;
      DataModule.DataModule.FDTransacaoPadrao.Commit;
      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        DataModule.DataModule.FDTransacaoPadrao.Rollback;
      end;
    end;
  finally
    DataModule.qryConexaoPadrao.Close;
    FreeAndNil(DataModule);
  end;
end;


function TCtrlTelefones.ApplyCdsInsertTelefone(var AId_Telefone: Integer): Boolean;
var
   DataModule : TdmCliente;
   iVezes     : Integer;
begin
  DataModule := TdmCliente.Create(nil);
  DataModule.DataModule.FDConexaoPadrao.StartTransaction;
  try
    AId_Telefone := 0;
    iVezes := 1;
    while (AId_Telefone = 0) and (iVezes <= 5) do
    begin
      DataModule.qryConexaoPadrao.Close;
      DataModule.qryConexaoPadrao.SQL.Clear;
      DataModule.qryConexaoPadrao.SQL.Add('Select gen_id(GEN_TELEFONES_ID, 1) AS SEQUENCE from rdb$database');
      DataModule.qryConexaoPadrao.Open;
      AId_Telefone  := DataModule.qryConexaoPadrao.FieldByName('SEQUENCE').AsInteger;
      Inc(iVezes);
    end;

    if (iVezes >= 5) then
    begin
      Exit;
    end;

    try
      DataModule.qryConexaoPadrao.Close;
      DataModule.qryConexaoPadrao.SQL.Clear;
      DataModule.qryConexaoPadrao.SQL.Add('Insert Into TELEFONES ');
      DataModule.qryConexaoPadrao.SQL.Add('       (ID_TELEFONE,  ');
      DataModule.qryConexaoPadrao.SQL.Add('        ID_CLIENTE,   ');
      DataModule.qryConexaoPadrao.SQL.Add('        DDD,          ');
      DataModule.qryConexaoPadrao.SQL.Add('        TELEFONE,     ');
      DataModule.qryConexaoPadrao.SQL.Add('        RAMAL,        ');
      DataModule.qryConexaoPadrao.SQL.Add('        ID_TIPO)      ');
      DataModule.qryConexaoPadrao.SQL.Add('Values (' + IntToStr(AId_Telefone) + ',');
      DataModule.qryConexaoPadrao.SQL.Add(             IntToStr(Id_Cliente)   + ', ');
      DataModule.qryConexaoPadrao.SQL.Add(             QuotedStr(DDD)         + ', ');
      DataModule.qryConexaoPadrao.SQL.Add(             QuotedStr(Telefone)    + ', ');
      DataModule.qryConexaoPadrao.SQL.Add(             QuotedStr(Ramal)       + ', ');
      DataModule.qryConexaoPadrao.SQL.Add(             IntToStr(Id_Tipo)      + ') ');

//      DataModule.qryConexaoPadrao.SQL.SaveToFile('C:\EcoCentauro\Consultas\ApplyCdsInsertTelefone.Txt');

      DataModule.qryConexaoPadrao.ExecSQL;
      DataModule.DataModule.FDConexaoPadrao.Commit;
      Result := True;

    except
      on E: Exception do
      begin
        Result := False;
        DataModule.DataModule.FDConexaoPadrao.Rollback;
      end;
    end;
  finally
    DataModule.qryConexaoPadrao.Close;
    FreeAndNil(DataModule);
  end;
end;

end.
