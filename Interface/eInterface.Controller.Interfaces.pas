unit eInterface.Controller.Interfaces;

interface

uses
  eInterface.Model.Interfaces;

const
  aTipoDocumento   : array[0..1] of string[4] =  ('CPF', 'CNPJ');
  aTamanhoDocumento: array[0..1] of Integer   =  (14, 18);

type
   TTipoPessoa = (tpFisica, tpJuridica);

   iControllerPessoa = interface ['{D432DB2C-AA3D-476F-B23E-EF3C4097A1C4}']
     function PessoaFisica: iPessoaFisica;
     function PessoaJuridica: iPessoaJuridica;
     function TipoPessoa(value: integer): TTipoPessoa;
     function TipoDocumento(value: integer): String;
     function TamanhoDocumento(value: integer): Integer;
   end;

implementation

end.
