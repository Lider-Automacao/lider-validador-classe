unit Teste.Validador.Estrito.Tamanho;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Tamanho;

type
  [TestFixture]
  TTesteEstritaTamanhoMinimo = class
  published
    [Test]
    procedure Test_Valido_ComprimentoIgualMinimo_RetornaTrue;
    [Test]
    procedure Test_Valido_ComprimentoMenorQueMinimo_RetornaFalse;
  end;

  [TestFixture]
  TTesteEstritaTamanhoMaximo = class
  published
    [Test]
    procedure Test_Valido_ComprimentoIgualMaximo_RetornaTrue;
    [Test]
    procedure Test_Valido_ComprimentoMaiorQueMaximo_RetornaFalse;
  end;

implementation

procedure TTesteEstritaTamanhoMinimo.Test_Valido_ComprimentoIgualMinimo_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaTamanhoMinimo.New(5);
  LValidacao.Valida('12345');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaTamanhoMinimo.Test_Valido_ComprimentoMenorQueMinimo_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaTamanhoMinimo.New(5).Requerido(True);
  LValidacao.Valida('1234');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaTamanhoMaximo.Test_Valido_ComprimentoIgualMaximo_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaTamanhoMaximo.New(5);
  LValidacao.Valida('12345');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaTamanhoMaximo.Test_Valido_ComprimentoMaiorQueMaximo_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaTamanhoMaximo.New(5);
  LValidacao.Valida('123456');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaTamanhoMinimo);
  TDUnitX.RegisterTestFixture(TTesteEstritaTamanhoMaximo);

end.
