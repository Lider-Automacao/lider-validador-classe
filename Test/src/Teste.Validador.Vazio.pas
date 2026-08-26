unit Teste.Validador.Vazio;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Vazio;

type
  [TestFixture]
  TTesteValidacaoEstaVazio = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorVazio_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorComEspacos_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorPreenchido_RetornaFalse;
  end;

  [TestFixture]
  TTesteValidacaoNaoEstaVazio = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorVazio_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorComEspacos_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorPreenchido_RetornaTrue;
  end;

implementation

{ TTesteValidacaoEstaVazio }

procedure TTesteValidacaoEstaVazio.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEstaVazio.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEstaVazio.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEstaVazio.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEstaVazio.Test_Valido_ValorVazio_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEstaVazio.New.Requerido(True).Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEstaVazio.Test_Valido_ValorComEspacos_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEstaVazio.New.Requerido(True).Valida('   ');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEstaVazio.Test_Valido_ValorPreenchido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEstaVazio.New.Requerido(True).Valida('lider');
  Assert.IsFalse(LValidacao.Valido);
end;

{ TTesteValidacaoNaoEstaVazio }

procedure TTesteValidacaoNaoEstaVazio.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoNaoEstaVazio.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoNaoEstaVazio.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoNaoEstaVazio.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoNaoEstaVazio.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  // Regressao: campo Nullable ausente + Requerido nao pode estourar
  // EVariantTypeCastError — precisa reprovar limpo (ver VerificaErro). O
  // Valida(Null) e o Valido ficam dentro do bloco protegido porque a
  // conversao implicita de Variant Null pra String pode estourar tanto na
  // passagem do parametro quanto dentro de Valido — o teste nao assume
  // onde exatamente.
  LValidacao := TValidacaoNaoEstaVazio.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
  Assert.WillRaise(
    procedure
    begin
      LValidacao.VerificaErro;
    end, TValidadorException);
end;

procedure TTesteValidacaoNaoEstaVazio.Test_Valido_ValorVazio_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoNaoEstaVazio.New.Requerido(True).Valida('');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoNaoEstaVazio.Test_Valido_ValorComEspacos_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoNaoEstaVazio.New.Requerido(True).Valida('   ');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoNaoEstaVazio.Test_Valido_ValorPreenchido_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoNaoEstaVazio.New.Requerido(True).Valida('lider');
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoEstaVazio);
  TDUnitX.RegisterTestFixture(TTesteValidacaoNaoEstaVazio);

end.
