unit Teste.Validador.Entre;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Entre;

type
  [TestFixture]
  TTesteValidacaoEntre = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorDentroDoRange_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorIgualMinimo_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorIgualMaximo_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorAbaixoDoMinimo_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorAcimaDoMaximo_RetornaFalse;
  end;

implementation

procedure TTesteValidacaoEntre.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEntre.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEntre.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoEntre.Test_Valido_ValorDentroDoRange_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEntre.Test_Valido_ValorIgualMinimo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Valida(1);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEntre.Test_Valido_ValorIgualMaximo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Valida(10);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEntre.Test_Valido_ValorAbaixoDoMinimo_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Valida(0);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEntre.Test_Valido_ValorAcimaDoMaximo_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEntre.New(1, 10).Valida(11);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoEntre);

end.
