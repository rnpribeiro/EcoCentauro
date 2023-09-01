unit fProcurarTelefone;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, Db, DBClient, ddmCliente, uSistemaIB,
  DBCtrls, ImgList, DBGrids, System.ImageList;
type
  TfrmProcurarTelefone = class(TForm)
    pgProc          : TPageControl;
    TabOpcoes       : TTabSheet;
    TabResultado    : TTabSheet;
    grdOpcoes       : TStringGrid;
    Panel1          : TPanel;
    Panel2          : TPanel;
    btnOk           : TBitBtn;
    BtnCancelar     : TBitBtn;
    BtnSair         : TBitBtn;
    BtnAjuda        : TBitBtn;
    ImageList1      : TImageList;
    dbgrdFBProcurarTelefone: TDBGrid;
    btnBtnSair      : TBitBtn;
    btnBtnAjuda     : TBitBtn;
    btnConfirmar    : TBitBtn;
    pnlPesquisar    : TPanel;
    edtPesquisar    : TEdit;
    edtStatus       : TEdit;
    rgTipoPesquisa  : TRadioGroup;
    btnLocalizar: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure btnBtnSairClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure dbgrdFBProcurarTelefoneDblClick(Sender: TObject);
    procedure edtPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure rgTipoPesquisaClick(Sender: TObject);
    procedure dbgrdFBProcurarTelefoneKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FIdRecno     : Integer;
    FId_Telefone : Integer;
    FId_Cliente  : integer;
    FNome        : string; 

    procedure SetDataSource;
    procedure SetSql(const Value: TStringList);
    procedure SetIdRecno(const Value: Integer);
    function ValidarChavePesquisa: Boolean;
    procedure SetId_Cliente(const Value: Integer);
    procedure SetId_Telefone(const Value: Integer);
    procedure SetNome(const Value: string);
  public
    { Public declarations }
    DataModule : TdmCliente;
    FSql       : TStringList;

    property Sql         : TStringList read FSql         write SetSql;
    property IdRecno     : Integer     read FIdRecno     write SetIdRecno;
    property Id_Telefone : Integer     read FId_Telefone write SetId_Telefone;
    property Id_Cliente  : Integer     read FId_Cliente  write SetId_Cliente;
    property Nome        : string      read FNome        write SetNome;
  end;

var
   frmProcurarTelefone: TfrmProcurarTelefone;

implementation

{$R *.DFM}

procedure TfrmProcurarTelefone.FormCreate(Sender: TObject);
begin
  FSql := TStringList.Create;
  DataModule := TdmCliente.Create(Self);
  SetDataSource;
end;

procedure TfrmProcurarTelefone.FormShow(Sender: TObject);
begin
  rgTipoPesquisa.ItemIndex := 0;

  DataModule.DataModule.qryConexaoPadrao.Close;
  DataModule.DataModule.qryConexaoPadrao.SQL.Clear;
  DataModule.DataModule.qryConexaoPadrao.SQL.Text := FSql.Text;
  DataModule.DataModule.qryConexaoPadrao.Open;
  if DataModule.DataModule.qryConexaoPadrao.IsEmpty then
  begin
    ShowMessage('Não Existe(m) registro(s) para selecionar!');
    ModalResult := mrCancel;
  end;
end;

procedure TfrmProcurarTelefone.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DataModule.DataModule.qryConexaoPadrao.Close;
  FreeAndNil(FSql);
  FreeAndNil(DataModule);
end;

procedure TfrmProcurarTelefone.SetSql(const Value: TStringList);
begin
  FSql := Value;
end;

procedure TfrmProcurarTelefone.SetDataSource;
begin
  dbgrdFBProcurarTelefone.DataSource  := DataModule.DataModule.dsConexaoPadrao;
end;

procedure TfrmProcurarTelefone.btnBtnSairClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

procedure TfrmProcurarTelefone.btnConfirmarClick(Sender: TObject);
begin
  FIdRecno     := dbgrdFBProcurarTelefone.DataSource.DataSet.RecNo;
  FId_Telefone := dbgrdFBProcurarTelefone.DataSource.DataSet.FieldByName('ID_TELEFONE').AsInteger;
  FId_Cliente  := dbgrdFBProcurarTelefone.DataSource.DataSet.FieldByName('ID_CLIENTE').AsInteger;
  FNome        := dbgrdFBProcurarTelefone.DataSource.DataSet.FieldByName('NOME').AsString;
  ModalResult  := mrOk;
end;

procedure TfrmProcurarTelefone.btnLocalizarClick(Sender: TObject);
var
   Found: Boolean;
begin
  Found := False;
  ValidarChavePesquisa;
  case rgTipoPesquisa.ItemIndex of
    0: Found := DataModule.DataModule.qryConexaoPadrao.Locate('NOME'       , edtPesquisar.Text, [loPartialKey]);
    1: Found := DataModule.DataModule.qryConexaoPadrao.Locate('ID_CLIENTE' , edtPesquisar.Text, [loPartialKey]);
  end;
  edtStatus.Enabled := True;
  if Found then
    edtStatus.Text := 'Found'
  else
    edtStatus.Text := 'Not Found';
  edtStatus.Enabled := False;
  dbgrdFBProcurarTelefone.Columns.Grid.SetFocus;
end;

procedure TfrmProcurarTelefone.dbgrdFBProcurarTelefoneDblClick(Sender: TObject);
begin
  btnConfirmar.Click;
end;

procedure TfrmProcurarTelefone.edtPesquisarKeyPress(Sender: TObject;  var Key: Char);
begin
  if Key = #13 then
  begin
    btnLocalizar.Click;
  end;
end;

function TfrmProcurarTelefone.ValidarChavePesquisa: Boolean;
var
    sChavePesquisa : string;
begin
  Result := True;
  sChavePesquisa := Trim(edtPesquisar.Text);
  case rgTipoPesquisa.ItemIndex of
    0: begin
         if (IsNumber(sChavePesquisa)) then
         begin
           rgTipoPesquisa.ItemIndex := 1;
           edtPesquisar.Text := sChavePesquisa;
           edtPesquisar.Repaint;
           edtPesquisar.Refresh;
         end;
       end;
    1: Begin
         if (IsLetter(sChavePesquisa)) then
         begin
           rgTipoPesquisa.ItemIndex := 0;
           edtPesquisar.Text := sChavePesquisa;
           edtPesquisar.Repaint;
           edtPesquisar.Refresh;
         end;
       end;
  else ;
     Result := False;
  end;
end;

procedure TfrmProcurarTelefone.rgTipoPesquisaClick(Sender: TObject);
begin
  edtPesquisar.Text       := '';
  edtPesquisar.CharCase   := ecUpperCase;
  edtPesquisar.Enabled    := True;
  edtPesquisar.SetFocus;
  btnLocalizar.Caption    := '';
  btnLocalizar.Enabled    := True;
end;

procedure TfrmProcurarTelefone.SetIdRecno(const Value: Integer);
begin
  FIdRecno := Value;
end;

procedure TfrmProcurarTelefone.SetId_Cliente(const Value: Integer);
begin
  FId_Cliente := Value;
end;

procedure TfrmProcurarTelefone.SetId_Telefone(const Value: Integer);
begin
  FId_Telefone := Value;
end;

procedure TfrmProcurarTelefone.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TfrmProcurarTelefone.dbgrdFBProcurarTelefoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btnConfirmar.Click;
end;

end.
