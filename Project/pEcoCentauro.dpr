program pEcoCentauro;

uses
  Vcl.Forms,
  uFuncoes in '..\Unit\uFuncoes.pas',
  FPrincipal in '..\Source\FPrincipal.pas' {FrmPrincipal},
  FEmpresas in '..\Source\FEmpresas.pas' {Form1},
  FProcurarEmpresa in '..\Source\FProcurarEmpresa.pas' {frmProcurarEmpresa},
  FClientes in '..\Source\FClientes.pas' {Form1},
  FProcurarCliente in '..\Source\FProcurarCliente.pas' {frmProcurarCliente},
  uCtrlEmpresas in '..\Control\uCtrlEmpresas.pas',
  uCtrlClientes in '..\Control\uCtrlClientes.pas',
  eInterface.Controller.Pessoa in '..\Interface\eInterface.Controller.Pessoa.pas',
  eInterface.Controller.Interfaces in '..\Interface\eInterface.Controller.Interfaces.pas',
  eInterface.Model.Interfaces in '..\Interface\eInterface.Model.Interfaces.pas',
  eInterface.Model.Pessoa.Factory in '..\Interface\eInterface.Model.Pessoa.Factory.pas',
  eInterface.Model.PessoaFisica in '..\Interface\eInterface.Model.PessoaFisica.pas',
  eInterface.Model.PessoaJuridica in '..\Interface\eInterface.Model.PessoaJuridica.pas' {$R *.res},
  dDMConection in '..\Unit\dDMConection.pas' {DMConection: TDataModule},
  ddmCliente in '..\Unit\ddmCliente.pas' {dmCliente: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDMConection, DMConection);
  Application.CreateForm(TdmCliente, dmCliente);
  Application.Run;
end.
