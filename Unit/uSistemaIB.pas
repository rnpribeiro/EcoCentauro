unit uSistemaIB;

interface
uses
  Windows, Messages, SysUtils,Types, MaskUtils, FileCtrl, Classes, Graphics, System.UITypes,
  Controls, Forms, jpeg, ExtCtrls,  ddb, DB, SqlExpr, DBClient, Math,
  Dialogs, Registry, menus, StdCtrls, ddmCliente, dDMConection,
  Grids, DBGrids, DBCtrls, MMSystem, cxControls, cxContainer, cxEdit, cxImage,
  Clipbrd, vfw, IniFiles, dxSkinsCore, dxSkinsDefaultPainters, dxCameraControl;

type
  TTipoProtocolo = (tpTCPIP, tpNETBEUI, tpSPX, tpLocal);
  TTipoMetodoEnsino = (tmRegular, tmSupletivo);
  TPreenchimento = (pEsquerda, pDireita, pCentro);
  TRoundToRange = -37..37;

  TSistema = class
  private

    FLogado                   : Boolean;
    FIdUsuario                : Double;
    FMetodo                   : Double;
    FDescMetodo               : string;
    FSistema                  : Double;
    FDescSistema              : string;
    FAcessoMenu               : Integer;
    FIdGrupoUsuario           : Double;
    FNomeUsuario              : string;
    FNomeLogin                : string;
    FSenhaUsuario             : string;
    FAnoLetivo                : string;
    FSemestre                 : string;
    FSecretario               : Boolean;
    FAtivo                    : Boolean;
    FSuperUsuario             : Boolean;
    FFlgWebCamUsuario         : Boolean;
    FVersaoSistema            : string;

    FAppNome                  : string;
    FServidorBanco            : string;
    FPorta                    : string;
    FNomeBanco                : string;
    FProtocolo                : TTipoProtocolo;
    FFlgWebCam                : Boolean;

    FLogadoBanco              : Boolean;
    FVersaoBanco              : string;
    FAppSistema               : string;
    FMensagemInfo             : string;

    FDataModuloPadrao         : TDMConection;

    procedure SetDataModuloPadrao(const Value: TDMConection);

  protected

  public

    dmCliente : TdmCliente;

    property Logado                   : Boolean        read FLogado                   default False;
    property IdUsuario                : Double         read FIdUsuario                write FIdUsuario;
    property Metodo                   : Double         read FMetodo                   write FMetodo;
    property DescMetodo               : string         read FDescMetodo               write FDescMetodo;
    property Sistema                  : Double         read FSistema                  write FSistema;
    property DescSistema              : string         read FDescSistema              write FDescSistema;
    property NomeUsuario              : string         read FNomeUsuario              write FNomeUsuario;
    property NomeLogin                : string         read FNomeLogin                write FNomeLogin;
    property SenhaUsuario             : string         read FSenhaUsuario             write FSenhaUsuario;
    property AcessoMenu               : Integer        read FAcessoMenu               write FAcessoMenu;
    property IdGrupoUsuario           : Double         read FIdGrupoUsuario           write FIdGrupoUsuario;
    property AnoLetivo                : string         read FAnoLetivo                write FAnoLetivo;
    property Semestre                 : string         read FSemestre                 write FSemestre;
    property Secretario               : Boolean        read FSecretario               write FSecretario;
    property Ativo                    : Boolean        read FAtivo                    write FAtivo;

    property SuperUsuario             : Boolean        read FSuperUsuario             default False;
    property FlgWebCamUsuario         : Boolean        read FFlgWebCamUsuario         write FFlgWebCamUsuario;
    property VersaoSistema            : string         read FVersaoSistema            write FVersaoSistema;
    property LogadoBanco              : Boolean        read FLogadoBanco              write FLogadoBanco;
    property VersaoBanco              : string         read FVersaoBanco              write FVersaoBanco;
    property AppSistema               : string         read FAppSistema               write FAppSistema;

    property MensagemInfo             : string         read FMensagemInfo             write FMensagemInfo;
    property DataModuloPadrao         : TDMConection   read FDataModuloPadrao         write SetDataModuloPadrao;

    property AppNome                  : string         read FAppNome;
    property ServidorBanco            : string         read FServidorBanco;
    property Porta                    : string         read FPorta;
    property NomeBanco                : string         read FNomeBanco;
    property Protocolo                : TTipoProtocolo read FProtocolo;
    property FLGCONTROLEWEBCAM                : Boolean        read FFlgWebCam                write FFlgWebCam;

    constructor Create;
    function ExisteForm(frm: TForm): Boolean;
    procedure ShowForm(var Frm; TFrm: TFormClass; bModal: Boolean);
    function VerificaSuperSenha(const sSenha: string): Boolean;
    function Mensagem(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; Titulo: string; HelpCtx: Longint): TModalResult;
    function MensErroCod(CodErro: LongInt): string;
    function MyFormatFloat(sValor: string): string; { Inclu�do em 02/07/01}
    function ObtemNumero(sNumero: string): string;
    function SistAD(S: string; T: Integer): string;
    function SistAE(S: string; T: Integer): string;
    function SistSpc(QTD: Integer): string;
    function SistMascaraAlfa(S: string): string;
    function ValidarCNPJ(sCNPJ: string): boolean;
    function ValidarCPF(sCPF: string): boolean;
    function Idade(DataNascimento: TDateTime): string;

    function   iDay(Value: TDateTime): Integer;
    function   cDay(Value: TDateTime): string;
    function iMonth(Value: TDateTime): Integer;
    function cMonth(Value: TDateTime): string;
    function sMonth(Value: TDateTime): string;
    function  cYear(Value: TDateTime): string;

    procedure LiberaDestroiStrList(AList: TStrings);
    procedure LiberaStrList(AList: TStrings);
    procedure LiberaList(AList: TList);
    procedure LiberaDestroiList(AList: TList);
    procedure LiberaObjeto(var Obj);
  end;

