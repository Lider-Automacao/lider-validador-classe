unit Teste.Validador.Estrito.Url;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Url;

type
  [TestFixture]
  TTesteEstritaUrl = class
  published
    [Test]
    procedure Test_Valido_UrlComHttps_RetornaTrue;
    [Test]
    procedure Test_Valido_UrlInvalida_RetornaFalse;
  end;

implementation

procedure TTesteEstritaUrl.Test_Valido_UrlComHttps_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaUrl.New;
  LValidacao.Valida('https://www.lider.com.br');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaUrl.Test_Valido_UrlInvalida_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaUrl.New.Requerido(True);
  LValidacao.Valida('nao e uma url');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaUrl);

end.
