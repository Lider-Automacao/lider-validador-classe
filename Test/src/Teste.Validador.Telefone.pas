unit Teste.Validador.Telefone;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Telefone;

type
  [TestFixture]
  TTesteValidacaoTelefone = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_TelefoneFixoComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_TelefoneFixoSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_TelefoneComprimentoInvalido_RetornaFalse;
  end;

  [TestFixture]
  TTesteValidacaoCelular = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_CelularComMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CelularSemMascara_RetornaTrue;
    [Test]
    procedure Test_Valido_CelularSemONoveLider_RetornaFalse;
  end;

implementation

{ TTesteValidacaoTelefone }

procedure TTesteValidacaoTelefone.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTelefone.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTelefone.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTelefone.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoTelefone.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTelefone.New.Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoTelefone.Test_Valido_TelefoneFixoComMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTelefone.New.Valida('(11) 3456-7890');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTelefone.Test_Valido_TelefoneFixoSemMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTelefone.New.Valida('1134567890');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoTelefone.Test_Valido_TelefoneComprimentoInvalido_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoTelefone.New.Valida('123456');
  Assert.IsFalse(LValidacao.Valido);
end;

{ TTesteValidacaoCelular }

procedure TTesteValidacaoCelular.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCelular.New.Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCelular.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCelular.New.Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoCelular.Test_Valido_CelularComMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCelular.New.Valida('(11) 99876-5432');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCelular.Test_Valido_CelularSemMascara_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoCelular.New.Valida('11998765432');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoCelular.Test_Valido_CelularSemONoveLider_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  // 10 digitos (sem o 9 na frente) precisa ser reprovado como celular
  LValidacao := TValidacaoCelular.New.Valida('1134567890');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoTelefone);
  TDUnitX.RegisterTestFixture(TTesteValidacaoCelular);

end.
