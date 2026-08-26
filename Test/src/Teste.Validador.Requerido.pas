unit Teste.Validador.Requerido;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Requerido;

type
  [TestFixture]
  TTesteValidacaoRequerido = class
  published
    [Test]
    procedure Test_Valido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorVazio_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorPreenchido_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorZero_RetornaTrue;
    [Test]
    procedure Test_VerificaErro_ValorNull_LancaTValidadorException;
  end;

implementation

procedure TTesteValidacaoRequerido.Test_Valido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRequerido.New.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoRequerido.Test_Valido_ValorVazio_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  // string vazia nao e Null: TValidacaoRequerido so reprova ausencia total
  LValidacao := TValidacaoRequerido.New.Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoRequerido.Test_Valido_ValorPreenchido_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRequerido.New.Valida('lider');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoRequerido.Test_Valido_ValorZero_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRequerido.New.Valida(0);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoRequerido.Test_VerificaErro_ValorNull_LancaTValidadorException;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoRequerido.New.Valida(Null);
  Assert.WillRaise(
    procedure
    begin
      LValidacao.VerificaErro;
    end, TValidadorException);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoRequerido);

end.
