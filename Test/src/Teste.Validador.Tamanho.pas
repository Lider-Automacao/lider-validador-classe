unit Teste.Validador.Tamanho;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Tamanho;

type
  [TestFixture]
  TTesteValidacaoTamanhoMinimo = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ComprimentoMaiorQueMinimo_RetornaTrue;
    [Test]
    procedure Test_Valido_ComprimentoIgualMinimo_RetornaTrue;
    [Test]
    procedure Test_Valido_ComprimentoMenorQueMinimo_RetornaFalse;
  end;

  [TestFixture]
  TTesteValidacaoTamanhoMaximo = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_ComprimentoMenorQueMaximo_RetornaTrue;
    [Test]
    procedure Test_Valido_ComprimentoIgualMaximo_RetornaTrue;
    [Test]
    procedure Test_Valido_ComprimentoMaiorQueMaximo_RetornaFalse;
  end;

implementation

{ TTesteValidacaoTamanhoMinimo }

procedure TTesteValidacaoTamanhoMinimo.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMinimo.New(5).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMinimo.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMinimo.New(5).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMinimo.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMinimo.New(5).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoTamanhoMinimo.Test_Valido_ComprimentoMaiorQueMinimo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMinimo.New(5).Valida('123456');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMinimo.Test_Valido_ComprimentoIgualMinimo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMinimo.New(5).Valida('12345');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMinimo.Test_Valido_ComprimentoMenorQueMinimo_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMinimo.New(5).Requerido(True).Valida('1234');
  Assert.IsFalse(LValidacao.Valido);
end;

{ TTesteValidacaoTamanhoMaximo }

procedure TTesteValidacaoTamanhoMaximo.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMaximo.New(5).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMaximo.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMaximo.New(5).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMaximo.Test_Valido_ComprimentoMenorQueMaximo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMaximo.New(5).Valida('1234');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMaximo.Test_Valido_ComprimentoIgualMaximo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMaximo.New(5).Valida('12345');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTamanhoMaximo.Test_Valido_ComprimentoMaiorQueMaximo_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTamanhoMaximo.New(5).Valida('123456');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoTamanhoMinimo);
  TDUnitX.RegisterTestFixture(TTesteValidacaoTamanhoMaximo);

end.
