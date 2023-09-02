unit FPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  dxGDIPlusClasses, Vcl.ComCtrls;

type
  TFrmPrincipal = class(TForm)
    pnlPrincipal: TPanel;
    pnlMenuPrincipal: TPanel;
    pnlTopoPrincipal: TPanel;
    pnlLimite1: TPanel;
    btnEmpresas: TButton;
    pnlLimite2: TPanel;
    pnlLimite3: TPanel;
    btnClientes: TButton;
    btnSair: TButton;
    imgFrmPrincipal: TImage;
    imgFrmPrinciipalTopo: TImage;
    imgFirebird: TImage;
    statPrincipal: TStatusBar;
    procedure btnEmpresasClick(Sender: TObject);
    procedure btnClientesClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation
uses FEmpresas, FClientes;

{$R *.dfm}

procedure TFrmPrincipal.btnEmpresasClick(Sender: TObject);
begin
  Application.CreateForm(TFrmEmpresas, FrmEmpresas);
  FrmEmpresas.ShowModal;
end;

procedure TFrmPrincipal.btnClientesClick(Sender: TObject);
begin
  Application.CreateForm(TFrmClientes, FrmClientes);
  FrmClientes.ShowModal;
end;

procedure TFrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

end.
