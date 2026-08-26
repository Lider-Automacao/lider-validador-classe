unit Teste.Validador.Estrito.Email;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Email;

type
  [TestFixture]
  TTesteEstritaEmail = class
  published
    [Test]
    procedure Test_Valido_EmailValido_RetornaTrue;
    [Test]
    procedure Test_Valido_EmailSemArroba_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
  end;

implementation

procedure TTesteEstritaEmail.Test_Valido_EmailValido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEmail.New;
  LValidacao.Valida('contato@lider.com.br');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaEmail.Test_Valido_EmailSemArroba_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEmail.New.Requerido(True);
  LValidacao.Valida('contato.lider.com.br');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaEmail.Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaEmail.New.Requerido(False);
  LValidacao.Valida(TNullable<string>.Empty);
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaEmail);

end.
