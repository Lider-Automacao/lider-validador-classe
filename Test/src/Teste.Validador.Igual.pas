unit Teste.Validador.Igual;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Igual;

type
  [TestFixture]
  TTesteValidacaoIgual = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorString_ComprimentoIgualComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorString_ComprimentoDiferenteComparador_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorString_ComparadorString_Igual_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorString_ComparadorString_ComMesmoTamanhoDiferente_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorString_ComparadorString_NumericoComZeroAEsquerda_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorNumerico_IgualComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorNumerico_DiferenteComparador_RetornaFalse;
  end;

implementation

procedure TTesteValidacaoIgual.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(5).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(5).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(5).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorString_ComprimentoIgualComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(3).Valida('abc');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorString_ComprimentoDiferenteComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(3).Valida('abcd');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorString_ComparadorString_Igual_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New('61').Valida('61');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorString_ComparadorString_ComMesmoTamanhoDiferente_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New('61').Valida('62');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorString_ComparadorString_NumericoComZeroAEsquerda_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New('00').Valida('0');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorNumerico_IgualComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(5).Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoIgual.Test_Valido_ValorNumerico_DiferenteComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoIgual.New(5).Valida(7);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoIgual);

end.
