unit Teste.Validador.Estrito.Double;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Double;

type
  [TestFixture]
  TTesteValidadorDouble = class
  published
    [Test]
    procedure Test_Valido_Entre_ValorDentro_RetornaTrue;
    [Test]
    procedure Test_Valido_Entre_ValorFora_RetornaFalse;
  end;

implementation

procedure TTesteValidadorDouble.Test_Valido_Entre_ValorDentro_RetornaTrue;
begin
  Assert.IsTrue(TValidadorDouble.New.Requerido.Entre(0.0, 100.0).Valida(55.5).Valido);
end;

procedure TTesteValidadorDouble.Test_Valido_Entre_ValorFora_RetornaFalse;
begin
  Assert.IsFalse(TValidadorDouble.New.Requerido.Entre(0.0, 100.0).Valida(150.5).Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorDouble);

end.
