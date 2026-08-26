unit Teste.Validador.DataString;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.DataString;

type
  [TestFixture]
  TTesteValidacaoDataString = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_DataValidaComBarra_RetornaTrue;
    [Test]
    procedure Test_Valido_DataValidaComHifen_RetornaTrue;
    [Test]
    procedure Test_Valido_31DeFevereiro_RetornaFalse;
    [Test]
    procedure Test_Valido_31DeAbril_RetornaFalse;
    [Test]
    procedure Test_Valido_29FevereiroAnoBissexto_RetornaTrue;
    [Test]
    procedure Test_Valido_29FevereiroAnoNaoBissexto_RetornaFalse;
    [Test]
    procedure Test_Valido_FormatoInvalido_RetornaFalse;
  end;

implementation

procedure TTesteValidacaoDataString.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoDataString.Test_Valido_DataValidaComBarra_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Valida('15/06/2025');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_DataValidaComHifen_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Valida('15-06-2025');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_31DeFevereiro_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Valida('31/02/2025');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_31DeAbril_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  // Abril tem 30 dias
  LValidacao := TValidacaoDataString.New.Valida('31/04/2025');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_29FevereiroAnoBissexto_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  // 2024 e bissexto
  LValidacao := TValidacaoDataString.New.Valida('29/02/2024');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_29FevereiroAnoNaoBissexto_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  // 2025 nao e bissexto
  LValidacao := TValidacaoDataString.New.Valida('29/02/2025');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoDataString.Test_Valido_FormatoInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoDataString.New.Valida('2025-06-15');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoDataString);

end.
