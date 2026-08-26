unit Teste.Validador.MaiorQue;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.MaiorQue;

type
  [TestFixture]
  TTesteValidacaoMaiorQue = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorMaiorQueComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorIgualComparador_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorMenorQueComparador_RetornaFalse;
    [Test]
    procedure Test_Valido_ComprimentoStringMaiorQueComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_TodosElementosArrayMaioresQueComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_AlgumElementoArrayNaoMaiorQueComparador_RetornaFalse;
  end;

  [TestFixture]
  TTesteValidacaoMaiorOuIgualQue = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorMaiorQueComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorIgualComparador_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorMenorQueComparador_RetornaFalse;
  end;

implementation

{ TTesteValidacaoMaiorQue }

procedure TTesteValidacaoMaiorQue.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(10).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(10).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(10).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_ValorMaiorQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(10).Valida(15);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_ValorIgualComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(10).Valida(10);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_ValorMenorQueComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(10).Valida(5);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_ComprimentoStringMaiorQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(3).Valida('abcd');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_TodosElementosArrayMaioresQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(3).Valida(VarArrayOf([4, 5, 6]));
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorQue.Test_Valido_AlgumElementoArrayNaoMaiorQueComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorQue.New(3).Valida(VarArrayOf([4, 2, 6]));
  Assert.IsFalse(LValidacao.Valido);
end;

{ TTesteValidacaoMaiorOuIgualQue }

procedure TTesteValidacaoMaiorOuIgualQue.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorOuIgualQue.New(10).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorOuIgualQue.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorOuIgualQue.New(10).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorOuIgualQue.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorOuIgualQue.New(10).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoMaiorOuIgualQue.Test_Valido_ValorMaiorQueComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorOuIgualQue.New(10).Valida(15);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorOuIgualQue.Test_Valido_ValorIgualComparador_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorOuIgualQue.New(10).Valida(10);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoMaiorOuIgualQue.Test_Valido_ValorMenorQueComparador_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoMaiorOuIgualQue.New(10).Valida(5);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoMaiorQue);
  TDUnitX.RegisterTestFixture(TTesteValidacaoMaiorOuIgualQue);

end.
