unit Teste.Validador.Email;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Email;

type
  [TestFixture]
  TTesteValidacaoEmail = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_EmailValido_RetornaTrue;
    [Test]
    procedure Test_Valido_EmailSemArroba_RetornaFalse;
    [Test]
    procedure Test_Valido_EmailSemDominio_RetornaFalse;
    [Test]
    procedure Test_Valido_NaoRequerido_ValorVazio_RetornaTrue;
  end;

implementation

procedure TTesteValidacaoEmail.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEmail.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEmail.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoEmail.Test_Valido_EmailValido_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Valida('contato@lider.com.br');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEmail.Test_Valido_EmailSemArroba_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Valida('contato.lider.com.br');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEmail.Test_Valido_EmailSemDominio_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Valida('contato@lider');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEmail.Test_Valido_NaoRequerido_ValorVazio_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEmail.New.Requerido(False).Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoEmail);

end.
