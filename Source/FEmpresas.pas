unit FEmpresas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  uCtrlEmpresas, eInterface.Model.Interfaces, eInterface.Model.PessoaJuridica,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TFrmEmpresas = class(TForm)
    pnlOperacaoPai  : TPanel;
    pnlEmpresas     : TPanel;
    pnlSairPai      : TPanel;
    btnIncluir      : TSpeedButton;
    btnAlterar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnProcurar: TSpeedButton;
    btnConsultar    : TSpeedButton;
    lblNomeFantasia : TLabel;
    lblSobreNome    : TLabel;
    lblDocumento    : TLabel;
    edtNomeFantasia : TEdit;
    edtCNPJ         : TEdit;
    cbbUF           : TComboBox;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    btnAjuda: TBitBtn;
    lblId_Empresa: TLabel;
    edtId_Empresa: TEdit;
    pnlEmpresaPrincipal: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure pnlEmpresasEnter(Sender: TObject);
    procedure btnProcurarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtNomeFantasiaExit(Sender: TObject);
    procedure cbbUFChange(Sender: TObject);
    procedure cbbUFExit(Sender: TObject);
  private
    { Private declarations }
    CtrlEmpresas : TCtrlEmpresas;
    bAction      : Boolean;
    Processo     : Integer;
    FPessoa      : iPessoaJuridica;

    procedure HabilitarBotoesTopo(bEncontrou: Boolean);
    procedure HabilitarBotoesRodaPe(Enabled: Boolean);

  public
    { Public declarations }
  end;

var
  FrmEmpresas: TFrmEmpresas;

implementation

uses
   eInterface.Controller.Pessoa, eInterface.Controller.Interfaces, uFuncoes, fProcurarEmpresa ;

{$R *.dfm}

procedure TFrmEmpresas.FormCreate(Sender: TObject);
begin
  CtrlEmpresas                := TCtrlEmpresas.Create;
  FPessoa                     := TControllerPessoa.New.PessoaJuridica;
  bAction                     := False;
  Processo                    := 0;
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TFrmEmpresas.FormShow(Sender: TObject);
begin
  pnlEmpresaPrincipal.BringToFront;
  HabilitarBotoesTopo(bAction);
  HabilitarBotoesRodaPe(False);
  TUFList.UFToList(cbbUF.Items);
  pnlEmpresas.Enabled := ((Processo = 1) or (Processo = 2));
  if pnlEmpresas.Enabled then
  begin
    pnlEmpresas.SetFocus;
    edtNomeFantasia.SetFocus;
  end;
end;

procedure TFrmEmpresas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(CtrlEmpresas);
end;

procedure TFrmEmpresas.HabilitarBotoesTopo(bEncontrou: Boolean);
var
   bTableIsEmpty : Boolean;
begin
  bTableIsEmpty        := CtrlEmpresas.TableIsEmpty('EMPRESAS');
  case Processo of
           0: begin
                btnIncluir.Enabled   := (not bEncontrou);
                btnAlterar.Enabled   := (not bTableIsEmpty);
                btnConsultar.Enabled := (not bTableIsEmpty);
                btnExcluir.Enabled   := (not bTableIsEmpty);
                btnProcurar.Enabled  := (not bTableIsEmpty);
              end;
     1,2,3,4: begin
                btnIncluir.Enabled   := (not bEncontrou)    and (Processo = 1);
                btnAlterar.Enabled   := (not bTableIsEmpty) and (Processo = 2);
                btnConsultar.Enabled := (not bTableIsEmpty) and (Processo = 3);
                btnExcluir.Enabled   := (not bTableIsEmpty) and (Processo = 4);
                btnProcurar.Enabled  := False;
              end;
  else
    btnIncluir.Enabled   := False;
    btnAlterar.Enabled   := False;
    btnConsultar.Enabled := False;
    btnExcluir.Enabled   := False;
    btnProcurar.Enabled  := (not bTableIsEmpty);
  end;
end;

procedure TFrmEmpresas.HabilitarBotoesRodaPe(Enabled: Boolean);
begin
  btnConfirmar.Enabled := Enabled;
  btnCancelar.Enabled  := Enabled;
