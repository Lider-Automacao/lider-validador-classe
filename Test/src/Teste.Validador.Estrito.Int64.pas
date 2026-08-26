unit Teste.Validador.Estrito.Int64;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Int64;

type
  [TestFixture]
  TTesteValidadorInt64 = class
  published
    [Test]
    procedure Test_Valido_MaiorQue_ValorMaior_RetornaTrue;
    [Test]
    procedure Test_Valido_MaiorQue_ValorMenor_RetornaFalse;
  end;

implementation

procedure TTesteValidadorInt64.Test_Valido_MaiorQue_ValorMaior_RetornaTrue;
begin
  Assert.IsTrue(TValidadorInt64.New.Requerido.MaiorQue(1000000000000).Valida(Int64(9999999999999)).Valido);
end;

procedure TTesteValidadorInt64.Test_Valido_MaiorQue_ValorMenor_RetornaFalse;
begin
  Assert.IsFalse(TValidadorInt64.New.Requerido.MaiorQue(1000000000000).Valida(Int64(1)).Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorInt64);

end.
