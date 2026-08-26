unit Teste.Validador.CPF;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.CPF;

type
  [TestFixture]
  TTesteValidacaoCPF = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_CPFValidoComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CPFValidoSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CPFDigitoVerificadorInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CPFTodosDigitosIguais_RetornaFalse;
    [Test]
    procedure Test_Valido_CPFComprimentoInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CPFVazio_RetornaFalse;
  end;

implementation

const
  // Verificado contra o algoritmo de digito de ValidaDigitos (peso 10..2 / 11..2)
  CPF_VALIDO = '111.444.777-35';
  CPF_VALIDO_SEM_MASCARA = '11144477735';
  CPF_DIGITO_INVALIDO = '111.444.777-36';
  CPF_TODOS_IGUAIS = '111.111.111-11';
  CPF_COMPRIMENTO_INVALIDO = '123.456';

procedure TTesteValidacaoCPF.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  // Regressao: antes do fix, Valido chamava TRegEx.IsMatch(FValue, ...)
  // sem nenhuma checagem de Null antes — quebrava mesmo com CPF opcional.
  LValidacao := TValidacaoCPF.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoCPF.Test_Valido_CPFValidoComMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Valida(CPF_VALIDO);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_CPFValidoSemMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Valida(CPF_VALIDO_SEM_MASCARA);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_CPFDigitoVerificadorInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Valida(CPF_DIGITO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_CPFTodosDigitosIguais_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Valida(CPF_TODOS_IGUAIS);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_CPFComprimentoInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCPF.New.Valida(CPF_COMPRIMENTO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCPF.Test_Valido_CPFVazio_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  // '' nao e Null: CPF/CNPJ nao tem o bypass "vazio + nao requerido = ok"
  // que Email/Regex/Enum tem — um valor presente mas vazio sempre reprova
  // o formato, requerido ou nao.
  LValidacao := TValidacaoCPF.New.Requerido(False).Valida('');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoCPF);

end.
