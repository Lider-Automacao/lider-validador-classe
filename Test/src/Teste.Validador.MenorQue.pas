unit Teste.Validador.MenorQue;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.MenorQue;

type
  [TestFixture]
  TTesteValidacaoMenorQue = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorMenorQueComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorIgualComparador_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorMaiorQueComparador_RetornaFalse;
    [Test]
    procedure Test_Valido_ComprimentoStringMenorQueComparador_RetornaTrue;
  end;

  [TestFixture]
  TTesteValidacaoMenorOuIgualQue = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorMenorQueComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorIgualComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorMaiorQueComparador_RetornaFalse;
  end;

implementation

{ TTesteValidacaoMenorQue }

procedure TTesteValidacaoMenorQue.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(10).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorQue.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(10).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorQue.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(10).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoMenorQue.Test_Valido_ValorMenorQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(10).Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorQue.Test_Valido_ValorIgualComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(10).Valida(10);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorQue.Test_Valido_ValorMaiorQueComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(10).Valida(15);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorQue.Test_Valido_ComprimentoStringMenorQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorQue.New(5).Valida('ab');
  Assert.IsTrue(LValidacao.Valido);
end;

{ TTesteValidacaoMenorOuIgualQue }

procedure TTesteValidacaoMenorOuIgualQue.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorOuIgualQue.New(10).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorOuIgualQue.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorOuIgualQue.New(10).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorOuIgualQue.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorOuIgualQue.New(10).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoMenorOuIgualQue.Test_Valido_ValorMenorQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorOuIgualQue.New(10).Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorOuIgualQue.Test_Valido_ValorIgualComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorOuIgualQue.New(10).Valida(10);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMenorOuIgualQue.Test_Valido_ValorMaiorQueComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMenorOuIgualQue.New(10).Valida(15);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoMenorQue);
  TDUnitX.RegisterTestFixture(TTesteValidacaoMenorOuIgualQue);

end.
