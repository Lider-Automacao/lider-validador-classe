unit Teste.Validador.CEP;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.CEP;

type
  [TestFixture]
  TTesteValidacaoCEP = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_CEPComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CEPSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CEPComprimentoInvalido_RetornaFalse;
  end;

implementation

procedure TTesteValidacaoCEP.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCEP.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCEP.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCEP.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCEP.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCEP.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoCEP.Test_Valido_CEPComMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCEP.New.Valida('01310-100');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCEP.Test_Valido_CEPSemMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCEP.New.Valida('01310100');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCEP.Test_Valido_CEPComprimentoInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCEP.New.Valida('123');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoCEP);

end.
