unit Teste.Validador;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador,
  Validador.Types;

type
  [TestFixture]
  TTesteValidadorFluente = class
  published
    [Test]
    procedure Test_CampoRequeridoNaoVazio_ValorNullAusente_LancaTValidadorExceptionLimpa;
    [Test]
    procedure Test_CampoRequeridoNaoVazio_ValorNullAusente_MensagemContemTextoDoRequerido;
    [Test]
    procedure Test_CampoOpcional_ValorNullAusente_NaoLancaExcecao;
    [Test]
    procedure Test_CPF_MensagemPersonalizada_EhUsadaNoErro;
    [Test]
    procedure Test_CNPJ_MensagemPersonalizada_EhUsadaNoErro;
    [Test]
    procedure Test_TodosCamposValidos_NaoLancaExcecao;
    [Test]
    procedure Test_IValidadorEIValidadorAdd_TemGUIDsDiferentes;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo;

procedure TTesteValidadorFluente.Test_CampoRequeridoNaoVazio_ValorNullAusente_LancaTValidadorExceptionLimpa;
begin
  // Regressao do bug original: Nullable<string> totalmente ausente (Null,
  // nao '') encadeado com .Requerido.NaoVazio nao pode mais estourar
  // EVariantTypeCastError — precisa reprovar com TValidadorException limpa.
  // Cenario real: TValidacaoCertificado.Add('arquivoBase64', ...)
  //   .Requerido('E requerido o certificado').NaoVazio.
  Assert.WillRaise(
    procedure
    begin
      TValidador.New
        .Add('arquivoBase64', Null)
          .Requerido('E requerido o certificado')
          .NaoVazio('Nao pode ser vazio')
        .&End
        .Executa
        .VerificaTodosErro;
    end, TValidadorException);
end;

procedure TTesteValidadorFluente.Test_CampoRequeridoNaoVazio_ValorNullAusente_MensagemContemTextoDoRequerido;
var
  LMensagem: string;
begin
  LMensagem := '';
  try
    TValidador.New
      .Add('arquivoBase64', Null)
        .Requerido('E requerido o certificado')
        .NaoVazio('Nao pode ser vazio')
      .&End
      .Executa
      .VerificaTodosErro;
    Assert.Fail('Esperava TValidadorException');
  except
    on E: TValidadorException do
      LMensagem := E.Message;
  end;
  Assert.Contains(LMensagem, 'arquivoBase64');
  Assert.Contains(LMensagem, 'E requerido o certificado');
end;

procedure TTesteValidadorFluente.Test_CampoOpcional_ValorNullAusente_NaoLancaExcecao;
begin
  // Nullable ausente + Nullable() (nao requerido) precisa passar limpo.
  Assert.WillNotRaise(
    procedure
    begin
      TValidador.New
        .Add('apelido', Null)
          .Nullable
          .NaoVazio('Nao pode ser vazio')
        .&End
        .Executa
        .VerificaTodosErro;
    end);
end;

procedure TTesteValidadorFluente.Test_CPF_MensagemPersonalizada_EhUsadaNoErro;
var
  LMensagem: string;
begin
  LMensagem := '';
  try
    TValidador.New
      .Add('cpf', '111.444.777-36')
        .Nullable
        .CPF('CPF do titular esta invalido')
      .&End
      .Executa
      .VerificaTodosErro;
    Assert.Fail('Esperava TValidadorException');
  except
    on E: TValidadorException do
      LMensagem := E.Message;
  end;
  Assert.Contains(LMensagem, 'CPF do titular esta invalido');
end;

procedure TTesteValidadorFluente.Test_CNPJ_MensagemPersonalizada_EhUsadaNoErro;
var
  LMensagem: string;
begin
  LMensagem := '';
  try
    TValidador.New
      .Add('cnpj', '11.222.333/0001-80')
        .Nullable
        .CNPJ('CNPJ da empresa esta invalido')
      .&End
      .Executa
      .VerificaTodosErro;
    Assert.Fail('Esperava TValidadorException');
  except
    on E: TValidadorException do
      LMensagem := E.Message;
  end;
  Assert.Contains(LMensagem, 'CNPJ da empresa esta invalido');
end;

procedure TTesteValidadorFluente.Test_TodosCamposValidos_NaoLancaExcecao;
begin
  Assert.WillNotRaise(
    procedure
    begin
      TValidador.New
        .Add('nome', 'Lider Automacao')
          .Requerido('Nome e obrigatorio')
          .NaoVazio('Nome nao pode ser vazio')
        .&End
        .Add('cpf', '111.444.777-35')
          .Nullable
          .CPF('CPF invalido')
        .&End
        .Executa
        .VerificaTodosErro;
    end);
end;

procedure TTesteValidadorFluente.Test_IValidadorEIValidadorAdd_TemGUIDsDiferentes;
begin
  // Regressao: IValidador e IValidadorAdd compartilhavam o mesmo GUID em
  // Validador.pas — duas interfaces distintas nao podem ter a mesma identidade.
  // Compara como string pra nao depender de operator overload em TGUID.
  Assert.AreNotEqual(
    GUIDToString(GetTypeData(TypeInfo(IValidador))^.Guid),
    GUIDToString(GetTypeData(TypeInfo(IValidadorAdd))^.Guid));
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidadorFluente);

end.
