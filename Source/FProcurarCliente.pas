unit fProcurarCliente;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, Db, DBClient, ddmCliente, uSistemaIB,
  DBCtrls, ImgList, DBGrids, System.ImageList;
type
  TfrmProcurarCliente = class(TForm)
    pgProc                 : TPageControl;
    TabOpcoes              : TTabSheet;
    TabResultado           : TTabSheet;
    grdOpcoes              : TStringGrid;
    dbgrdFBProcurarCliente : TDBGrid;
    Panel1                 : TPanel;
    Panel2                 : TPanel;
    btnOk                  : TBitBtn;
    BtnCancelar            : TBitBtn;
    BtnSair                : TBitBtn;
    BtnAjuda               : TBitBtn;
    ImageList1             : TImageList;
    btnBtnSair             : TBitBtn;
    btnBtnAjuda            : TBitBtn;
    btnConfirmar           : TBitBtn;
    pnlPesquisar           : TPanel;
    edtPesquisar           : TEdit;
    btnLocalizar           : TBitBtn;
    edtStatus              : TEdit;
    rgTipoPesquisa         : TRadioGroup;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure btnBtnSairClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure edtPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure rgTipoPesquisaClick(Sender: TObject);
    procedure dbgrdFBProcurarClienteKeyPress(Sender: TObject;
      var Key: Char);
    procedure dbgrdFBProcurarClienteDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FIdRecno        : Integer;
    FIdRetorno      : Integer;
    FNome           : string;
    FDocumento      : string;
    FDataNascimento : string;

    procedure SetDataSource;
    function ValidarChavePesquisa: Boolean;

    procedure SetSql(const Value: TStringList);
    procedure SetIdRetorno(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetIdRecno(const Value: Integer);
    procedure SetDataNascimento(const Value: string);
    procedure SetDocumento(const Value: string);
    procedure SetTipoPessoa(const Value: string);
    function GetDataNascimento: string;
    function GetDocumento: string;
    function GetGetIdRecno: Integer;
    function GetIdRetorno: Integer;
    function GetNome: string;
    function GetSql: TStringList;
    function GetTipoPessoa: string;

  public
    { Public declarations }
    DataModule  : TdmCliente;
    FSql        : TStringList;
    FTipoPessoa : string;

    property Sql            : TStringList read GetSql            write SetSql;
    property TipoPessoa     : string      read GetTipoPessoa     write SetTipoPessoa;
    property IdRecno        : Integer     read GetGetIdRecno     write SetIdRecno;
    property IdRetorno      : Integer     read GetIdRetorno      write SetIdRetorno;
    property Nome           : string      read GetNome           write SetNome;
    property Dcoumento      : string      read GetDocumento      write SetDocumento;
    property DataNascimento : string      read GetDataNascimento write SetDataNascimento;
  end;

var
   frmProcurarCliente: TfrmProcurarCliente;

implementation

{$R *.DFM}

procedure TfrmProcurarCliente.FormCreate(Sender: TObject);
begin
  FSql := TStringList.Create;
  DataModule := TdmCliente.Create(Self);
  SetDataSource;
end;

procedure TfrmProcurarCliente.FormActivate(Sender: TObject);
begin
  rgTipoPesquisa.ItemIndex := 0;
  DataModule.qryConexaoPadrao.Close;
  DataModule.qryConexaoPadrao.SQL.Clear;
  DataModule.qryConexaoPadrao.SQL.Text := FSql.Text;
  DataModule.qryConexaoPadrao.Open;
  if DataModule.qryConexaoPadrao.IsEmpty then
  begin
    ShowMessage('N�o Existe(m) registro(s) para selecionar!');
    BtnSair.Click;
  end;
end;

procedure TfrmProcurarCliente.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DataModule.qryConexaoPadrao.Close;
  FreeAndNil(FSql);
  FreeAndNil(dmCliente);
end;

procedure TfrmProcurarCliente.btnBtnSairClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

procedure TfrmProcurarCliente.btnConfirmarClick(Sender: TObject);
begin
  FIdRecno        := dbgrdFBProcurarCliente.DataSource.DataSet.RecNo;
  FIdRetorno      := dbgrdFBProcurarCliente.DataSource.DataSet.FieldByName('IDRETORNO').AsInteger;
  FNome           := dbgrdFBProcurarCliente.DataSource.DataSet.FieldByName('NOME').AsString;
  FDocumento      := dbgrdFBProcurarCliente.DataSource.DataSet.FieldByName('DOCUMENTO').AsString;
  FDataNascimento := FormatDateTime('MM/DD/YYYY', dbgrdFBProcurarCliente.DataSource.DataSet.FieldByName('DATANASCIMENTO').AsDateTime);
  ModalResult     := mrOk;
end;

procedure TfrmProcurarCliente.btnLocalizarClick(Sender: TObject);
var
   Found           : Boolean;
begin
  Found := False;
  ValidarChavePesquisa;
  case rgTipoPesquisa.ItemIndex of
    0: Found := DataModule.qryConexaoPadrao.Locate('NOME'           , edtPesquisar.Text , [loPartialKey]);
    1: Found := DataModule.qryConexaoPadrao.Locate('DOCUMENTO'      , edtPesquisar.Text , [loPartialKey]);
    2: Found := DataModule.qryConexaoPadrao.Locate('DATANASCIMENTO' , edtPesquisar.Text , [loPartialKey]);
  end;
  edtStatus.Enabled := True;
  if Found then
    edtStatus.Text := 'Found'
  else
    edtStatus.Text := 'Not Found';
  edtStatus.Enabled := False;
  dbgrdFBProcurarCliente.Columns.Grid.SetFocus;
end;

function TfrmProcurarCliente.ValidarChavePesquisa: Boolean;
var
    sChavePesquisa : string;
begin
  Result := True;
  sChavePesquisa := Trim(edtPesquisar.Text);
  case rgTipoPesquisa.ItemIndex of
    0: begin
         if (IsLetter(sChavePesquisa)) then
         begin
           rgTipoPesquisa.ItemIndex := 0;
           edtPesquisar.Text := sChavePesquisa;
           edtPesquisar.Repaint;
           edtPesquisar.Refresh;
         end;
       end;
    1: begin
         if (IsLetter(sChavePesquisa)) then
         begin
           rgTipoPesquisa.ItemIndex := 1;
           edtPesquisar.Text := sChavePesquisa;
           edtPesquisar.Repaint;
           edtPesquisar.Refresh;
         end;
       end;
    2: begin
         if (IsLetter(sChavePesquisa)) then
         begin
           rgTipoPesquisa.ItemIndex := 2;
           sChavePesquisa := StringReplace(edtPesquisar.Text,'/','.',[]);
           edtPesquisar.Text := sChavePesquisa;
           edtPesquisar.Repaint;
           edtPesquisar.Refresh;
         end;
       end;
  else ;
     Result := False;
  end;
end;

procedure TfrmProcurarCliente.dbgrdFBProcurarClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btnConfirmar.Click;
end;

procedure TfrmProcurarCliente.dbgrdFBProcurarClienteDblClick(Sender: TObject);
begin
  btnConfirmar.Click;
end;

procedure TfrmProcurarCliente.edtPesquisarKeyPress(Sender: TObject;  var Key: Char);
begin
  if Key = #13 then
  begin
    btnLocalizar.Click;
  end;
end;

procedure TfrmProcurarCliente.rgTipoPesquisaClick(Sender: TObject);
begin
  edtPesquisar.Text       := '';
  edtPesquisar.CharCase   := ecUpperCase;
  edtPesquisar.Enabled    := True;
  edtPesquisar.SetFocus;
  btnLocalizar.Caption    := '';
  btnLocalizar.Enabled    := True;
end;

function TfrmProcurarCliente.GetDataNascimento: string;
begin
  Result := FDataNascimento;
end;

function TfrmProcurarCliente.GetDocumento: string;
begin
  Result := FDocumento;
end;

function TfrmProcurarCliente.GetGetIdRecno: Integer;
begin
  Result := FIdRecno;
end;

function TfrmProcurarCliente.GetIdRetorno: Integer;
begin
  Result := FIdRetorno;
end;

function TfrmProcurarCliente.GetNome: string;
begin
  Result := FNome;
end;

function TfrmProcurarCliente.GetSql: TStringList;
begin
  Result := FSql;
end;

function TfrmProcurarCliente.GetTipoPessoa: string;
begin
  Result := FTipoPessoa;
end;

procedure TfrmProcurarCliente.SetDataNascimento(const Value: string);
begin
  FDataNascimento := Value;
end;

procedure TfrmProcurarCliente.SetDataSource;
begin
  dbgrdFBProcurarCliente.DataSource := DataModule.dsConexaoPadrao;
end;

procedure TfrmProcurarCliente.SetDocumento(const Value: string);
begin
  FDocumento := Value;
end;

procedure TfrmProcurarCliente.SetIdRecno(const Value: Integer);
begin
  FIdRecno := Value;
end;

procedure TfrmProcurarCliente.SetIdRetorno(const Value: Integer);
begin
  FIdRetorno := Value;
end;

procedure TfrmProcurarCliente.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TfrmProcurarCliente.SetSql(const Value: TStringList);
begin
  FSql := Value;
end;

procedure TfrmProcurarCliente.SetTipoPessoa(const Value: string);
begin
  FTipoPessoa := Value;
end;

end.
