unit eInterface.Model.Pessoa.Factory;

interface

uses
  eInterface.Model.Interfaces;

type
    TModelPessoaFactory = class(TInterfacedObject, iPessoaFactory)
      private
      public
        constructor Create;
        destructor Destroy; override;
        class function new: iPessoaFactory;
        function PessoaFisica: iPessoaFisica;
        function PessoaJuridica: iPessoaJuridica;
    end;

implementation

uses
  eInterface.Model.PessoaJuridica, eInterface.Model.PessoaFisica;

constructor TModelPessoaFactory.Create;
begin

end;

destructor TModelPessoaFactory.Destroy;
begin
  inherited
end;


class function TModelPessoaFactory.new: iPessoaFactory;
begin
  Result := Self.Create;
end;

function TModelPessoaFactory.PessoaFisica: iPessoaFisica;
begin
  Result := TModelPessoaFisica.New;
end;

function TModelPessoaFactory.PessoaJuridica: iPessoaJuridica;
begin
  Result := TModelPessoaJuridica.New;
end;

end.
