unit Teste.Validador.Estrito.Regex;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Regex;

type
  [TestFixture]
  TTesteEstritaRegex = class
  published
    [Test]
    procedure Test_Valido_ValorCasaPadrao_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorNaoCasaPadrao_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorVazio_NaoRequerido_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
  end;

implementation

const
  REGEX_SOMENTE_NUMEROS = '^\d+$';

procedure TTesteEstritaRegex.Test_Valido_ValorCasaPadrao_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaRegex.New(REGEX_SOMENTE_NUMEROS);
  LValidacao.Valida('12345');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaRegex.Test_Valido_ValorNaoCasaPadrao_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(True);
  LValidacao.Valida('abc123');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaRegex.Test_Valido_ValorVazio_NaoRequerido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(False);
  LValidacao.Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaRegex.Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(False);
  LValidacao.Valida(TNullable<string>.Empty);
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaRegex);

end.
