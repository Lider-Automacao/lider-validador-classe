unit Teste.Validador.Estrito.Inteiro;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Inteiro;

type
  [TestFixture]
  TTesteValidadorInteiro = class
  published
    [Test]
    procedure Test_Valido_RequeridoEntre_ValorDentro_RetornaTrue;
    [Test]
    procedure Test_Valido_RequeridoEntre_ValorFora_RetornaFalse;
    [Test]
    procedure Test_Valido_NullableAusente_RetornaTrue;
  end;

implementation

procedure TTesteValidadorInteiro.Test_Valido_RequeridoEntre_ValorDentro_RetornaTrue;
begin
  Assert.IsTrue(TValidadorInteiro.New.Requerido.Entre(1, 120).Valida(30).Valido);
end;

procedure TTesteValidadorInteiro.Test_Valido_RequeridoEntre_ValorFora_RetornaFalse;
begin
  Assert.IsFalse(TValidadorInteiro.New.Requerido.Entre(1, 120).Valida(150).Valido);
end;

procedure TTesteValidadorInteiro.Test_Valido_NullableAusente_RetornaTrue;
begin
  Assert.IsTrue(TValidadorInteiro.New.Nullable.MaiorQue(0).Valida(TNullable<Integer>.Empty).Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorInteiro);

end.
