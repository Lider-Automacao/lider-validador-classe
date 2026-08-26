unit Teste.Validador.Estrito.Requerido;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Requerido;

type
  [TestFixture]
  TTesteValidacaoEstritaRequerido = class
  published
    [Test]
    procedure Test_Valido_ValorPresente_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorAusente_RetornaFalse;
  end;

implementation

procedure TTesteValidacaoEstritaRequerido.Test_Valido_ValorPresente_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaRequerido<Integer>.New;
  LValidacao.Valida(TNullable<Integer>.Create(1));
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEstritaRequerido.Test_Valido_ValorAusente_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaRequerido<Integer>.New;
  LValidacao.Valida(TNullable<Integer>.Empty);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoEstritaRequerido);

end.
