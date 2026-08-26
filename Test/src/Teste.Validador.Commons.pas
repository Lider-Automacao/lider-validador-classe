unit Teste.Validador.Commons;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Types,
  Validador.Commons;

type
  [TestFixture]
  TTesteInStringToArray = class
  published
    [Test]
    procedure Test_InStringToArray_CsvValido_RetornaArrayDeInteiros;
    [Test]
    procedure Test_InStringToArray_ValorUnico_RetornaArrayComUmElemento;
    [Test]
    procedure Test_InStringToArray_StringVazia_RetornaArrayVazio;
    [Test]
    procedure Test_InStringToArray_ComEspacos_IgnoraEspacos;
    [Test]
    procedure Test_InStringToArray_ContemNaoNumerico_LancaExcecao;
  end;

implementation

procedure TTesteInStringToArray.Test_InStringToArray_CsvValido_RetornaArrayDeInteiros;
var
  LResultado: TIntegerDynArray;
begin
  LResultado := InStringToArray('1,2,3');
  Assert.AreEqual(3, Length(LResultado));
  Assert.AreEqual(1, LResultado[0]);
  Assert.AreEqual(2, LResultado[1]);
  Assert.AreEqual(3, LResultado[2]);
end;

procedure TTesteInStringToArray.Test_InStringToArray_ValorUnico_RetornaArrayComUmElemento;
var
  LResultado: TIntegerDynArray;
begin
  LResultado := InStringToArray('42');
  Assert.AreEqual(1, Length(LResultado));
  Assert.AreEqual(42, LResultado[0]);
end;

procedure TTesteInStringToArray.Test_InStringToArray_StringVazia_RetornaArrayVazio;
var
  LResultado: TIntegerDynArray;
begin
  LResultado := InStringToArray('');
  Assert.AreEqual(0, Length(LResultado));
end;

procedure TTesteInStringToArray.Test_InStringToArray_ComEspacos_IgnoraEspacos;
var
  LResultado: TIntegerDynArray;
begin
  LResultado := InStringToArray('  1,2,3  ');
  Assert.AreEqual(3, Length(LResultado));
end;

procedure TTesteInStringToArray.Test_InStringToArray_ContemNaoNumerico_LancaExcecao;
begin
  Assert.WillRaise(
    procedure
    begin
      InStringToArray('1,abc,3');
    end, Exception);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteInStringToArray);

end.
