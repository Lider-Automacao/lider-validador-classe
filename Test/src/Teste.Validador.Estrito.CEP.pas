unit Teste.Validador.Estrito.CEP;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.CEP;

type
  [TestFixture]
  TTesteEstritaCEP = class
  published
    [Test]
    procedure Test_Valido_CEPComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CEPSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CEPComprimentoInvalido_RetornaFalse;
  end;

implementation

procedure TTesteEstritaCEP.Test_Valido_CEPComMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCEP.New;
  LValidacao.Valida('01310-100');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCEP.Test_Valido_CEPSemMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCEP.New;
  LValidacao.Valida('01310100');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCEP.Test_Valido_CEPComprimentoInvalido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCEP.New.Requerido(True);
  LValidacao.Valida('123');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaCEP);

end.