end;


procedure TFrmEmpresas.pnlEmpresasEnter(Sender: TObject);
begin
  CtrlEmpresas.IniciarProperty(bAction);

  edtId_Empresa.Enabled := True;
  edtId_Empresa.Text    := TUtils.Iif<string>(CtrlEmpresas.Id_Empresa = 0, '********', IntToStr(CtrlEmpresas.Id_Empresa));
  edtId_Empresa.Enabled := False;

  edtNomeFantasia.Text  := CtrlEmpresas.NomeFantasia;
  edtCNPJ.Text          := CtrlEmpresas.CNPJ;
  cbbUF.Text            := CtrlEmpresas.UF;
end;

procedure TFrmEmpresas.btnProcurarClick(Sender: TObject);
var
  iId_Empresa: Integer;
begin
  try
    Processo := TUtils.Iif<Integer>(Processo = 0, -1, Processo);
    Application.CreateForm(TfrmProcurarEmpresa, frmProcurarEmpresa);
    frmProcurarEmpresa.Sql.Text := CtrlEmpresas.MontaSqlProcurarEmpresa(-9);
    frmProcurarEmpresa.rgTipoPesquisa.Items.Clear;
    frmProcurarEmpresa.rgTipoPesquisa.Items.Add('Empresa');
    frmProcurarEmpresa.rgTipoPesquisa.Items.Add('Código');
    frmProcurarEmpresa.dbgrdFBProcurarEmpresa.Columns.Items[1].Title.Caption := 'Empresa';
    frmProcurarEmpresa.dbgrdFBProcurarEmpresa.Columns.Items[1].Width := 400;
    if frmProcurarEmpresa.ShowModal = mrOk then
    begin
      iId_Empresa := frmProcurarEmpresa.IdRetorno;
      CtrlEmpresas.DataModule.qryEmpresa.Close;
      CtrlEmpresas.DataModule.qryEmpresa.SQL.Clear;
      CtrlEmpresas.DataModule.qryEmpresa.SQL.Text := CtrlEmpresas.MontaSqlEmpresa(iId_Empresa);
      CtrlEmpresas.DataModule.qryEmpresa.Open;

      bAction := (not CtrlEmpresas.DataModule.qryEmpresa.Eof);

      CtrlEmpresas.IniciarProperty(bAction);
      HabilitarBotoesTopo(bAction);
      HabilitarBotoesRodaPe(bAction);
      pnlEmpresaPrincipal.SendToBack;
      pnlEmpresas.Enabled    := True;
      pnlEmpresas.SetFocus;
      pnlEmpresas.Enabled    := False;
    end
    else
    begin
      btnCancelar.Click;
    end;
  finally
  end;
end;

procedure TFrmEmpresas.btnIncluirClick(Sender: TObject);
begin
  if Processo = 0 then
  begin
    Processo               := 1;
    pnlEmpresaPrincipal.SendToBack;
    pnlEmpresas.Enabled    := True;
    pnlOperacaoPai.Enabled := False;
    pnlEmpresas.SetFocus;
    btnCancelar.Enabled    := True;
    HabilitarBotoesTopo(False);
    edtNomeFantasia.SetFocus;
  end;
end;

procedure TFrmEmpresas.btnAlterarClick(Sender: TObject);
begin
  if Processo = 0 then
  begin
    Processo               := 2;
    btnProcurar.Click;
    pnlOperacaoPai.Enabled := False;
    pnlEmpresas.Enabled    := True;
    pnlEmpresas.SetFocus;
    btnCancelar.Enabled    := True;
    edtNomeFantasia.SetFocus;
  end;
end;

procedure TFrmEmpresas.btnConsultarClick(Sender: TObject);
begin
  if Processo = 0 then
  begin
    Processo               := 3;
    btnProcurar.Click;
    pnlOperacaoPai.Enabled := pnlEmpresas.Enabled;
    pnlEmpresas.Enabled    := True;
    pnlEmpresas.SetFocus;
    btnCancelar.Enabled    := True;
    pnlEmpresas.Enabled    := False;
  end;
end;

