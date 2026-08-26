unit Teste.Validador.Estrito.Comparacao;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Comparacao;

type
  [TestFixture]
  TTesteComparacaoEstrita = class
  published
    [Test]
    procedure Test_MaiorQue_ValorMaior_RetornaTrue;
    [Test]
    procedure Test_MaiorQue_ValorIgual_RetornaFalse;
    [Test]
    procedure Test_MaiorQue_ValorAusente_NaoRequerido_RetornaTrue;
    [Test]
    procedure Test_MaiorQue_ValorAusente_Requerido_RetornaFalse;
    [Test]
    procedure Test_MaiorOuIgualQue_ValorIgual_RetornaTrue;
    [Test]
    procedure Test_MenorQue_ValorMenor_RetornaTrue;
    [Test]
    procedure Test_MenorQue_ValorMaior_RetornaFalse;
    [Test]
    procedure Test_MenorOuIgualQue_ValorIgual_RetornaTrue;
    [Test]
    procedure Test_Entre_ValorDentro_RetornaTrue;
    [Test]
    procedure Test_Entre_ValorFora_RetornaFalse;
    [Test]
    procedure Test_Igual_ValoresIguais_RetornaTrue;
    [Test]
    procedure Test_Igual_ValoresDiferentes_RetornaFalse;
    [Test]
    procedure Test_MaiorQue_ComDouble_RetornaTrue;
  end;

implementation

procedure TTesteComparacaoEstrita.Test_MaiorQue_ValorMaior_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMaiorQue<Integer>.New(10);
  LValidacao.Valida(15);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MaiorQue_ValorIgual_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMaiorQue<Integer>.New(10);
  LValidacao.Valida(10);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MaiorQue_ValorAusente_NaoRequerido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMaiorQue<Integer>.New(10).Requerido(False);
  LValidacao.Valida(TNullable<Integer>.Empty);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MaiorQue_ValorAusente_Requerido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMaiorQue<Integer>.New(10).Requerido(True);
  LValidacao.Valida(TNullable<Integer>.Empty);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MaiorOuIgualQue_ValorIgual_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMaiorOuIgualQue<Integer>.New(10);
  LValidacao.Valida(10);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MenorQue_ValorMenor_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMenorQue<Integer>.New(10);
  LValidacao.Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MenorQue_ValorMaior_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMenorQue<Integer>.New(10);
  LValidacao.Valida(15);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MenorOuIgualQue_ValorIgual_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaMenorOuIgualQue<Integer>.New(10);
  LValidacao.Valida(10);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_Entre_ValorDentro_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaEntre<Integer>.New(1, 10);
  LValidacao.Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_Entre_ValorFora_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaEntre<Integer>.New(1, 10);
  LValidacao.Valida(11);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_Igual_ValoresIguais_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaIgual<Integer>.New(5);
  LValidacao.Valida(5);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_Igual_ValoresDiferentes_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaIgual<Integer>.New(5);
  LValidacao.Valida(7);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteComparacaoEstrita.Test_MaiorQue_ComDouble_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<Double>;
begin
  LValidacao := TValidacaoEstritaMaiorQue<Double>.New(1.5);
  LValidacao.Valida(2.7);
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteComparacaoEstrita);

end.
