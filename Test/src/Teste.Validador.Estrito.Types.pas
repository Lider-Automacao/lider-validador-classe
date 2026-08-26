unit Teste.Validador.Estrito.Types;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types;

type
  [TestFixture]
  TTesteNullable = class
  published
    [Test]
    procedure Test_Create_HasValueRetornaTrue;
    [Test]
    procedure Test_Create_ValuePreservaValorOriginal;
    [Test]
    procedure Test_Empty_HasValueRetornaFalse;
    [Test]
    procedure Test_ImplicitDeT_ConverteAutomaticamente;
    [Test]
    procedure Test_ImplicitParaT_RetornaValorContido;
  end;

implementation

procedure TTesteNullable.Test_Create_HasValueRetornaTrue;
var
  LValor: TNullable<Integer>;
begin
  LValor := TNullable<Integer>.Create(42);
  Assert.IsTrue(LValor.HasValue);
end;

procedure TTesteNullable.Test_Create_ValuePreservaValorOriginal;
var
  LValor: TNullable<string>;
begin
  LValor := TNullable<string>.Create('lider');
  Assert.AreEqual('lider', LValor.Value);
end;

procedure TTesteNullable.Test_Empty_HasValueRetornaFalse;
var
  LValor: TNullable<Integer>;
begin
  LValor := TNullable<Integer>.Empty;
  Assert.IsFalse(LValor.HasValue);
end;

procedure TTesteNullable.Test_ImplicitDeT_ConverteAutomaticamente;
var
  LValor: TNullable<Integer>;
begin
  LValor := 10;
  Assert.IsTrue(LValor.HasValue);
  Assert.AreEqual(10, LValor.Value);
end;

procedure TTesteNullable.Test_ImplicitParaT_RetornaValorContido;
var
  LValor: TNullable<Integer>;
  LInteiro: Integer;
begin
  LValor := TNullable<Integer>.Create(7);
  LInteiro := LValor;
  Assert.AreEqual(7, LInteiro);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteNullable);

end.
