unit fProcurarTipoTelefone;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, Db, DBClient, ddmCliente, uSistemaIB,
  DBCtrls, ImgList, DBGrids, System.ImageList;
type
  TfrmProcurarTipoTelefone = class(TForm)
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
    dbgrdFBProcurarTipoTelefone : TDBGrid;
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
    procedure dbgrdFBProcurarTipoTelefoneDblClick(Sender: TObject);
    procedure edtPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure rgTipoPesquisaClick(Sender: TObject);
    procedure dbgrdFBProcurarTipoTelefoneKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FIdRecno   : Integer;
    FId_Tipo   : Integer;
    FDescricao : string;

    procedure SetDataSource;
    procedure SetSql(const Value: TStringList);
    procedure SetId_Tipo(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetIdRecno(const Value: Integer);
    function ValidarChavePesquisa: Boolean;
  public
    { Public declarations }
    DataModule : TdmCliente;
    FSql       : TStringList;

    property Sql: TStringList read FSql write SetSql;
    property IdRecno   : Integer read FIdRecno   write SetIdRecno;
    property Id_Tipo   : Integer read FId_Tipo   write SetId_Tipo;
    property Descricao : string  read FDescricao write SetDescricao;
  end;

var
   frmProcurarTipoTelefone: TfrmProcurarTipoTelefone;

implementation

{$R *.DFM}

procedure TfrmProcurarTipoTelefone.FormCreate(Sender: TObject);
begin
  FSql := TStringList.Create;
  dmCliente := TdmCliente.Create(Self);
  SetDataSource;
end;

procedure TfrmProcurarTipoTelefone.FormShow(Sender: TObject);
begin
  rgTipoPesquisa.ItemIndex := 0;

  DataModule.DataModule.qryConexaoPadrao.Close;
  DataModule.DataModule.qryConexaoPadrao.SQL.Clear;
  DataModule.DataModule.qryConexaoPadrao.SQL.Text := FSql.Text;
  DataModule.DataModule.qryConexaoPadrao.Open;
  if DataModule.DataModule.qryConexaoPadrao.IsEmpty then
  begin
    ShowMessage('N�o Existe(m) registro(s) para selecionar!');
    ModalResult := mrCancel;
  end;
end;

procedure TfrmProcurarTipoTelefone.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DataModule.DataModule.qryConexaoPadrao.Close;
  FreeAndNil(FSql);
  FreeAndNil(DataModule);
end;

procedure TfrmProcurarTipoTelefone.SetId_Tipo(const Value: Integer);
begin
  FId_Tipo := Value;
end;

procedure TfrmProcurarTipoTelefone.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TfrmProcurarTipoTelefone.SetSql(const Value: TStringList);
begin
  FSql := Value;
end;

procedure TfrmProcurarTipoTelefone.SetDataSource;
begin
  dbgrdFBProcurarTipoTelefone.DataSource  := DataModule.DataModule.dsConexaoPadrao;
end;

procedure TfrmProcurarTipoTelefone.btnBtnSairClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

procedure TfrmProcurarTipoTelefone.btnConfirmarClick(Sender: TObject);
begin
  FIdRecno    := dbgrdFBProcurarTipoTelefone.DataSource.DataSet.RecNo;
  FId_Tipo    := dbgrdFBProcurarTipoTelefone.DataSource.DataSet.FieldByName('ID_TIPO').AsInteger;
  FDescricao  := dbgrdFBProcurarTipoTelefone.DataSource.DataSet.FieldByName('DESCRICAO').AsString;
  ModalResult := mrOk;
end;

procedure TfrmProcurarTipoTelefone.btnLocalizarClick(Sender: TObject);
var
   Found: Boolean;
begin
  Found := False;
  ValidarChavePesquisa;
  case rgTipoPesquisa.ItemIndex of
    0: Found := DataModule.DataModule.qryConexaoPadrao.Locate('DESCRICAO' , edtPesquisar.Text, [loPartialKey]);
    1: Found := DataModule.DataModule.qryConexaoPadrao.Locate('ID_TIPO'   , edtPesquisar.Text, [loPartialKey]);
  end;
  edtStatus.Enabled := True;
  if Found then
    edtStatus.Text := 'Found'
  else
    edtStatus.Text := 'Not Found';
  edtStatus.Enabled := False;
  dbgrdFBProcurarTipoTelefone.Columns.Grid.SetFocus;
end;

procedure TfrmProcurarTipoTelefone.dbgrdFBProcurarTipoTelefoneDblClick(Sender: TObject);
begin
  btnConfirmar.Click;
end;

procedure TfrmProcurarTipoTelefone.edtPesquisarKeyPress(Sender: TObject;  var Key: Char);
begin
  if Key = #13 then
  begin
    btnLocalizar.Click;
  end;
end;

function TfrmProcurarTipoTelefone.ValidarChavePesquisa: Boolean;
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

procedure TfrmProcurarTipoTelefone.rgTipoPesquisaClick(Sender: TObject);
begin
  edtPesquisar.Text       := '';
  edtPesquisar.CharCase   := ecUpperCase;
  edtPesquisar.Enabled    := True;
  edtPesquisar.SetFocus;
  btnLocalizar.Caption    := '';
  btnLocalizar.Enabled    := True;
end;

procedure TfrmProcurarTipoTelefone.SetIdRecno(const Value: Integer);
begin
  FIdRecno := Value;
end;

procedure TfrmProcurarTipoTelefone.dbgrdFBProcurarTipoTelefoneKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btnConfirmar.Click;
end;

end.
