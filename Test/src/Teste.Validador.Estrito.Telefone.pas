unit Teste.Validador.Estrito.Telefone;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Telefone;

type
  [TestFixture]
  TTesteEstritaTelefone = class
  published
    [Test]
    procedure Test_Valido_TelefoneFixoSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_TelefoneComprimentoInvalido_RetornaFalse;
  end;

  [TestFixture]
  TTesteEstritaCelular = class
  published
    [Test]
    procedure Test_Valido_CelularSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CelularSemONoveLider_RetornaFalse;
  end;

implementation

procedure TTesteEstritaTelefone.Test_Valido_TelefoneFixoSemMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaTelefone.New;
  LValidacao.Valida('1134567890');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaTelefone.Test_Valido_TelefoneComprimentoInvalido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaTelefone.New.Requerido(True);
  LValidacao.Valida('123456');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaCelular.Test_Valido_CelularSemMascara_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCelular.New;
  LValidacao.Valida('11998765432');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaCelular.Test_Valido_CelularSemONoveLider_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaCelular.New.Requerido(True);
  LValidacao.Valida('1134567890');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaTelefone);
  TDUnitX.RegisterTestFixture(TTesteEstritaCelular);

end.
