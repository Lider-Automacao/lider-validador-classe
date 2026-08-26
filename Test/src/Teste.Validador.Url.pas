unit Teste.Validador.Url;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Url;

type
  [TestFixture]
  TTesteValidacaoUrl = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_UrlComHttps_RetornaTrue;
    [Test]
    procedure Test_Valido_UrlSemProtocolo_RetornaTrue;
    [Test]
    procedure Test_Valido_UrlComPath_RetornaTrue;
    [Test]
    procedure Test_Valido_UrlInvalida_RetornaFalse;
  end;

implementation

procedure TTesteValidacaoUrl.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoUrl.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoUrl.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoUrl.Test_Valido_UrlComHttps_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Valida('https://www.lider.com.br');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoUrl.Test_Valido_UrlSemProtocolo_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Valida('www.lider.com.br');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoUrl.Test_Valido_UrlComPath_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Valida('https://lider.com.br/produtos/pdv?id=1');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoUrl.Test_Valido_UrlInvalida_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoUrl.New.Valida('nao e uma url');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoUrl);

end.