procedure TFrmEmpresas.btnExcluirClick(Sender: TObject);
begin
  if Processo = 0 then
  begin
    Processo               := 4;
    btnProcurar.Click;
    pnlOperacaoPai.Enabled := False;
    pnlEmpresas.Enabled    := True;
    pnlEmpresas.SetFocus;
    btnCancelar.Enabled    := True;
    pnlEmpresas.Enabled    := False;
    btnConfirmar.Click;
  end;
end;

procedure TFrmEmpresas.btnConfirmarClick(Sender: TObject);
begin
  try
    CtrlEmpresas.Processar(Processo);
  finally
    btnCancelar.Click;
  end;
end;

procedure TFrmEmpresas.btnCancelarClick(Sender: TObject);
begin
  Processo               := 0;
  pnlEmpresaPrincipal.BringToFront;
  bAction                := False;
  pnlOperacaoPai.Enabled := True;
  pnlEmpresas.Enabled    := True;
  pnlEmpresas.SetFocus;
  pnlEmpresas.Enabled    := False;
  HabilitarBotoesTopo(bAction);
  HabilitarBotoesRodaPe(bAction);
end;

procedure TFrmEmpresas.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEmpresas.edtNomeFantasiaExit(Sender: TObject);
var
    FocusCancelar : Boolean;
    FocusSair     : Boolean;
begin
  FocusCancelar := (not btnCancelar.Focused);
  FocusSair     := (not btnSair.Focused);

  CtrlEmpresas.NomeFantasia := edtNomeFantasia.Text;
  if (CtrlEmpresas.NomeFantasia = '') and ((FocusCancelar) and (FocusSair)) then
  begin
    ShowMessage('Necessário informar o nome fantasia da Empresa');
    edtNomeFantasia.SetFocus;
  end;

end;

procedure TFrmEmpresas.edtCNPJExit(Sender: TObject);
var
    FocusCancelar : Boolean;
    FocusSair     : Boolean;
begin
  FocusCancelar := (not btnCancelar.Focused);
  FocusSair     := (not btnSair.Focused);
  if (Trim(edtCNPJ.Text) <> '') then
  begin
    if not TFuncoes.ValidarCNPJ(edtCNPJ.Text) then
    begin
      ShowMessage('CNPJ Inválido!');
      edtCNPJ.SetFocus;
    end
    else
    begin
      edtCNPJ.Text      := TFuncoes.RetirarMascara(edtCNPJ.Text);
      edtCNPJ.Text      := TFuncoes.MascaraCNPJ(edtCNPJ.Text);
      CtrlEmpresas.CNPJ := edtCNPJ.Text;
    end;
  end
  else
  begin
    if (edtCNPJ.Text = '') and ((FocusCancelar) and (FocusSair)) then
    begin
      ShowMessage('Necessário informar o CNPJ');
      edtCNPJ.SetFocus;
    end;
  end;
end;

procedure TFrmEmpresas.cbbUFChange(Sender: TObject);
var
    FocusCancelar : Boolean;
    FocusSair     : Boolean;
begin
  FocusCancelar := (not btnCancelar.Focused);
  FocusSair     := (not btnSair.Focused);
  try
    if (cbbUF.Text = '') and ((FocusCancelar) and (FocusSair)) then
    begin
      ShowMessage('Necessário informar a UF');
      cbbUF.SetFocus;
    end
    else
    begin
      CtrlEmpresas.UF      := cbbUF.Text;
    end;
  finally
    btnConfirmar.Enabled := (cbbUF.Text <> '');
  end;
end;

procedure TFrmEmpresas.cbbUFExit(Sender: TObject);
var
    FocusCancelar : Boolean;
    FocusSair     : Boolean;
begin
  FocusCancelar := (not btnCancelar.Focused);
  FocusSair     := (not btnSair.Focused);
  try
    if (cbbUF.Text = '') and ((FocusCancelar) and (FocusSair)) then
    begin
      ShowMessage('Necessário informar a UF');
      cbbUF.SetFocus;
    end
    else
    begin
      CtrlEmpresas.UF      := cbbUF.Text;
    end;
  finally
    btnConfirmar.Enabled := (cbbUF.Text <> '');
  end;
end;

end.
