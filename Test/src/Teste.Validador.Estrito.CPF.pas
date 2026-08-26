unit Teste.Validador.Estrito.CPF;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.CPF;

type
  [TestFixture]
  TTesteEstritaCPF = class
  published
    [Test]
    procedure Test_Valido_CPFValidoComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CPFValidoSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CPFDigitoVerificadorInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CPFTodosDigitosIguais_RetornaFalse;
    [Test]
    procedure Test_Valido_CPFVazio_RetornaFalse;
  end;

implementation

const
  CPF_VALIDO = '111.444.777-35';
  CPF_VALIDO_SEM_MASCARA = '11144477735';
  CPF_DIGITO_INVALIDO = '111.444.777-36';
  CPF_TODOS_IGUAIS = '111.111.111-11';

procedure TTesteEstritaCPF.Test_Valido_CPFValidoComMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCPF.New;
  LValidacao.Valida(CPF_VALIDO);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCPF.Test_Valido_CPFValidoSemMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCPF.New;
  LValidacao.Valida(CPF_VALIDO_SEM_MASCARA);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCPF.Test_Valido_CPFDigitoVerificadorInvalido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCPF.New;
  LValidacao.Valida(CPF_DIGITO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaCPF.Test_Valido_CPFTodosDigitosIguais_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCPF.New;
  LValidacao.Valida(CPF_TODOS_IGUAIS);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaCPF.Test_Valido_CPFVazio_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCPF.New.Requerido(False);
  LValidacao.Valida('');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaCPF);

end.
