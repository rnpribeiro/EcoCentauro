unit ddb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dDMConection, DB, DBClient,  SqlExpr, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  FireDAC.Phys.IBBase, FireDAC.Comp.Client;

type
  TdtmDB = class(TDMConection)
    procedure dDMConectionCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dtmDB: TdtmDB;

implementation

{$R *.dfm}

procedure TdtmDB.dDMConectionCreate(Sender: TObject);
begin
  inherited;

end;

end.
