unit Teste.Validador.Estrito.CNPJ;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.CNPJ;

type
  [TestFixture]
  TTesteEstritaCNPJ = class
  published
    [Test]
    procedure Test_Valido_CNPJValidoComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJDigitoVerificadorInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_CNPJTodosCaracteresIguais_RetornaFalse;
    [Test]
    procedure Test_Valido_CNPJAlfanumericoValido_RetornaTrue;
    [Test]
    procedure Test_Valido_CNPJAlfanumericoDigitoInvalido_RetornaFalse;
  end;

implementation

const
  CNPJ_VALIDO = '11.222.333/0001-81';
  CNPJ_DIGITO_INVALIDO = '11.222.333/0001-80';
  CNPJ_TODOS_IGUAIS = '11.111.111/1111-11';
  CNPJ_ALFANUMERICO_VALIDO = '12ABC34501DE35';
  CNPJ_ALFANUMERICO_DIGITO_INVALIDO = '12ABC34501DE00';

procedure TTesteEstritaCNPJ.Test_Valido_CNPJValidoComMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCNPJ.New;
  LValidacao.Valida(CNPJ_VALIDO);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCNPJ.Test_Valido_CNPJDigitoVerificadorInvalido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCNPJ.New;
  LValidacao.Valida(CNPJ_DIGITO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaCNPJ.Test_Valido_CNPJTodosCaracteresIguais_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCNPJ.New;
  LValidacao.Valida(CNPJ_TODOS_IGUAIS);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaCNPJ.Test_Valido_CNPJAlfanumericoValido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCNPJ.New;
  LValidacao.Valida(CNPJ_ALFANUMERICO_VALIDO);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCNPJ.Test_Valido_CNPJAlfanumericoDigitoInvalido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCNPJ.New;
  LValidacao.Valida(CNPJ_ALFANUMERICO_DIGITO_INVALIDO);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaCNPJ);

end.