const

  NumMeses = 12;
  NomeMes: array[1..12] of string[10] = ('Janeiro',
                                         'Fevereiro',
                                         'Mar�o',
                                         'Abril',
                                         'Maio',
                                         'Junho',
                                         'Julho',
                                         'Agosto',
                                         'Setembro',
                                         'Outubro',
                                         'Novembro',
                                         'Dezembro');

  ShortDayNames: array[1..7] of string[3] =  ('Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab');

  DayNamesJunt: string = 'Dom,Seg,Ter,Qua,Qui,Sex,Sab';

  TabDiasMes: array[1..12] of string[2] = ('31', '28', '31', '30', '31', '30', '31', '31', '30', '31', '30', '31');

  LowerKey: string = 'abcdefghijklmnopqrstuvwxyz���������';
  UpperKey: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ���������';
  Number  : string = '.,-+0123456789';

  b_AceitaVazio : Boolean = True;
  k_vazio       : string  = '';
  k_Zero        : string  = '0';
  k_Ponto       : string  = '.';
  k_virgula     : string  = ',';

  CHAVE_RAIZ: HKEY = HKEY_CURRENT_USER;
  WS_CHILD                     = $40000000;
  WS_VISIBLE                   = $10000000;
  WM_WEBCAM                    = $400;
  WM_CONECTAR_DRIVER_WEBCAM    = WM_WEBCAM + $a;
  WM_DESCONECTAR_DRIVER_WEBCAM = WM_WEBCAM + $b;
  WM_CAP_GRAB_FRAME            = WM_WEBCAM + 60;
  WM_GUARDAR_CAPTURA           = WM_WEBCAM + 25;
  WM_FECHAR_WEBCAM             = $0010;

  WM_CAP_START                    = WM_USER          ;
  WM_CAP_STOP                     = WM_CAP_START + 68;
  WM_CAP_DRIVER_CONNECT           = WM_CAP_START + 10;
  WM_CAP_DRIVER_DISCONNECT        = WM_CAP_START + 11;
  WM_CAP_SAVEDIB                  = WM_CAP_START + 25;
//  WM_CAP_GRAB_FRAME               = WM_CAP_START + 60;
  WM_CAP_SEQUENCE                 = WM_CAP_START + 62;
  WM_CAP_FILE_SET_CAPTURE_FILEA   = WM_CAP_START + 20;
  WM_CAP_SEQUENCE_NOFILE          = WM_CAP_START + 63;
  WM_CAP_SET_OVERLAY              = WM_CAP_START + 51;
  WM_CAP_SET_PREVIEW              = WM_CAP_START + 50;
  WM_CAP_SET_CALLBACK_VIDEOSTREAM = WM_CAP_START +  6;
  WM_CAP_SET_CALLBACK_ERROR       = WM_CAP_START +  2;
  WM_CAP_SET_CALLBACK_STATUSA     = WM_CAP_START +  3;
  WM_CAP_SET_CALLBACK_FRAME       = WM_CAP_START +  5;
  WM_CAP_SET_SCALE                = WM_CAP_START + 53;
  WM_CAP_SET_PREVIEWRATE          = WM_CAP_START + 52;

var
  RAIZ_REG: string = 'SoftWare\RNP\';
  Sistema: TSistema;
  HWebCam: HWND;
  DMConection : TDMConection;
  DataLimiteSistema : TDateTime;

function  capCreateCaptureWindowA(lpszWindowName: pchar;
                                  dwStyle: dword;
                                  x, y, nWidth, nHeight: word;
                                  ParentWin: dword;
                                  nId: word): dword; stdcall external 'avicap32.dll';

procedure SelecionarImagens(ALstArquivos: TListBox);
function AssociarAlunoFoto(ANomeImagem: string): string;
function NullIsEmpty(Text: TMaskedText; Tipo: string; Default: String = ''; Vazio: Boolean = False): string;
function VersaoExe: String;

  // Fun��es de Banco de Dados
procedure AplicaAlteracao(const vDSet: array of TDataSet);
procedure StartTransacao;
procedure CommitTransacao;
procedure RollBackTransacao;
procedure CommitTransacao2;
procedure RollBackTransacao2;
function CommaPoint(var Key: char): Boolean;

procedure Delete(Arquivo: string);

function IsLetter(Text: String): Boolean;
function IsNumber(Text: String): Boolean;
function IsDate(Text: string): Boolean;

function KeyLetter(var Key: char): Boolean;
function KeyNumber(var Key: char): Boolean;
function KeyDate(var Key: char): Boolean;
function ExecutarQuery(sSql: string): Boolean;  Overload
function LeUltRegistro(sNomeTabela: string): LongInt;
function LerProxNumero(sNomeTabela: string; iLimite: LongInt): LongInt;

// Fun��es de Registry
function LerReg(Chave,
  NomeValor: string;
  PodeCriar: Boolean = True;
  ValorPadrao: string = '';
  ChaveRaiz: HKEY = HKEY_CURRENT_USER): string; Overload;

function LerReg(Chave,
  NomeValor: string;
  PodeCriar: Boolean = True;
  ValorPadrao: Integer = 0;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER): Integer; Overload;

procedure GravaReg(Valor: Integer;
  Chave,
  NomeValor: string;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER); OverLoad;

procedure GravaReg(Valor, Chave, NomeValor: string;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER); OverLoad;

function CreateOpenRegistry(Chave: string; PodeCriar: Boolean = True;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER): TRegistry;

function ToDate(d: TDateTime): string;

function Cripto(sTexto: string): string;
function DesCripto(sTexto: string): string;

function Criptografa(sTexto: string): string;
function Descriptografa(sTexto: string): string;

function ComboBoxDropDownCount(var ObjetoComboBox: TComboBox; Lines: Integer): Integer;
function DBComboBoxDropDownCount(var ObjetoDBComboBox: TDBComboBox; Lines: Integer): integer;
function DBGridDropDownRows(var ObjetoDBGrid: TDBGrid; Column: Integer; Lines: Integer): integer;
function LookupComboBoxDropDownRows(var ObjetoLookupComboBox: TDBLookupComboBox; Lines: Integer): integer;

function Completar(sString: string;
                   iTamanho: integer;
                   sCaracter: string;
                   Tipo: TPreenchimento = pDireita;
                   bRemoveEspacos: Boolean = False): string;

function StrZero(TextFormat: string; Value: Integer): string;
function Replicate(TextRepeat: string; Value: Integer): String;
function Idade(DataNascimento: TDateTime): string;

