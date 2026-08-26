unit Teste.Validador.QueryParams;

interface

uses
  DUnitX.TestFramework,
  System.Generics.Collections,
  Validador.QueryParams;

type
  [TestFixture]
  TTesteValidaCodigoExterno = class
  strict private
    FQuery: TDictionary<string, string>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    [Test]
    procedure Test_ChaveAusente_RetornaFalse;
    [Test]
    procedure Test_ValoresValidos_RetornaTrue;
    [Test]
    procedure Test_ValorMenorQueUm_LancaEValidationException;
    [Test]
    procedure Test_ValorNaoNumerico_LancaEValidationException;
  end;

  [TestFixture]
  TTesteValidaPage = class
  strict private
    FQuery: TDictionary<string, string>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    [Test]
    procedure Test_ChaveAusente_RetornaFalse;
    [Test]
    procedure Test_ValorValido_RetornaTrue;
    [Test]
    procedure Test_ValorZero_LancaEValidationException;
    [Test]
    procedure Test_ValorNaoNumerico_LancaEValidationException;
  end;

  [TestFixture]
  TTesteValidaLimit = class
  strict private
    FQuery: TDictionary<string, string>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    [Test]
    procedure Test_ChaveAusente_RetornaFalse;
    [Test]
    procedure Test_ValorValido_RetornaTrue;
    [Test]
    procedure Test_ValorZero_LancaEValidationException;
  end;

implementation

{ TTesteValidaCodigoExterno }

procedure TTesteValidaCodigoExterno.Setup;
begin
  FQuery := TDictionary<string, string>.Create;
end;

procedure TTesteValidaCodigoExterno.TearDown;
begin
  FQuery.Free;
end;

procedure TTesteValidaCodigoExterno.Test_ChaveAusente_RetornaFalse;
begin
  Assert.IsFalse(ValidaCodigoExterno(FQuery));
end;

procedure TTesteValidaCodigoExterno.Test_ValoresValidos_RetornaTrue;
begin
  FQuery.Add('codigoExterno', '1,2,3');
  Assert.IsTrue(ValidaCodigoExterno(FQuery));
end;

procedure TTesteValidaCodigoExterno.Test_ValorMenorQueUm_LancaEValidationException;
begin
  FQuery.Add('codigoExterno', '0');
  Assert.WillRaise(
    procedure
    begin
      ValidaCodigoExterno(FQuery);
    end, EValidationException);
end;

procedure TTesteValidaCodigoExterno.Test_ValorNaoNumerico_LancaEValidationException;
begin
  FQuery.Add('codigoExterno', 'abc');
  Assert.WillRaise(
    procedure
    begin
      ValidaCodigoExterno(FQuery);
    end, EValidationException);
end;

{ TTesteValidaPage }

procedure TTesteValidaPage.Setup;
begin
  FQuery := TDictionary<string, string>.Create;
end;

procedure TTesteValidaPage.TearDown;
begin
  FQuery.Free;
end;

procedure TTesteValidaPage.Test_ChaveAusente_RetornaFalse;
begin
  Assert.IsFalse(ValidaPage(FQuery));
end;

procedure TTesteValidaPage.Test_ValorValido_RetornaTrue;
begin
  FQuery.Add('page', '1');
  Assert.IsTrue(ValidaPage(FQuery));
end;

procedure TTesteValidaPage.Test_ValorZero_LancaEValidationException;
begin
  FQuery.Add('page', '0');
  Assert.WillRaise(
    procedure
    begin
      ValidaPage(FQuery);
    end, EValidationException);
end;

procedure TTesteValidaPage.Test_ValorNaoNumerico_LancaEValidationException;
begin
  FQuery.Add('page', 'abc');
  Assert.WillRaise(
    procedure
    begin
      ValidaPage(FQuery);
    end, EValidationException);
end;

{ TTesteValidaLimit }

procedure TTesteValidaLimit.Setup;
begin
  FQuery := TDictionary<string, string>.Create;
end;

procedure TTesteValidaLimit.TearDown;
begin
  FQuery.Free;
end;

procedure TTesteValidaLimit.Test_ChaveAusente_RetornaFalse;
begin
  Assert.IsFalse(ValidaLimit(FQuery));
end;

procedure TTesteValidaLimit.Test_ValorValido_RetornaTrue;
begin
  FQuery.Add('limit', '50');
  Assert.IsTrue(ValidaLimit(FQuery));
end;

procedure TTesteValidaLimit.Test_ValorZero_LancaEValidationException;
begin
  FQuery.Add('limit', '0');
  Assert.WillRaise(
    procedure
    begin
      ValidaLimit(FQuery);
    end, EValidationException);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidaCodigoExterno);
  TDUnitX.RegisterTestFixture(TTesteValidaPage);
  TDUnitX.RegisterTestFixture(TTesteValidaLimit);

end.
