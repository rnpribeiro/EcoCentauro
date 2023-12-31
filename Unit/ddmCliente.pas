unit ddmCliente;

interface

uses Midas, SysUtils, Classes, DB, DBClient, FMTBcd, Provider, SqlExpr, dDMConection, Messages, Dialogs,
     FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
     FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
     FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
     FireDAC.Phys.IBBase, FireDAC.Comp.Client,
     FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
     FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC, FireDAC.Phys.ODBCBase,
     FireDAC.Comp.DataSet, FireDAC.Stan.Intf;


const
  b_AceitaVazio : Boolean = True;
  k_vazio       : string  = '';
  k_Zero        : string  = '0';
  k_Ponto       : string  = '.';
  k_virgula     : string  = ',';

type
  TdmCliente = class(TDataModule)
    qryConexaoPadrao: TFDQuery;
    qryAuxiliar: TFDQuery;
    qryEstado: TFDQuery;
    qryEmpresa: TFDQuery;
    qryCliente: TFDQuery;
    dsConexaoPadrao: TDataSource;
    dsEstado: TDataSource;
    dsAuxiliar: TDataSource;
    dsEmpresa: TDataSource;
    dsCliente: TDataSource;

    procedure DataModuleCreate(Sender: TObject);
    procedure dspAlunoNotaAfterUpdateRecord(Sender: TObject; SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind);

  private
    { Private declarations }
  public
    { Public declarations }
    DataModule : TDMConection;

    function FazerQuery(sSql: string): Boolean;
    procedure LockRows(qry: TFDQuery; wait: boolean);
  end;

var
  dmCliente: TdmCliente;

implementation

{$R *.dfm}

procedure TdmCliente.DataModuleCreate(Sender: TObject);
begin
  DataModule := TDMConection.Create(Self);
end;

procedure TdmCliente.dspAlunoNotaAfterUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind);
var
    sReadOnly: string;
begin
  if SourceDS.Fields[19].ReadOnly  then
     sReadOnly := 'Est� ReadOly'
  else
     sReadOnly := 'N�o Est� ReadOly';
  try

  except
    on E: Exception do
    begin
      MessageDlg(E.Message + ', ' + sReadOnly, mtInformation, [mbOk], 0);
    end;
  end;
end;

function TdmCliente.FazerQuery(sSql: string): Boolean;
begin
  try
    dmCliente.qryConexaoPadrao.Close;
    dmCliente.qryConexaoPadrao.Sql.Clear;
    dmCliente.qryConexaoPadrao.SQL.Text := sSql;
    dmCliente.qryConexaoPadrao.Open;
    Result := not dmCliente.qryConexaoPadrao.IsEmpty;
  except
    Result := False;
  end;
end;

procedure TdmCliente.LockRows(qry: TFDQuery; wait: boolean);
begin
  if dmCliente.DataModule.FDConexaoPadrao.InTransaction then
  begin
    if wait then
      qryConexaoPadrao.Sql.Add(' FOR UPDATE ')
    else
      qryConexaoPadrao.sql.Add(' FOR UPDATE NOWAIT ');
  end;
end;

end.
