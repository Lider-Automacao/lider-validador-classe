unit Teste.Validador.Estrito.Data;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  Validador.Estrito.Types,
  Validador.Estrito.Data;

type
  [TestFixture]
  TTesteValidadorData = class
  published
    [Test]
    procedure Test_Valido_MaiorQue_DataFutura_RetornaTrue;
    [Test]
    procedure Test_Valido_MaiorQue_DataPassada_RetornaFalse;
  end;

implementation

procedure TTesteValidadorData.Test_Valido_MaiorQue_DataFutura_RetornaTrue;
begin
  Assert.IsTrue(TValidadorData.New.Requerido.MaiorQue(EncodeDate(2020, 1, 1))
    .Valida(EncodeDate(2025, 1, 1)).Valido);
end;

procedure TTesteValidadorData.Test_Valido_MaiorQue_DataPassada_RetornaFalse;
begin
  Assert.IsFalse(TValidadorData.New.Requerido.MaiorQue(EncodeDate(2020, 1, 1))
    .Valida(EncodeDate(2010, 1, 1)).Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorData);

end.
