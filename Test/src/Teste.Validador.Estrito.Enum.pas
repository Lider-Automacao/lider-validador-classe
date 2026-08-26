unit Teste.Validador.Estrito.Enum;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Enum;

type
  [TestFixture]
  TTesteEstritaEnum = class
  published
    [Test]
    procedure Test_Valido_ValorContidoNoEnum_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorForaDoEnum_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorVazio_RetornaFalse;
  end;

implementation

function Enum: TArray<string>;
begin
  Result := ['ATIVO', 'INATIVO', 'PENDENTE'];
end;

procedure TTesteEstritaEnum.Test_Valido_ValorContidoNoEnum_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEnum.New(Enum);
  LValidacao.Valida('ATIVO');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaEnum.Test_Valido_ValorForaDoEnum_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEnum.New(Enum);
  LValidacao.Valida('CANCELADO');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaEnum.Test_Valido_Requerido_ValorVazio_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  // Diferente da trilha legada: aqui Requerido e' respeitado mesmo com
  // string vazia.
  LValidacao := TValidacaoEstritaEnum.New(Enum).Requerido(True);
  LValidacao.Valida('');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaEnum);

end.
