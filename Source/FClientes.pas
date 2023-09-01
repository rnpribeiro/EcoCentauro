unit FClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  uCtrlClientes, uCtrlEmpresas, eInterface.Model.Interfaces,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TFrmClientes = class(TForm)
    pnlOperacaoPai       : TPanel;
    btnIncluir           : TSpeedButton;
    btnAlterar           : TSpeedButton;
    btnExcluir           : TSpeedButton;
    btnProcurar          : TSpeedButton;
    btnConsultar         : TSpeedButton;

    btnEmpresa           : TButton;

    btnAjuda             : TBitBtn;
    btnSair              : TBitBtn;
    btnCancelar          : TBitBtn;
    btnConfirmar         : TBitBtn;

    pnlClientes          : TPanel;
    pnlSairPai           : TPanel;
    pnlClientesPrincipal : TPanel;

    rgTipoPessoa         : TRadioGroup;
    cbbUF                : TComboBox;

    lblId_Cliente        : TLabel;
    lblNome              : TLabel;
    lblDocumento         : TLabel;
    lblRG                : TLabel;
    lblUF                : TLabel;
    lblEmpresa           : TLabel;
    lblDataNascimento    : TLabel;
    lblDataCadastro      : TLabel;
    lblTelefones         : TLabel;

    edtId_Cliente        : TEdit;
    edtNome              : TEdit;
    edtDocumento         : TEdit;
    edtRG                : TEdit;
    edtId_Empresa        : TEdit;
    edtEmpresa           : TEdit;
    edtDataNascimento    : TEdit;
    edtDataCadastro      : TEdit;
    edtTelefones         : TEdit;

    procedure rgTipoPessoaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEmpresaClick(Sender: TObject);
    procedure edtDataNascimentoChange(Sender: TObject);
    procedure edtDataNascimentoKeyPress(Sender: TObject; var Key: Char);
    procedure edtDataCadastroChange(Sender: TObject);
    procedure edtDataCadastroKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnProcurarClick(Sender: TObject);
    procedure edtDocumentoExit(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure pnlClientesEnter(Sender: TObject);
    procedure cbbUFChange(Sender: TObject);
    procedure edtNomeExit(Sender: TObject);
    procedure edtRGExit(Sender: TObject);
    procedure edtDataNascimentoExit(Sender: TObject);
    procedure edtTelefonesExit(Sender: TObject);
    procedure cbbUFExit(Sender: TObject);

  private
    { Private declarations }

    CtrlClientes : TCtrlClientes;
    bAction      : Boolean;
    Processo     : Integer;
    FPessoa      : iPessoaFisica;

    procedure HabilitarBotoesTopo(bEncontrou: Boolean);
    procedure HabilitarBotoesRodaPe(Enabled: Boolean);
    procedure ComponentsVisibe(const Visible: Boolean);

  public
    { Public declarations }
  end;

const
     MENSAGEMDATAINVALIDA = 'Data Inválida!';
     MENSAGEMIDADE        = 'Não é permitido cadastrar cliente (Pessoa Física) ' + #13 + #10 + 'menor de idade no estado do Paraná ou São Paulo';
     MENSAGEMRG           = 'Não é permitido cadastrar cliente (Pessoa Física) ' + #13 + #10 + 'sem o RG no Distrito Federal';


var
  FrmClientes: TFrmClientes;

implementation

uses
  eInterface.Controller.Pessoa, uFuncoes, fProcurarEmpresa,
  FProcurarCliente;

{$R *.dfm}

procedure TFrmClientes.FormCreate(Sender: TObject);
begin
  CtrlClientes                := TCtrlClientes.Create;
  bAction                     := False;
  Processo                    := 0;
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TFrmClientes.FormShow(Sender: TObject);
begin
  pnlClientesPrincipal.BringToFront;
  HabilitarBotoesTopo(bAction);
  HabilitarBotoesRodaPe(False);
  TUFList.UFToList(cbbUF.Items);
  pnlClientes.Enabled := ((Processo = 1) or (Processo = 2));
  if pnlClientes.Enabled then
  begin
    pnlClientes.SetFocus;
    rgTipoPessoa.SetFocus;
  end;
end;

procedure TFrmClientes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(CtrlClientes);
end;

procedure TFrmClientes.HabilitarBotoesRodaPe(Enabled: Boolean);
begin
  btnConfirmar.Enabled := Enabled;
  btnCancelar.Enabled  := Enabled;
end;

procedure TFrmClientes.HabilitarBotoesTopo(bEncontrou: Boolean);
var
   bTableIsEmpty : Boolean;
begin
  bTableIsEmpty        := CtrlClientes.TableIsEmpty('CLIENTES');
  btnIncluir.Enabled   := (not bEncontrou);
  btnAlterar.Enabled   := (not bTableIsEmpty);
  btnConsultar.Enabled := (not bTableIsEmpty);
  btnExcluir.Enabled   := (not bTableIsEmpty);
  btnProcurar.Enabled  := (not bTableIsEmpty);
end;

procedure TFrmClientes.pnlClientesEnter(Sender: TObject);
begin
  CtrlClientes.IniciarProperty(bAction);
  ComponentsVisibe(True);
  edtId_Cliente.Enabled  := True;
  edtId_Cliente.Text     := TUtils.Iif<string>(CtrlClientes.Id_Cliente = 0, '********', IntToStr(CtrlClientes.Id_Cliente));
  edtId_Cliente.Enabled  := False;

  edtNome.Text           := CtrlClientes.Nome;
  edtId_Empresa.Text     := IntToStr(CtrlClientes.Id_Empresa);
  edtEmpresa.Text        := CtrlClientes.Empresa;
  edtTelefones.Text      := CtrlClientes.Telefones;
  edtDocumento.Text      := CtrlClientes.Documento;
  edtRG.Text             := CtrlClientes.RG;
  cbbUF.Text             := CtrlClientes.UF;
  edtDataNascimento.Text := CtrlClientes.DataNascimento;
  edtDataCadastro.Text   := CtrlClientes.DataCadastro;
  if CtrlClientes.TipoPessoa <> '' then
    rgTipoPessoa.ItemIndex := TUtils.Iif<integer>(CtrlClientes.TipoPessoa = 'F', 0, 1);
end;

procedure TFrmClientes.btnProcurarClick(Sender: TObject);
var
  iId_Cliente  : Integer;
begin
  try
    Application.CreateForm(TfrmProcurarCliente, frmProcurarCliente);
    frmProcurarCliente.Sql.Text := CtrlClientes.MontaSqlProcurarCliente(-9);
    frmProcurarCliente.rgTipoPesquisa.Items.Clear;
    frmProcurarCliente.rgTipoPesquisa.Items.Add('Nome Cliente');
    frmProcurarCliente.rgTipoPesquisa.Items.Add(lblDocumento.Caption);
    frmProcurarCliente.rgTipoPesquisa.Items.Add('Data Nascimento');
    frmProcurarCliente.dbgrdFBProcurarCliente.Columns.Items[1].Title.Caption := 'Cliente';
    frmProcurarCliente.dbgrdFBProcurarCliente.Columns.Items[1].Width := 400;
    if frmProcurarCliente.ShowModal = mrOk then
    begin
      iId_Cliente := frmProcurarCliente.IdRetorno;
      CtrlClientes.DataModule.qryCliente.Close;
      CtrlClientes.DataModule.qryCliente.SQL.Clear;
      CtrlClientes.DataModule.qryCliente.SQL.Text := CtrlClientes.MontaSqlCliente(iId_Cliente);
      CtrlClientes.DataModule.qryCliente.Open;

      bAction := (not CtrlClientes.DataModule.qryCliente.Eof);

      CtrlClientes.IniciarProperty(bAction);
      HabilitarBotoesTopo(bAction);
      HabilitarBotoesRodaPe(bAction);
      pnlClientesPrincipal.SendToBack;
      pnlClientes.Enabled    := True;
      pnlClientes.SetFocus;
      pnlClientes.Enabled    := False;
    end
    else
    begin
      btnCancelar.Click;
    end;
  finally
  end;
end;

procedure TFrmClientes.btnEmpresaClick(Sender: TObject);
var
  iId_Empresa: Integer;
  CtrlEmpresas : TCtrlEmpresas;
begin
  CtrlEmpresas := TCtrlEmpresas.Create;
  try
    Application.CreateForm(TfrmProcurarEmpresa, frmProcurarEmpresa);
    frmProcurarEmpresa.Sql.Text := CtrlEmpresas.MontaSqlProcurarEmpresa(-9);
    frmProcurarEmpresa.rgTipoPesquisa.Items.Clear;
    frmProcurarEmpresa.rgTipoPesquisa.Items.Add('Código');
    frmProcurarEmpresa.rgTipoPesquisa.Items.Add('Empresa');
    frmProcurarEmpresa.dbgrdFBProcurarEmpresa.Columns.Items[1].Title.Caption := 'Empresa';
    frmProcurarEmpresa.dbgrdFBProcurarEmpresa.Columns.Items[1].Width := 400;
    if frmProcurarEmpresa.ShowModal = mrOk then
    begin
      iId_Empresa             := frmProcurarEmpresa.IdRetorno;
      CtrlClientes.Id_Empresa := iId_Empresa;
      edtId_Empresa.Enabled   := True;
      edtId_Empresa.Text      := IntToStr(iId_Empresa);
      edtId_Empresa.Enabled   := False;
      edtEmpresa.Enabled      := True;
      edtEmpresa.Text         := frmProcurarEmpresa.Nome;
      edtEmpresa.Enabled      := False;
      CtrlClientes.Empresa    := edtEmpresa.Text;
    end;
  finally
    FreeAndNil(CtrlEmpresas);
  end;

end;

procedure TFrmClientes.btnIncluirClick(Sender: TObject);
begin
  Processo                  := 1;
  pnlClientesPrincipal.SendToBack;
  pnlClientes.Enabled       := True;
  pnlOperacaoPai.Enabled    := False;
  pnlClientes.SetFocus;
  btnCancelar.Enabled       := True;
  edtDataCadastro.Text      := FormatDateTime('DD/MM/YYYY HH:MM:SS',Now);
  CtrlClientes.DataCadastro := StringReplace(edtDataCadastro.Text,'/','.',[rfReplaceAll]);
  edtDataCadastro.Enabled   := False;
  rgTipoPessoa.SetFocus;
end;

procedure TFrmClientes.btnAlterarClick(Sender: TObject);
begin
  Processo               := 2;
  btnProcurar.Click;
  pnlOperacaoPai.Enabled := False;
  pnlClientes.Enabled    := True;
  pnlClientes.SetFocus;
  btnCancelar.Enabled    := True;
  edtNome.SetFocus;
end;

procedure TFrmClientes.btnConsultarClick(Sender: TObject);
begin
  Processo               := 3;
  btnProcurar.Click;
  pnlOperacaoPai.Enabled := pnlClientes.Enabled;
  pnlClientes.Enabled    := True;
  pnlClientes.SetFocus;
  btnCancelar.Enabled    := True;
  pnlClientes.Enabled    := False;
end;

procedure TFrmClientes.btnExcluirClick(Sender: TObject);
begin
  Processo               := 4;
  btnProcurar.Click;
  pnlOperacaoPai.Enabled := False;
  pnlClientes.Enabled    := True;
  pnlClientes.SetFocus;
  btnCancelar.Enabled    := True;
  pnlClientes.Enabled    := False;
  btnConfirmar.Click;
end;

procedure TFrmClientes.btnConfirmarClick(Sender: TObject);
begin
  try
    if CtrlClientes.ValidarDados then
      CtrlClientes.Processar(Processo);
  finally
    btnCancelar.Click;
  end;
end;

procedure TFrmClientes.btnCancelarClick(Sender: TObject);
begin
  Processo               := 0;
  pnlClientesPrincipal.BringToFront;
  bAction                := False;
  rgTipoPessoa.ItemIndex := -1;
  pnlOperacaoPai.Enabled := True;
  pnlClientes.Enabled    := True;
  pnlClientes.SetFocus;
  pnlClientes.Enabled    := False;
  HabilitarBotoesTopo(bAction);
  HabilitarBotoesRodaPe(bAction);
end;

procedure TFrmClientes.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmClientes.cbbUFChange(Sender: TObject);
begin
 CtrlClientes.UF := cbbUF.Text;
end;

procedure TFrmClientes.cbbUFExit(Sender: TObject);
begin
  if cbbUF.Text = '' then
  begin
    ShowMessage('Necessário informar a UF');
    cbbUF.SetFocus;
  end;
end;

procedure TFrmClientes.edtDataCadastroChange(Sender: TObject);
begin
  if Length(edtDataCadastro.Text) = 2 then
    edtDataCadastro.Text := edtDataCadastro.Text + '/';

  if Length(edtDataCadastro.Text) = 5 then
    edtDataCadastro.Text := edtDataCadastro.Text + '/';

  edtDataCadastro.SelStart := Length(edtDataCadastro.Text);
end;

procedure TFrmClientes.edtDataCadastroKeyPress(Sender: TObject; var Key: Char);
begin
  TFuncoes.KeyDate(Key);
end;

procedure TFrmClientes.edtDataNascimentoChange(Sender: TObject);
begin
  try
    if Length(edtDataNascimento.Text) < 10 then
    begin
      if Length(edtDataNascimento.Text) = 2 then
        edtDataNascimento.Text := edtDataNascimento.Text + '/';

      if Length(edtDataNascimento.Text) = 5 then
        edtDataNascimento.Text := edtDataNascimento.Text + '/';

      edtDataNascimento.SelStart := Length(edtDataNascimento.Text);
    end;
  finally
    if Length(edtDataNascimento.Text) >= 10 then
    begin
      edtDataNascimento.Text := StringReplace(edtDataNascimento.Text,'.','/',[rfReplaceAll]);
      CtrlClientes.DataNascimento := edtDataNascimento.Text;
    end;
  end;
end;

procedure TFrmClientes.edtDataNascimentoExit(Sender: TObject);
begin
  if (CtrlClientes.TipoPessoa = 'F') then
  begin
    CtrlClientes.DataNascimento := edtDataNascimento.Text;
    if (not CtrlClientes.ValidarDataNascimento) then
    begin
      ShowMessage(TUtils.Iif<string>(CtrlClientes.DataNascimento <> '', MENSAGEMIDADE, MENSAGEMDATAINVALIDA));
      edtDataNascimento.SetFocus;
    end
    else
    begin
      CtrlClientes.DataNascimento := StringReplace(edtDataNascimento.Text, '/','.',[rfReplaceAll]);
      btnConfirmar.Enabled        := (CtrlClientes.DataNascimento <> '');
    end;
  end
  else
  begin
    edtDataNascimento.Text      := '';
    CtrlClientes.DataNascimento := edtDataNascimento.Text;
  end;
end;

procedure TFrmClientes.edtDataNascimentoKeyPress(Sender: TObject; var Key: Char);
begin
  TFuncoes.KeyDate(Key);
end;

procedure TFrmClientes.edtDocumentoExit(Sender: TObject);
var
   bValidou : Boolean;
begin
  try
    if (Trim(edtDocumento.Text) <> '') then
    begin
      bValidou := TUtils.Iif<Boolean>(CtrlClientes.TipoPessoa = 'F' , TFuncoes.ValidarCPF(edtDocumento.Text), TFuncoes.ValidarCNPJ(edtDocumento.Text));
      if not bValidou then
      begin
        ShowMessage(lblDocumento.Caption + ' Inválido!');
        edtDocumento.SetFocus;
      end
      else
      begin
        edtDocumento.Text      := TFuncoes.RetirarMascara(edtDocumento.Text);
        edtDocumento.Text      := TUtils.Iif<string>(CtrlClientes.TipoPessoa = 'F' , TFuncoes.MascaraCPF(edtDocumento.Text), TFuncoes.MascaraCNPJ(edtDocumento.Text));
        CtrlClientes.Documento := edtDocumento.Text;
      end;
    end
    else
    begin
      if edtDocumento.Text = '' then
      begin
        ShowMessage('Necessário informar o ' + lblDocumento.Caption);
        edtDocumento.SetFocus;
      end;
    end;
  finally
  end;
end;

procedure TFrmClientes.edtNomeExit(Sender: TObject);
begin
  CtrlClientes.Nome := edtNome.Text;
  if (CtrlClientes.Nome = '') and ((Processo = 1) or (Processo = 2)) then
  begin
    ShowMessage('Necessário informar o nome do cliente');
    edtNome.SetFocus;
  end;
end;

procedure TFrmClientes.edtRGExit(Sender: TObject);
begin
  CtrlClientes.RG := edtRG.Text;
  if not CtrlClientes.ValidarRG then
  begin
    ShowMessage(MENSAGEMRG);
    edtRG.SetFocus;
  end;
end;

procedure TFrmClientes.edtTelefonesExit(Sender: TObject);
begin
  CtrlClientes.Telefones := edtTelefones.Text;
end;

procedure TFrmClientes.rgTipoPessoaClick(Sender: TObject);
begin
  CtrlClientes.TipoPessoa   := TUtils.Iif<string>(rgTipoPessoa.ItemIndex = 0, 'F', 'J');
  ComponentsVisibe(True);
end;

procedure TFrmClientes.ComponentsVisibe(const Visible: Boolean);
begin
  FPessoa                   := TControllerPessoa.New.PessoaFisica;

  cbbUF.Visible             := Visible;

  lblId_Cliente.Visible     := Visible;
  lblNome.Visible           := Visible;
  lblDocumento.Visible      := Visible;
  lblRG.Visible             := Visible;
  lblUF.Visible             := Visible;
  lblEmpresa.Visible        := Visible;
  lblDataNascimento.Visible := Visible;
  lblDataCadastro.Visible   := Visible;
  lblTelefones.Visible      := Visible;

  edtId_Cliente.Visible     := Visible;
  edtNome.Visible           := Visible;
  edtDocumento.Visible      := Visible;
  edtRG.Visible             := Visible;
  edtId_Empresa.Visible     := Visible;
  btnEmpresa.Visible        := Visible;
  edtEmpresa.Visible        := Visible;
  edtDataNascimento.Visible := Visible;
  edtDataCadastro.Visible   := Visible;
  edtTelefones.Visible      := Visible;

  lblDocumento.Caption      := Trim(TControllerPessoa.new.TipoDocumento(rgTipoPessoa.ItemIndex));
  edtDocumento.MaxLength    := TControllerPessoa.new.TamanhoDocumento(rgTipoPessoa.ItemIndex);
  edtDataNascimento.Text    := TUtils.Iif<string>(rgTipoPessoa.ItemIndex = 0, edtDataNascimento.Text, '');
  lblDataNascimento.visible := TUtils.Iif<Boolean>(rgTipoPessoa.ItemIndex = 0, True, False);
  edtDataNascimento.visible := TUtils.Iif<Boolean>(rgTipoPessoa.ItemIndex = 0, True, False);
end;

end.
