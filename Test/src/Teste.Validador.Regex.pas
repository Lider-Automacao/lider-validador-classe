unit Teste.Validador.Regex;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Regex;

type
  [TestFixture]
  TTesteValidacaoRegex = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_NaoRequerido_ValorVazio_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorCasaPadrao_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorNaoCasaPadrao_RetornaFalse;
  end;

implementation

const
  REGEX_SOMENTE_NUMEROS = '^\d+$';

procedure TTesteValidacaoRegex.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoRegex.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoRegex.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoRegex.Test_Valido_NaoRequerido_ValorVazio_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(False).Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoRegex.Test_Valido_ValorCasaPadrao_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRegex.New(REGEX_SOMENTE_NUMEROS).Valida('12345');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoRegex.Test_Valido_ValorNaoCasaPadrao_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRegex.New(REGEX_SOMENTE_NUMEROS).Requerido(True).Valida('abc123');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoRegex);

end.
