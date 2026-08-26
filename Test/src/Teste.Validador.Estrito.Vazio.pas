unit Teste.Validador.Estrito.Vazio;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Vazio;

type
  [TestFixture]
  TTesteEstritaEstaVazio = class
  published
    [Test]
    procedure Test_Valido_ValorVazio_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorPreenchido_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
  end;

  [TestFixture]
  TTesteEstritaNaoEstaVazio = class
  published
    [Test]
    procedure Test_Valido_ValorPreenchido_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorVazio_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorAusente_Requerido_RetornaFalse;
  end;

implementation

procedure TTesteEstritaEstaVazio.Test_Valido_ValorVazio_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEstaVazio.New;
  LValidacao.Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaEstaVazio.Test_Valido_ValorPreenchido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEstaVazio.New;
  LValidacao.Valida('lider');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaEstaVazio.Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEstaVazio.New.Requerido(False);
  LValidacao.Valida(TNullable<string>.Empty);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaNaoEstaVazio.Test_Valido_ValorPreenchido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaNaoEstaVazio.New;
  LValidacao.Valida('lider');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaNaoEstaVazio.Test_Valido_ValorVazio_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaNaoEstaVazio.New;
  LValidacao.Valida('');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaNaoEstaVazio.Test_Valido_ValorAusente_Requerido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaNaoEstaVazio.New.Requerido(True);
  LValidacao.Valida(TNullable<string>.Empty);
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaEstaVazio);
  TDUnitX.RegisterTestFixture(TTesteEstritaNaoEstaVazio);

end.
