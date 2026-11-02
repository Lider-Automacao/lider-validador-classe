unit Teste.Validador.Estrito.Strings;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Strings;

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
    [Test]
    procedure Test_Igual_ValorIgualComEspacos_RetornaTrue;
    [Test]
    procedure Test_Igual_ValorDiferente_UsaMensagemDoLegado;
    [Test]
    procedure Test_Igual_ValorDiferenteComMensagem_UsaMensagemInformada;
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

procedure TTesteValidadorString.Test_Igual_ValorIgualComEspacos_RetornaTrue;
begin
  Assert.IsTrue(TValidadorString.New.Requerido.Igual('00').Valida(' 00 ').Valido);
end;

procedure TTesteValidadorString.Test_Igual_ValorDiferente_UsaMensagemDoLegado;
var
  LValidador: IValidadorString;
begin
  LValidador := TValidadorString.New.Requerido.Igual('00').Valida('10');
  LValidador.Valido;
  Assert.AreEqual('valor 10 deve ser igual a 00', LValidador.Mensagem);
end;

procedure TTesteValidadorString.Test_Igual_ValorDiferenteComMensagem_UsaMensagemInformada;
var
  LValidador: IValidadorString;
begin
  LValidador := TValidadorString.New.Requerido.Igual('00', 'CST inválido').Valida('10');
  LValidador.Valido;
  Assert.AreEqual('CST inválido', LValidador.Mensagem);
end;

procedure TTesteValidadorString.Test_Mensagem_PrimeiraFalhaEhARetornada;
var
  LValidador: IValidadorString;
begin
  LValidador := TValidadorString.New.Requerido('Nome é obrigatório').NaoVazio('Nome não pode ser vazio');
  LValidador.Valida(TNullable<string>.Empty);
  LValidador.Valido;
  Assert.AreEqual('Nome é obrigatório', LValidador.Mensagem);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorString);

end.
