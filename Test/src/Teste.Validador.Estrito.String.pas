unit Teste.Validador.Estrito.String;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.String;

type
  [TestFixture]
  TTesteValidadorString = class
  published
    [Test]
    procedure Test_Valido_RequeridoNaoVazio_ValorPreenchido_RetornaTrue;
    [Test]
    procedure Test_Valido_RequeridoNaoVazio_ValorAusente_RetornaFalse;
    [Test]
    procedure Test_Valido_NullableAusente_RetornaTrue;
    [Test]
    procedure Test_Valido_CPFInvalido_RetornaFalse;
    [Test]
    procedure Test_Mensagem_PrimeiraFalhaEhARetornada;
  end;

implementation

procedure TTesteValidadorString.Test_Valido_RequeridoNaoVazio_ValorPreenchido_RetornaTrue;
begin
  Assert.IsTrue(TValidadorString.New.Requerido.NaoVazio.Valida('lider').Valido);
end;

procedure TTesteValidadorString.Test_Valido_RequeridoNaoVazio_ValorAusente_RetornaFalse;
begin
  Assert.IsFalse(TValidadorString.New.Requerido.NaoVazio.Valida(TNullable<string>.Empty).Valido);
end;

procedure TTesteValidadorString.Test_Valido_NullableAusente_RetornaTrue;
begin
  Assert.IsTrue(TValidadorString.New.Nullable.NaoVazio.Valida(TNullable<string>.Empty).Valido);
end;

procedure TTesteValidadorString.Test_Valido_CPFInvalido_RetornaFalse;
begin
  Assert.IsFalse(TValidadorString.New.Requerido.CPF.Valida('111.111.111-11').Valido);
end;

procedure TTesteValidadorString.Test_Mensagem_PrimeiraFalhaEhARetornada;
var
  LValidador: TValidadorString;
begin
  LValidador := TValidadorString.New.Requerido('Nome é obrigatório').NaoVazio('Nome não pode ser vazio');
  LValidador.Valida(TNullable<string>.Empty);
  LValidador.Valido;
  Assert.AreEqual('Nome é obrigatório', LValidador.Mensagem);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorString);

end.
