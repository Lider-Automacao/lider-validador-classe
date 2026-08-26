unit Teste.Validador.Estrito.DataString;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.DataString;

type
  [TestFixture]
  TTesteEstritaDataString = class
  published
    [Test]
    procedure Test_Valido_DataValidaComBarra_RetornaTrue;
    [Test]
    procedure Test_Valido_31DeFevereiro_RetornaFalse;
    [Test]
    procedure Test_Valido_29FevereiroAnoBissexto_RetornaTrue;
    [Test]
    procedure Test_Valido_29FevereiroAnoNaoBissexto_RetornaFalse;
  end;

implementation

procedure TTesteEstritaDataString.Test_Valido_DataValidaComBarra_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaDataString.New;
  LValidacao.Valida('15/06/2025');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaDataString.Test_Valido_31DeFevereiro_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaDataString.New;
  LValidacao.Valida('31/02/2025');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaDataString.Test_Valido_29FevereiroAnoBissexto_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaDataString.New;
  LValidacao.Valida('29/02/2024');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaDataString.Test_Valido_29FevereiroAnoNaoBissexto_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<string>;
begin
  LValidacao := TValidacaoEstritaDataString.New;
  LValidacao.Valida('29/02/2025');
  Assert.IsFalse(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaDataString);

end.