function PontoToVirg(sVALOR: string): string;
function VirgToPonto(sVALOR: string): string;

function PontoToEmpty(sVALOR: string): string;

function BooleanIsStr(Value: Boolean): string;

function SelectADirectory(var ADestino : string; AOrigem: String = 'C:\'; AMensagem: string = 'Selecione uma Pasta'): boolean;

function IndexStr(T: string; S: Array of string): Integer;
function CharInSet(key: char; S: Array of string): Boolean;
function FindArray(T: string; S: Array of string): Boolean;
function Space(iLen: Integer): string;
function KeyUpperCase(key: char): char;
function KeyLowerCase(key: char): char;

implementation

constructor TSistema.Create;
begin
  inherited Create;
  dmCliente          := TdmCliente.Create(application);
end;

procedure TSistema.LiberaStrList(AList: TStrings);
begin
  if AList <> nil then
  begin
    while AList.Count > 0 do
    begin
      if AList.Objects[0] <> nil then
        TObject(AList.Objects[0]).Free;
      AList.Delete(0);
    end;
  end;
end;

procedure TSistema.LiberaDestroiStrList(AList: TStrings);
begin
  LiberaStrList(AList);
  LiberaObjeto(AList);
end;

procedure TSistema.LiberaList(AList: TList);
begin
  if AList <> nil then
  begin
    if AList.Count > 0 then
    begin
      AList.Pack;
      while AList.Count > 0 do
      begin
        if AList.Items[0] <> nil then
          TObject(AList.Items[0]).Free;
        AList.Delete(0);
      end;
      AList.Pack;
    end;
  end;
end;

procedure TSistema.LiberaDestroiList(AList: TList);
begin
  LiberaList(AList);
  LiberaObjeto(AList);
end;

procedure TSistema.LiberaObjeto(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;
  if assigned(P) then
  begin
    try
      P.Free;
    except on EAccessViolation do
    end;
  end;
end;

function TSistema.ExisteForm(frm: TForm): Boolean;
var
  i: Integer;
begin
  result := False;
  i := 0;
  while (not result) and (i < Screen.FormCount) do
  begin
    result := Screen.Forms[i] = frm;
    inc(i);
  end
end;

function TSistema.Idade(DataNascimento: TDateTime): string;
var
    sDataNascimento : string;
    iIdade          : Integer;
    wDia1           : Word;
    wDia2           : Word;
    wMes1           : Word;
    wMes2           : Word;
    wAno1           : Word;
    wAno2           : Word;
Begin
  Result := '';

  sDataNascimento := FormatDateTime('DD/MM/YYYY', DataNascimento);

  if sDataNascimento <> ' / / ' then
  begin
    DecodeDate(Date, wAno1, wMes1, wDia1);
    DecodeDate(DataNascimento, wAno2, wMes2, wDia2);
    iIdade := wAno1 - wAno2;
    if wMes2 < wMes1 then
      Result := IntToStr(iIdade)
    else
    begin
      if ((wMes2 = wMes1) and (wDia2 <= wDia1)) then
       Result := IntToStr(iIdade)
      else
       Result := IntToStr(iIdade - 1);
    end;
  end;
end;

procedure TSistema.ShowForm(var Frm; TFrm: TFormClass; bModal: Boolean);
var
  x: Integer;
  bCriar: Boolean;
begin
  // Verifica se o form j� existe e est� exibido na tela
  bCriar := True;
  for x := 0 to Screen.FormCount - 1 do
    if Screen.Forms[x] = TForm(TFrm) then
    begin
      bCriar := False;
      Break;
    end;
  if bCriar then
    TForm(Frm) := TFrm.Create(Application);

  if bModal then
  begin
    if not TForm(Frm).Visible then
    begin
      TForm(Frm).FormStyle := fsNormal;
      TForm(Frm).Visible := False;
      TForm(Frm).ShowModal;
    end;
  end
  else
  begin
    if TForm(Frm).WindowState = wsNormal then
      TForm(Frm).Top := ((Application.MainForm.ClientHeight - 54) -
        TForm(Frm).Height) div 2;
    TForm(Frm).Show;
  end;
end;

function TSistema.VerificaSuperSenha(const sSenha: string): Boolean;
var
  dt: TDateTime;
  Ano, Mes, Dia, Hora, a, b, c: Word;
begin
  dt := Now;
  DecodeDate(Dt, Ano, Mes, Dia);
  DecodeTime(Dt, Hora, a, b, c);
  Result := IntToStr((Dia + Mes) * Ano + Hora) = sSenha;
end;

procedure AplicaAlteracao(const vDSet: array of TDataSet);
begin
  Sistema.DataModuloPadrao.CommitaTransacao;
end;


procedure Delete(Arquivo: string);
var Comando: string;
begin
  Comando := 'cmd /K del /F ' + Arquivo;
  WinExec(PAnsiChar(Comando), SW_SHOW);
end;

procedure StartTransacao;
begin
  Sistema.DataModuloPadrao.IniciaTransacao;
end;

procedure CommitTransacao;
begin
  Sistema.DataModuloPadrao.CommitaTransacao
end;

procedure RollbackTransacao;
begin
  Sistema.DataModuloPadrao.CancelaTransacao;
end;

function CommaPoint(var Key: char): Boolean;
begin
  Result := (Key = ',');
  if Result then
    Key := '.';
end;

function IsLetter(Text: String): Boolean;
var
    I : Integer;
    s : string;
    X : Char;
begin
  Result := True;
  for I := 1 to Length(Text) do
  begin
    S := UpperCase(Copy(Text,I,1));
    X := S[1];
//    Result := CharInSet(X, [#8,' ','.','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);
      Result := (Pos(X, '+,-,.,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z') > 0);
      if not Result then
        Break;
  end;
end;

function KeyLetter(var Key: char): Boolean;
begin
  Result := True;
//  Result := CharInSet(Key, [#8,' ','.','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);
//  if not Result  then
//  begin
//    Result := CharInSet(Key, ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']);
//    if not Result  then
//      key :=#0;
//  end;
end;

function IsNumber(Text: String): Boolean;
var
    I : Integer;
    S : string;
    X : Char;
begin
  Result := True;
  for I := 1 to Length(Text) do
  begin
    S := Copy(Text,I,1);
    X := S[1];
    if (X <> '.') and (X <> ',') then
      Result := (Pos(X, '+,-,1,2,3,4,5,6,7,8,9,0') > 0)
    else
      Result := True;
      
    if not Result then
      Break;
  end;
end;

function KeyNumber(var Key: char): Boolean;
begin
//  Result := CharInSet(Key, [#8,'/','-','.','1','2','3','4','5','6','7','8','9','0']);
  if key <> #8 then
  begin
    Result := (Pos(Key, '/,-,.,1,2,3,4,5,6,7,8,9,0') > 0);
    if not Result  then
      key :=#0;
  end;
end;

function IsDate(Text: string): Boolean;
var
    I : Integer;
    S : string;
    X : Char;
begin
  Result := True;
  for I := 1 to Length(Text) do
  begin
    S := Copy(Text,I,1);
    X := S[1];
//    Result := CharInSet(X, ['/','1','2','3','4','5','6','7','8','9','0']);
    Result := (Pos(X, '/,1,2,3,4,5,6,7,8,9,0') > 0);
    if not Result then
      Break;
  end;
end;

function KeyDate(var Key: char): Boolean;
begin
//  Result := CharInSet(Key, [#8,'/','1','2','3','4','5','6','7','8','9','0']);
  if key <> #8 then
  begin
    Result := (Pos(Key, '/,1,2,3,4,5,6,7,8,9,0') > 0);
    if not Result  then
      key :=#0;
  end;
end;

function ExecutarQuery(sSql: string): Boolean;
begin
  Result := True;
  try
    dmCliente.qryConexaoPadrao.Close;
    dmCliente.qryConexaoPadrao.Sql.Clear;
    dmCliente.qryConexaoPadrao.Sql.Text := sSql;
    dmCliente.qryConexaoPadrao.ExecSQL;
    dmCliente.qryConexaoPadrao.Free;
  except
    on E: Exception do
    begin
      Result := False;
      Sistema.MensagemInfo := e.message;
    end;
  end;
end;

function LeUltRegistro(sNomeTabela: string): LongInt;
var
  sSql, IdTabela: string;
begin
  if dmCliente.FazerQuery('SELECT GEN_ID( GEN' + AnsiUpperCase(sNomeTabela) +
    ',1) AS SEQUENCE FROM RDB$DATABASE') then
    Result := dmCliente.qryConexaoPadrao.FieldByName('SEQUENCE').asInteger
  else
  begin
    try //Para setar o generator criado com o max da tabela
      sSql := '';
      sSql := ' select a.rdb$index_name, b.rdb$field_name from rdb$indices a,';
      sSql := sSql + ' rdb$index_segments b';
      sSQl := sSql + ' where a.rdb$relation_name = ''' +
        AnsiUpperCase(sNomeTabela) + '''';
      sSql := sSql + ' and a.rdb$index_name like ''RDB$PRIMARY%''';
      sSql := sSql + ' and a.rdb$index_name = b.rdb$index_name';
      if dmCliente.FazerQuery(sSql) then
        IdTabela := trim(dmCliente.qryConexaoPadrao.FieldValues['rdb$field_name']);

      if dmCliente.FazerQuery('SELECT MAX(' + IdTabela + ') FROM ' +
        AnsiUpperCase(sNomeTabela)) then
        Result := dmCliente.qryConexaoPadrao.FieldValues['Max'] + 1
      else
        Result := 1;

      StartTransacao;
      ExecutarQuery('CREATE GENERATOR GEN' + AnsiUpperCase(sNomeTabela));
      ExecutarQuery('SET GENERATOR GEN' + AnsiUpperCase(sNomeTabela) + ' TO ' +     IntToStr(Result));
      CommitTransacao;
    except
      RollBackTransacao;
      raise;
    end;
  end;
end;

function LerProxNumero(sNomeTabela: string; iLimite: LongInt): LongInt;
begin
  if dmCliente.FazerQuery('SELECT GEN_ID( GEN' + AnsiUpperCase(sNomeTabela) + ',1) AS SEQUENCE FROM RDB$DATABASE') then
  begin
    Result := dmCliente.qryConexaoPadrao.FieldValues['SEQUENCE'];
    if Result >= iLimite then
    begin
      Result := 1;
      try
        ExecutarQuery('SET GENERATOR GEN' + AnsiUpperCase(sNomeTabela) +       ' TO 1');
      except
        raise;
      end;
    end;
  end
  else
  begin
    Result := 1;
    try
      ExecutarQuery('CREATE GENERATOR GEN' + AnsiUpperCase(sNomeTabela));
      ExecutarQuery('SET GENERATOR GEN' + AnsiUpperCase(sNomeTabela) + ' TO 1');
    except
      raise;
    end;
  end;
  //  CommitTransacao;
end;

function LerReg(Chave, NomeValor: string; PodeCriar: Boolean = True;
  ValorPadrao: string = '';
  ChaveRaiz: HKEY = HKEY_CURRENT_USER): string;
var
  Reg: TRegistry;
begin
  Result := ValorPadrao;
  Reg := CreateOpenRegistry(Chave, PodeCriar, ChaveRaiz);
  if Reg <> nil then
  try
    if Reg.ValueExists(NomeValor) then
    try
      Result := Reg.ReadString(NomeValor);
    except
      Result := ValorPadrao
    end
    else if PodeCriar then
      Reg.WriteString(NomeValor, ValorPadrao);
  finally
    Reg.Free;
  end;
end;

function LerReg(Chave, NomeValor: string; PodeCriar: Boolean = True;
  ValorPadrao: Integer = 0;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER): Integer;
var
  Reg: TRegistry;
begin
  Result := ValorPadrao;
  Reg := CreateOpenRegistry(Chave, PodeCriar, ChaveRaiz);
  if Reg <> nil then
  try
    if Reg.ValueExists(NomeValor) then
    try
      Result := Reg.ReadInteger(NomeValor);
    except
      Result := ValorPadrao
    end
    else if PodeCriar then
      Reg.WriteInteger(NomeValor, ValorPadrao);
  finally
    Reg.Free;
  end;
end;

procedure GravaReg(Valor: Integer; Chave, NomeValor: string;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER);
var
  Reg: TRegistry;
begin
  Reg := CreateOpenRegistry(Chave, True, ChaveRaiz);
  if Reg <> nil then
  try
    Reg.WriteInteger(NomeValor, Valor);
  finally
    Reg.Free;
  end;
end;

procedure GravaReg(Valor, Chave, NomeValor: string;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER);
var
  Reg: TRegistry;
begin
  Reg := CreateOpenRegistry(Chave, True, ChaveRaiz);
  if Reg <> nil then
  try
    Reg.WriteString(NomeValor, Valor);
  finally
    Reg.Free;
  end;
end;

function CreateOpenRegistry(Chave: string; PodeCriar: Boolean = True;
  ChaveRaiz: HKEY = HKEY_CURRENT_USER): TRegistry;
begin
  Result := TRegistry.Create;
  try
    Result.RootKey := ChaveRaiz;
    Result.OpenKey(Chave, PodeCriar);
  except
    Result.Free;
    Result := nil;
  end;
end;

function ToDate(d: TDateTime): string;
begin
  Result := ' CAST (' + QuotedStr(FormatDateTime('mm/dd/yyyy', d)) +
    ' AS DATE ) ';
end;

function Cripto(sTexto: string): string;
var
  x: Integer;
  s: string;
begin
  sTexto := Trim(AnsiUpperCase(sTexto));
  s := '';
  for x := Length(sTexto) downto 1 do
    s := s + IntToStr(Succ(Ord(sTexto[x])));
  Result := s;
end;

function Descripto(sTexto: string): string;
var
  x: Integer;
  s: string;
  c: Char;
begin
  sTexto := Trim(AnsiUpperCase(sTexto));
  s := '';
  x := 1;
  while x <= Length(sTexto) do
  begin
    c := Chr(Pred(StrToInt(Copy(sTexto, x, 2))));
    s := c + s;
    x := x + 2;
  end;
  Result := s;
end;

function Criptografa(sTexto: string): string;
var
  x: Integer;
  s: string;
begin
  sTexto := Trim(AnsiUpperCase(sTexto));
  s := '';
  for x := Length(sTexto) downto 1 do
    s := s + IntToStr(Succ(Ord(sTexto[x])));
  Result := s;
end;

function Descriptografa(sTexto: string): string;
var
  x: Integer;
  s: string;
  c: Char;
begin
  sTexto := Trim(AnsiUpperCase(sTexto));
  s := '';
  x := 1;
  while x <= Length(sTexto) do
  begin
    c := Chr(Pred(StrToInt(Copy(sTexto, x, 2))));
    s := c + s;
    x := x + 2;
  end;
  Result := s;
end;

function TSistema.Mensagem(const Msg: string; DlgType: TMsgDlgType; Buttons:
  TMsgDlgButtons; Titulo: string; HelpCtx: Longint): TModalResult;
var
  i: Integer;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
  try
    for i := 0 to ComponentCount - 1 do
      if Components[i] is TButton then
        with TButton(Components[i]) do
          case ModalResult of
            mrCancel: Caption := 'Cancelar';
            mrNo: Caption := 'N�o';
            mrYes: Caption := 'Sim';
            mrAbort: Caption := 'Abortar';
            mrRetry: Caption := 'Tentar';
            mrIgnore: Caption := 'Ignorar';
          end;
    Caption := Titulo;
    Result := ShowModal;
  finally
    Free;
  end;
end;

function TSistema.MensErroCod(CodErro: Integer): string;
begin
  case CodErro of
    335544466: Result :=
      'Este registro n�o pode ser apagado! Existe registro filho.';
    335544580: Result := 'Tabela Desconhecida.';
    335544578: Result := 'Coluna Desconhecida.';
    335544569: Result := 'Coluna Desconhecida.';
    335544558: Result := 'Viola��o da restri��o CHECK.';
    335544665: Result := 'Registro j� existente';
    335544429: Result := 'Par�metro inv�lido.';
    335544570: Result := 'Comando inv�lido.';
    335544579: Result := 'Erro interno.';
  else
    Result := 'Erro ao executar opera��o';
  end
end;

function TSistema.MyFormatFloat(sValor: string): string;
var
  i: byte;
  s1, s: string;
begin
  s := sValor;
  result := s;
  if pos(',', s) > 0 then
  begin
    if (pos(',', s) = (length(s) - 1)) then
      s := s + '0';
    try
      for i := 1 to length(s) do
        if s[i] <> ',' then
          s1 := s1 + s[i];

      s1 := copy(s1, 1, length(s1) - 2) + '.' + copy(s1, length(s1) - 1, 2);
      result := s1;
    except
      result := '0.00';
    end;
  end;
end;

function TSistema.SistAD(S: string; T: Integer): string;
var
  temp: string;
  tam, cont: Integer;
begin
  if S <> '' then
  begin
    temp := SistMascaraAlfa(s);

    if length(Temp) > T then
      temp := Copy(Temp, 1, T);

    tam := length(temp);

    for cont := 1 to t - tam do
      temp := ' ' + temp;

    result := temp;
  end
  else
    result := SistSpc(T);
end;

function TSistema.SistAE(S: string; T: Integer): string;
var
  temp: string;
  cont, tam: Integer;
begin
  if S <> '' then
  begin
    temp := SistMascaraAlfa(s);

    if length(Temp) > T then
      temp := Copy(Temp, 1, T);

    tam := length(temp);

    for cont := 1 to t - tam do
      temp := temp + ' ';
    result := temp;
  end
  else
    result := SistSpc(T);
end;

function TSistema.SistSpc(QTD: Integer): string;
var
  cont: Integer;
  t: string;
begin
  t := '';
  for cont := 1 to qtd do
    t := t + ' ';
  result := t;
end;

function TSistema.SistMascaraAlfa(S: string): string;
var
  sAuxiliar: string;
  x, iTam: Integer;
  pAuxiliar: array[0..255] of Char;
begin

  sAuxiliar := S;
  iTam := Length(sAuxiliar);
  StrpCopy(pAuxiliar, sAuxiliar);

  for X := 0 to iTam do
  begin
    if pAuxiliar[x] <> ' ' then
      if (Ord(pAuxiliar[x]) >= 192) and (Ord(pAuxiliar[x]) <= 198) then
        pAuxiliar[x] := 'A'
      else if (Ord(pAuxiliar[x]) >= 224) and (Ord(pAuxiliar[x]) <= 230) then
        pAuxiliar[x] := 'A'
      else if (Ord(pAuxiliar[x]) >= 200) and (Ord(pAuxiliar[x]) <= 203) then
        pAuxiliar[x] := 'E'
      else if (Ord(pAuxiliar[x]) >= 232) and (Ord(pAuxiliar[x]) <= 235) then
        pAuxiliar[x] := 'E'
      else if (Ord(pAuxiliar[x]) >= 204) and (Ord(pAuxiliar[x]) <= 207) then
        pAuxiliar[x] := 'I'
      else if (Ord(pAuxiliar[x]) >= 236) and (Ord(pAuxiliar[x]) <= 239) then
        pAuxiliar[x] := 'I'
      else if (Ord(pAuxiliar[x]) >= 210) and (Ord(pAuxiliar[x]) <= 214) then
        pAuxiliar[x] := 'O'
      else if (Ord(pAuxiliar[x]) >= 242) and (Ord(pAuxiliar[x]) <= 246) then
        pAuxiliar[x] := 'O'
      else if (Ord(pAuxiliar[x]) >= 217) and (Ord(pAuxiliar[x]) <= 220) then
        pAuxiliar[x] := 'U'
      else if (Ord(pAuxiliar[x]) >= 249) and (Ord(pAuxiliar[x]) <= 252) then
        pAuxiliar[x] := 'U'
      else if (Ord(pAuxiliar[x]) = 209) or (Ord(pAuxiliar[x]) = 241) then
        pAuxiliar[x] := 'N'
      else if (Ord(pAuxiliar[x]) = 199) or (Ord(pAuxiliar[x]) = 231) then
        pAuxiliar[x] := 'C'
      else if (((Ord(pAuxiliar[x]) < 48) or (Ord(pAuxiliar[x]) > 57)) and
        ((Ord(pAuxiliar[x]) < 40) or (Ord(pAuxiliar[x]) > 41)) and
        ((Ord(pAuxiliar[x]) < 65) or (Ord(pAuxiliar[x]) > 90)) and
        ((Ord(pAuxiliar[x]) < 97) or (Ord(pAuxiliar[x]) > 122))) and
        (Ord(pAuxiliar[x]) <> 44) and (Ord(pAuxiliar[x]) <> 58) then
//        and (Pos(pAuxiliar[x], FAllowChars) = 0) then
        pAuxiliar[x] := ' ';
  end;

  sAuxiliar := Copy(pAuxiliar, 1, itam);

  Result := UpperCase(sAuxiliar);
end;

function TSistema.ValidarCNPJ(sCNPJ: string): boolean;
var
  sPeso: string; // Peso para multiplica�ao
  sDig: string; // D�gito verificador digitado
  sChar: string; // Caracter
  sAntes: string;
  iConta: integer;
  iSoma: integer; // Soma dos d�gitos multiplicados pelo peso
  iTam: integer; // Tamanho da string
  iDig: integer;
  iDv: integer; // D�gito verificador calculado
begin
  // 00.382.468/0001-98

  Result := false;
  sPeso := '6543298765432';
  iTam := length(sCNPJ);
  sDig := '';

  for iConta := 1 to iTam do
  begin
    sChar := copy(sCNPJ, iConta, 1);
    if pos(sChar, '1234567890') <> 0 then
      sDig := sDig + sChar;
  end;
  if length(sDig) <> 14 then
    Exit;

  sAntes := sDig;
  sDig := copy(sDig, 1, 12);

  for iDig := 1 to 2 do
  begin
    iSoma := 0;
    iTam := 11 + iDig;
    for iConta := 1 to iTam do
      iSoma := iSoma + (StrtoInt(copy(sDig, iConta, 01)) *
        StrtoInt(copy(sPeso, 02 - iDig + iConta, 01)));
    iDv := iSoma mod 11;
    if iDv < 2 then
      sDig := sDig + '0'
    else
      sDig := sDig + InttoStr(11 - iDv);

  end;

  Result := (sDig = sAntes);
end;

function TSistema.ValidarCPF(sCPF: string): boolean;
var
  iSoma: integer; // Soma dos d�gitos multiplicados pelo peso
  sChar, Z: string; // Caracter
  sDigito: string; // D�gito verificador digitado
  iDigito: integer; // D�gito verificador calculado
  X, Y, I: integer; // Contadores
begin //Mascara do CPF deve ser a seguinte: 000.000.000-00

  // Tira os pontos da mascara do CPF
  for i := 1 to Length(sCPF) do
    if (copy(sCPF, I, 1) <> '.') and (copy(sCPF, I, 1) <> '-') then
      Z := Z + copy(sCPF, I, 1);

  sDigito := copy(Z, 01, 09);

  for Y := 1 to 2 do
  begin
    iSoma := 0;
    for X := 1 to 08 + Y do
    begin
      sChar := copy(sDigito, X, 1);
      if sChar = ' ' then
      begin
        Result := false;
        Exit;
      end;
      iSoma := iSoma + StrtoInt(sChar) * (10 + Y - X);
    end;
    iDigito := iSoma mod 11;
    if iDigito < 2 then
      sDigito := sDigito + '0'
    else
      sDigito := sDigito + InttoStr(11 - iDigito);
  end;
  Result := (sDigito = Z);
end;

function TSistema.ObtemNumero(sNumero: string): string;
var
  i: integer;
  sAux: string;
begin
  i := 1;
  sAux := '';
  while i <= length(sNumero) do
  begin
    if IsNumber(sNumero[i]) then
      sAux := sAux + sNumero[i];
    inc(i);
  end;
  result := sAux;
end;

procedure CommitTransacao2;
begin
  Sistema.DataModuloPadrao.CommitaTransacao;
end;

procedure RollbackTransacao2;
begin
  Sistema.DataModuloPadrao.CancelaTransacao;
end;

procedure TSistema.SetDataModuloPadrao(const Value: TDMConection);
begin
  FDataModuloPadrao := Value;
end;

procedure SelecionarImagens(ALstArquivos: TListBox);
var
   Schr       : TSearchRec;
   PathExec   : string;
   PathImagem : string;
   Imagens    : string;
   iArquivos  : integer;
   sArquivo   : string;
begin
  iArquivos  := 0;
  PathExec   := ExtractFilePath(Application.ExeName);
  PathImagem := PathExec + 'Fotos\';
  if SelectADirectory(Imagens, PathImagem) then
  begin
    ALstArquivos.Items.Clear;
    iArquivos := FindFirst(Imagens + '\*.JPG', faAnyFile, SCHR);
    while iArquivos = 0 do
    begin
      sArquivo := UpperCase(SCHR.Name);
      ALstArquivos.Items.Add(sArquivo);
      iArquivos := FindNext(Schr);
    end;
  end;
  ChDir(PathExec);
end;

function AssociarAlunoFoto(ANomeImagem: string): string;
Var
    PathImagem : string;
begin
  Result := '';
  PathImagem := ExtractFilePath(Application.ExeName);
  ChDir(PathImagem + 'Fotos');
  if FileExists(ANomeImagem) then
  begin
    Result := PathImagem + 'Fotos\' + ANomeImagem;
  end;
  ChDir(PathImagem);
end;

function GetImagem(AImagem: string; var AImgImagem: TImage): Boolean;
Var
    PathImagem : string;
begin
  PathImagem := ExtractFilePath(Application.ExeName) + 'Fotos\';
  Result     := FileExists(PathImagem + AImagem);
  if Result then
    AImgImagem.Picture.LoadFromFile(PathImagem + AImagem)
  else
    AImgImagem.Picture := nil;

end;

function Space(iLen: Integer): string;
var
    i: Integer;
begin
  Result := '';
  for i := 1 to iLen do
     Result := Result + ' ';
end;

function KeyUpperCase(key: char): char;
var
    ipos: Integer;
begin
  iPos := Pos(key,LowerKey);
  if (iPos > 0) then
     Result := UpperKey[iPos]
  else
     Result := key;
end;

function KeyLowerCase(key: char): char;
var
    ipos: Integer;
begin
  iPos := Pos(key,UpperKey);
  if (iPos > 0) then
     Result := LowerKey[iPos]
  else
     Result := key;
end;

function NullIsEmpty(Text: TMaskedText; Tipo: string; Default: String = ''; Vazio: Boolean = False): string;
begin

  if (Tipo = 'C') or (Tipo = 'D') then
  begin
    if (trim(Text) = '') then
    begin
       if (Tipo = 'D') then
       begin
         if (Default <> '') then
           Text := QuotedStr(StringReplace(Default,'/','.', [rfReplaceAll]))
         else
           Text := 'null';
       end
    end
    else
    begin
      if (Tipo = 'D') then
      begin
        Text := QuotedStr(StringReplace(Text,'/','.', [rfReplaceAll]));
      end;
    end;

    if (Text <> 'null') and (Tipo = 'C') then
      Text := QuotedStr(Text);

  end
  else
  begin
    if (Tipo = 'N') then
    begin
      if (trim(Text) = '') then
      begin
        if (Default <> '') then
          Text := Default
        else
          if Vazio then
            Text := ''
          else
            Text := 'null';
      end
      else
      begin
        if IsNumber(Text) then
          Text := VirgToPonto(Text)
        else
          if Vazio then
            Text := ''
          else
            Text := 'null';
      end;
    end;
  end;
  Result := Text;
end;

function VersaoExe: String;
type
    PFFI = ^vs_FixedFileInfo;
var
    F : PFFI;
    Handle : Dword;
    Len : Longint;
    Data : Pchar;
    Buffer : Pointer;
    Tamanho : Dword;
    Parquivo: Pchar;
    Arquivo : String;
begin
    Result   := '';
    Arquivo  := Application.ExeName;
    Parquivo := StrAlloc(Length(Arquivo) + 1);
    StrPcopy(Parquivo, Arquivo);
    Len := GetFileVersionInfoSize(Parquivo, Handle);
    if Len > 0 then
    begin
        Data:=StrAlloc(Len+1);
        if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
        begin
            VerQueryValue(Data, '\',Buffer,Tamanho);
            F := PFFI(Buffer);
            Result := Format('%d.%d.%d.%d',[HiWord(F^.dwFileVersionMs),LoWord(F^.dwFileVersionMs),HiWord(F^.dwFileVersionLs),Loword(F^.dwFileVersionLs)]);
        end;
        StrDispose(Data);
    end;
    StrDispose(Parquivo);
end;

function BooleanIsStr(Value: Boolean): string;
begin
  if Value then
    Result := 'S'
  else
    Result := 'N';
end;

function DateIsEmpty(Value: TDate): string;
begin
  if (DateToStr(Value) = '//') then
    Result := ''
  else
    Result := DateToStr(Value);
end;

function SelectADirectory(var ADestino : string; AOrigem: String = 'C:\'; AMensagem: string = 'Selecione uma Pasta') : boolean;
begin
  Result :=  SelectDirectory(AMensagem, AOrigem , ADestino);
end;

function IndexStr(T: string; S: Array of string): integer;
var
    i : Integer;
    n : Integer;
Begin
  Result := 0;
  n := Length(s)-1;
  T := Trim(T);
  for i := 0 to n do
  begin
    if Pos(T, S[i]) > 0 then
    begin
      Result := i;
      Break;
    end
  end
End;

function CharInSet(key: char; S: Array of string): Boolean;
var
    i : Integer;
Begin
  Result := False;
  for i := 0 to Length(s) do
  begin
    if Pos(key, S[i]) > 0 then
    begin
      Result := True;
      Break;
    end
  end
end;

function FindArray(T: string; S: Array of string): Boolean;
var
    i : Integer;
    n : Integer;
Begin
  Result := False;
  n := Length(s)-1;
  T := Trim(T);
  for i := 0 to n do
  begin
    if Pos(T, S[i]) > 0 then
    begin
      Result := True;
      Break;
    end
  end
End;

function TSistema.iDay(Value: TDateTime): Integer;
var
    sData : string;
begin
  sData  := FormatDateTime('DD/MM/YYYY', Value);
  Result := StrToInt(Copy(sData, 1, 2));
end;

function TSistema.cDay(Value: TDateTime): string;
var
    sData : string;
begin
  sData  := FormatDateTime('DD/MM/YYYY', Value);
  Result := Copy(sData, 1, 2);
end;

function TSistema.iMonth(Value: TDateTime): Integer;
var
    sData : string;
begin
  sData  := FormatDateTime('DD/MM/YYYY', Value);
  Result := StrToInt(Copy(sData, 4, 2));
end;

function TSistema.cMonth(Value: TDateTime): string;
var
    sData : string;
begin
  sData := FormatDateTime('DD/MM/YYYY', Value);
  Result := Copy(sData, 4, 2);
end;

function TSistema.sMonth(Value: TDateTime): string;
var
    sData : string;
    iMes  : Integer;
begin
  sData  := FormatDateTime('DD/MM/YYYY', Value);
  iMes   := StrToInt(Copy(sData, 4, 2));
  Result := NomeMes[iMes];
end;

function TSistema.cYear(Value: TDateTime): string;
var
    sData : string;
begin
  sData := FormatDateTime('DD/MM/YYYY', Value);
  Result := Copy(sData, 7, 4);
end;

function ComboBoxDropDownCount(var ObjetoComboBox: TComboBox; Lines: Integer): integer;
begin
  if (ObjetoComboBox.Items.Count <= Lines) then
    ObjetoComboBox.DropDownCount := ObjetoComboBox.Items.Count
  else
    ObjetoComboBox.DropDownCount :=  Lines;
  Result := ObjetoComboBox.DropDownCount;
end;

function DBComboBoxDropDownCount(var ObjetoDBComboBox: TDBComboBox; Lines: Integer): integer;
begin
  if (ObjetoDBComboBox.Items.Count <= Lines) then
    ObjetoDBComboBox.DropDownCount := ObjetoDBComboBox.Items.Count
  else
    ObjetoDBComboBox.DropDownCount := Lines;
  Result := ObjetoDBComboBox.DropDownCount;
end;

function DBGridDropDownRows(var ObjetoDBGrid: TDBGrid; Column: Integer; Lines: Integer): integer;
begin
  if (ObjetoDBGrid.Columns[Column].PickList.Count <= Lines) then
    ObjetoDBGrid.Columns[Column].DropDownRows := ObjetoDBGrid.Columns[0].PickList.Count
  else
    ObjetoDBGrid.Columns[Column].DropDownRows := Lines;
  Result := ObjetoDBGrid.Columns[Column].DropDownRows;
end;

function LookupComboBoxDropDownRows(var ObjetoLookupComboBox: TDBLookupComboBox; Lines: Integer): integer;
begin
  if (ObjetoLookupComboBox.ListSource.DataSet.RecordCount <= Lines) then
    ObjetoLookupComboBox.DropDownRows := ObjetoLookupComboBox.ListSource.DataSet.RecordCount
  else
    ObjetoLookupComboBox.DropDownRows := Lines;
  Result := ObjetoLookupComboBox.DropDownRows;
end;

function Completar(sString: string;
                            iTamanho: integer;
                            sCaracter: string;
                            Tipo: TPreenchimento = pDireita;
                            bRemoveEspacos: Boolean = False): string;
var
  sNewString        : string;
  sChar             : string;
  iConta            : integer;
  iDiferenca        : integer;
  iComplemento      : integer;
begin
  if iTamanho < length(sString) then
  begin
    iTamanho := length(sString);
  end;

  Result := '';
  for iConta := 1 to iTamanho do
  begin
    sChar := copy(sString, iConta, 1);
    if (bRemoveEspacos) and (sChar = ' ') then
      sChar := '';
    sNewString := sNewString + sChar;
  end;

  iDiferenca := iTamanho - length(sNewString);
  Result := sNewString;

  if iDiferenca > 0 then
  begin
    if (tipo <> pCentro) then
    begin
      for iConta := 1 to iDiferenca do
      begin
        if (Tipo = pEsquerda) then
          Result := sCaracter + Result
        else
          Result := Result + sCaracter;
      end;
    end
    else
    begin
      iComplemento := iDiferenca;
      iDiferenca   := Trunc(iDiferenca / 2);
      iComplemento := (iComplemento - iDiferenca);
      for iConta := 1 to iDiferenca do
      begin
        Result := sCaracter + Result
      end;
      for iConta := 1 to iComplemento do
      begin
          Result := Result + sCaracter;
      end;
    end;
  end;
end;

function StrZero(TextFormat: string; Value: Integer): string;
var
    i : Integer;
    h : Integer;
begin
  Result := '';
  h := Length(TextFormat);
  if (h < Value) then
  begin
    h := Value - Length(TextFormat);
    begin
      for i := 1 to h do
        Result := Result + '0';

      Result := Result + TextFormat;
    end
  end
  else
    Result := TextFormat;
end;

function Replicate(TextRepeat: string; Value: Integer): String;
begin
  Result := StringofChar(TextRepeat[1], Value);
end;

function Idade(DataNascimento: TDateTime): string;
var
    sDataNascimento : string;
    iIdade          : Integer;
    wDia1           : Word;
    wDia2           : Word;
    wMes1           : Word;
    wMes2           : Word;
    wAno1           : Word;
    wAno2           : Word;
Begin
  Result := '';

  sDataNascimento := FormatDateTime('DD/MM/YYYY', DataNascimento);

  if sDataNascimento <> ' / / ' then
  begin
    DecodeDate(Date, wAno1, wMes1, wDia1);
    DecodeDate(DataNascimento, wAno2, wMes2, wDia2);
    iIdade := wAno1 - wAno2;
    if wMes2 < wMes1 then
      Result := IntToStr(iIdade)
    else
    begin
      if ((wMes2 = wMes1) and (wDia2 <= wDia1)) then
       Result := IntToStr(iIdade)
      else
       Result := IntToStr(iIdade - 1);
    end;
  end;
end;

function PontoToVirg(sVALOR: string): string;
begin
  Result := StringReplace(sVALOR, '.', ',', []);
end;

function VirgToPonto(sVALOR: string): string;
begin
  Result := StringReplace(sVALOR, ',', '.', []);
end;

function PontoToEmpty(sVALOR: string): string;
begin
  Result := StringReplace(sVALOR, '.', '', []);
end;


end.



