unit Teste.Validador.CNPJ;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  Variants,
  Validador.Types,
  Validador.CNPJ;

type
  [TestFixture]
  TTesteValidacaoCNPJ = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_CNPJValidoComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJValidoSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJDigitoVerificadorInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CNPJTodosDigitosIguais_RetornaFalse;
    [Test]
    procedure Test_Valido_CNPJComprimentoInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CNPJAlfanumericoValidoComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJAlfanumericoValidoSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJAlfanumericoDigitoVerificadorInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CNPJAlfanumericoMinusculo_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJVazio_RetornaFalse;
  end;

implementation

const
  // Verificado contra o algoritmo de digito de ValidaDigitos (peso 2..9 ciclico)
  CNPJ_VALIDO = '11.222.333/0001-81';
  CNPJ_VALIDO_SEM_MASCARA = '11222333000181';
  CNPJ_DIGITO_INVALIDO = '11.222.333/0001-80';
  CNPJ_TODOS_IGUAIS = '11.111.111/1111-11';
  CNPJ_COMPRIMENTO_INVALIDO = '11.222.333/0001';
  // CNPJ alfanumerico (rollout RF 2026): digitos verificadores calculados
  // com peso sobre (Ord(char) - 48), verificado via script fora do Delphi.
  CNPJ_ALFANUMERICO_VALIDO = '12.ABC.345/01DE-35';
  CNPJ_ALFANUMERICO_VALIDO_SEM_MASCARA = '12ABC34501DE35';
  CNPJ_ALFANUMERICO_DIGITO_INVALIDO = '12ABC34501DE00';

procedure TTesteValidacaoCNPJ.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  // Regressao: antes do fix, Valido chamava TRegEx.IsMatch(FValue, ...)
  // sem nenhuma checagem de Null antes — quebrava mesmo com CNPJ opcional.
  LValidacao := TValidacaoCNPJ.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJValidoComMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_VALIDO);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJValidoSemMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_VALIDO_SEM_MASCARA);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJDigitoVerificadorInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_DIGITO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJTodosDigitosIguais_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_TODOS_IGUAIS);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJComprimentoInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_COMPRIMENTO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJAlfanumericoValidoComMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_ALFANUMERICO_VALIDO);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJAlfanumericoValidoSemMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_ALFANUMERICO_VALIDO_SEM_MASCARA);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJAlfanumericoDigitoVerificadorInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCNPJ.New.Valida(CNPJ_ALFANUMERICO_DIGITO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJAlfanumericoMinusculo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  // Entrada minuscula precisa ser normalizada (ToUpper) antes de validar.
  LValidacao := TValidacaoCNPJ.New.Valida(LowerCase(CNPJ_ALFANUMERICO_VALIDO_SEM_MASCARA));
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCNPJ.Test_Valido_CNPJVazio_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  // '' nao e Null: CPF/CNPJ nao tem o bypass "vazio + nao requerido = ok"
  // que Email/Regex/Enum tem — um valor presente mas vazio sempre reprova
  // o formato, requerido ou nao.
  LValidacao := TValidacaoCNPJ.New.Requerido(False).Valida('');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoCNPJ);

end.
