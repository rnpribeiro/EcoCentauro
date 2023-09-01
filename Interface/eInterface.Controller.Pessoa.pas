unit eInterface.Controller.Pessoa;

interface

uses
  eInterface.Controller.Interfaces, eInterface.Model.Interfaces;
type
    TControllerPessoa = class(TInterfacedObject, iControllerPessoa)
      private
      public
        constructor Create;
        destructor Destroy; override;
        class function new: iControllerPessoa;
        function PessoaFisica: iPessoaFisica;
        function PessoaJuridica: iPessoaJuridica;
        function TipoPessoa(value: integer): TTipoPessoa;
        function TipoDocumento(value: integer): String;
        function TamanhoDocumento(value: integer): Integer;
    end;

implementation

uses
  eInterface.Model.Pessoa.Factory;

{ TControllerPessoa }

constructor TControllerPessoa.Create;
begin

end;

destructor TControllerPessoa.Destroy;
begin

  inherited;
end;

class function TControllerPessoa.new: iControllerPessoa;
begin
  Result := Self.Create;
end;

function TControllerPessoa.PessoaFisica: iPessoaFisica;
begin
  Result := TModelPessoaFactory.New.PessoaFisica;
end;

function TControllerPessoa.PessoaJuridica: iPessoaJuridica;
begin
  Result := TModelPessoaFactory.New.PessoaJuridica;
end;

function TControllerPessoa.TamanhoDocumento(value: integer): Integer;
begin
  Result := aTamanhoDocumento[value];
end;

function TControllerPessoa.TipoDocumento(value: integer): String;
begin
  Result := aTipoDocumento[value];
end;

function TControllerPessoa.TipoPessoa(value: integer): TTipoPessoa;
begin
  Result := TTipoPessoa(Value);
end;

end.