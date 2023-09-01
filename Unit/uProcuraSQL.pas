unit uProcuraSQL;

interface
Uses   Windows, Messages, SysUtils, Classes, Graphics, Controls,
       Forms, Dialogs, stdctrls, FIbprocurar, Db, SqlExpr, DBClient,
       FireDAC.Stan.Intf, FireDAC.Stan.Option,
       FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
       FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
       FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Datasnap.Provider,
       FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
       FireDAC.Comp.DataSet;

Type

    TItemColuna  = Class(TCollectionItem)
    Private
       FTamanho   : Integer;
       FNome      : String;
       FTipo      : TfieldType;
       FMascara   : String;
       FDescricao : String;
       procedure SetMascara(const Value: String);
       procedure SetNome(const Value: String);
       procedure SetTamanho(const Value: Integer);
       procedure SetTipo(const Value: TfieldType);
       procedure SetDescricao(const Value: String);
    Public
       function GetDisplayName: string; override;
    Published
       Property Nome      : String     read FNome      write SetNome;
       Property Tamanho   : Integer    read FTamanho   write SetTamanho;
       Property Tipo      : TfieldType read FTipo      write SetTipo;
       Property Mascara   : String     read FMascara   write SetMascara;
       property Descricao : String     read FDescricao write SetDescricao;
    End;

    TColuna = Class(TCollection)
    private
      FOwner : TPersistent;
    protected
      function GetOwner: TPersistent; override;
    public
      constructor Create(Owner: TPersistent); overload;
    end;

    TProcuraSQL = Class( TComponent )
    Private
       FCamposChave   : TStrings;
       FTabelas       : TStrings;
       FFiltro        : TStrings;
       FRetornouValor : Boolean;
       FTexto         : String;
       FValoresChave  : TStrings;
       FfrmIbprocurar : TfrmIbprocurar;
       FColunas       : TColuna;
       FDataBase      : TFDDataSet;
       procedure SetCamposChave(const Value: TStrings);
       procedure SetFiltro(const Value: TStrings);
       procedure SetTabelas(const Value: TStrings);
       procedure SetColunas(const Value: TColuna);
       Procedure MontaSQL;
       procedure SetDataBase(const Value: TFDDataSet);
    Published
       property Colunas      : TColuna     read FColunas     write SetColunas;
       property Tabelas      : TStrings    read FTabelas     write SetTabelas;
       property CamposChave  : TStrings    read FCamposChave write SetCamposChave;
       property Filtro       : TStrings    read FFiltro      write SetFiltro;
       property DataBase     : TFDDataSet  read FDataBase    write SetDataBase;
    Public
       property Texto         : String   read FTexto write FTexto;
       property ValoresChave  : TStrings read FValoresChave;
       property RetornouValor : Boolean  read FRetornouValor;
       //
       constructor Create( AOwner :TComponent ); override;
       destructor  Destroy; override;
       function    Executar : TModalResult;
    end;

implementation

{ TProcuraSQL }

constructor TProcuraSQL.Create(AOwner: TComponent);
begin
  inherited;
  FColunas       := TColuna.Create(Self);
  FTabelas       := TStringList.Create;
  FFiltro        := TStringList.Create;
  FCamposChave   := TStringList.Create;
  FValoresChave  := TStringList.Create;
  FTexto         := '';
  FRetornouValor := False;
  FfrmIbprocurar := nil;
end;

destructor TProcuraSQL.Destroy;
begin
  If FfrmIbprocurar <> nil Then
     FfrmIbprocurar.Free;
  FColunas.Free;
  FTabelas.Free;
  FFiltro.Free;
  FCamposChave.Free;
  FValoresChave.Free;
  inherited;
end;

function TProcuraSQL.Executar : TModalResult;
begin
    Self.MontaSQL;
    if ( FfrmIbprocurar  = nil) then
        FfrmIbprocurar    := TfrmIbprocurar.Create(Self);
    Result := FfrmIbprocurar.ShowModal;
    If Result <> mrOk Then
       FValoresChave.Clear;
    FRetornouValor := (FValoresChave.Count > 0) and (FValoresChave[0] <> '');
end;

procedure TProcuraSQL.SetCamposChave(const Value: TStrings);
begin
  FCamposChave.Assign(Value);
end;

procedure TProcuraSQL.SetColunas(const Value: TColuna);
begin
  FColunas.Assign(Value);
end;

procedure TProcuraSQL.SetFiltro(const Value: TStrings);
begin
  FFiltro.Assign(Value);
end;

procedure TProcuraSQL.SetTabelas(const Value: TStrings);
begin
  FTabelas.Assign(Value);
end;

Procedure TProcuraSQL.MontaSQL;
Var
  x : Integer;
Begin
     FTexto := '';
     //Montado os Campos Chave da Pesquisa
     FTexto := 'SELECT ';
     For x := 0 To FCamposChave.Count -1 Do
        FTexto := FTexto + AnsiUpperCase(FCamposChave.Strings[x]) +' AS '+ 'C'+IntToStr(x) + ', ';

     //Montado os Campos de busca da Pesquisa
     For x := 0 To FColunas.Count - 1 Do
        Begin
           If x <  FColunas.Count - 1 Then
              FTexto := FTexto + AnsiUpperCase(TItemColuna(FColunas.Items[x]).Nome)+', '
           Else
              FTexto := FTexto + AnsiUpperCase(TItemColuna(FColunas.Items[x]).Nome)+' ';
        End;

    //Montado o FROM
     FTexto := FTexto +'FROM ';
     For x := 0 To FTabelas.Count - 1 Do
        Begin
           If x <  FTabelas.Count -1 Then
              FTexto := FTexto + AnsiUpperCase(FTabelas.Strings[x])+', '
           Else
              FTexto := FTexto + AnsiUpperCase(FTabelas.Strings[x])+' ';
        End;

     //Fazendo a Clausula WHERE
     FTexto := FTexto +' WHERE ( 1=1) ';
     For x := 0 To FFiltro.Count -1 Do
       FTexto := FTexto + ' AND ('+ AnsiUpperCase(FFiltro.Strings[x]) +') ';
End;

procedure TProcuraSQL.SetDataBase(const Value: TFDDataSet);
begin
  FDataBase := Value;
end;

{ TItemColuna }
function TItemColuna.GetDisplayName: string;
begin
   If FNome = '' Then
      Result := 'Coluna'
   Else
      Result := FNome;
end;

procedure TItemColuna.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TItemColuna.SetMascara(const Value: String);
begin
  FMascara := Value;
end;

procedure TItemColuna.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TItemColuna.SetTamanho(const Value: Integer);
begin
  FTamanho := Value;
end;

procedure TItemColuna.SetTipo(const Value: TfieldType);
begin
  FTipo := Value;
end;

constructor TColuna.Create(Owner: TPersistent);
begin
  FOwner := Owner;
  inherited Create(TItemColuna);
end;

function TColuna.GetOwner: TPersistent;
begin
    Result := FOwner;
end;

end.
