unit Teste.Validador.Types;

interface

uses
  DUnitX.TestFramework,
  Validador.Types,
  Validador.Vazio;

type
  [TestFixture]
  TTesteExecutorValidador = class
  published
    [Test]
    procedure Test_Valido_TodasValidacoesPassam_RetornaTrue;
    [Test]
    procedure Test_Valido_AlgumaValidacaoFalha_RetornaFalse;
    [Test]
    procedure Test_Errors_TodasValidas_RetornaVazio;
    [Test]
    procedure Test_Errors_ValidacaoFalha_RetornaJsonComCampoEMensagem;
    [Test]
    procedure Test_VerificaErro_ValidacaoFalha_LancaTValidadorException;
    [Test]
    procedure Test_VerificaTodosErro_TodasValidas_NaoLancaExcecao;
    [Test]
    procedure Test_VerificaTodosErro_VariasFalhas_LancaComTodosOsErros;
    [Test]
    procedure Test_Errors_MensagemContemPalavraNull_NaoEhRemovida;
  end;

implementation

uses
  System.SysUtils;

procedure TTesteExecutorValidador.Test_Valido_TodasValidacoesPassam_RetornaTrue;
var
  LExecutor: IExecutorValidador;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome').Valida('lider'));
  Assert.IsTrue(LExecutor.Valido);
end;

procedure TTesteExecutorValidador.Test_Valido_AlgumaValidacaoFalha_RetornaFalse;
var
  LExecutor: IExecutorValidador;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome').Requerido(True).Valida(''));
  Assert.IsFalse(LExecutor.Valido);
end;

procedure TTesteExecutorValidador.Test_Errors_TodasValidas_RetornaVazio;
var
  LExecutor: IExecutorValidador;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome').Valida('lider'));
  Assert.AreEqual('', LExecutor.Errors);
end;

procedure TTesteExecutorValidador.Test_Errors_ValidacaoFalha_RetornaJsonComCampoEMensagem;
var
  LExecutor: IExecutorValidador;
  LErrors: string;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome')
    .Mensagem('Nome e obrigatorio').Requerido(True).Valida(''));
  LErrors := LExecutor.Errors;
  Assert.Contains(LErrors, 'nome');
  Assert.Contains(LErrors, 'Nome e obrigatorio');
end;

procedure TTesteExecutorValidador.Test_VerificaErro_ValidacaoFalha_LancaTValidadorException;
var
  LExecutor: IExecutorValidador;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome').Requerido(True).Valida(''));
  Assert.WillRaise(
    procedure
    begin
      LExecutor.VerificaErro;
    end, TValidadorException);
end;

procedure TTesteExecutorValidador.Test_VerificaTodosErro_TodasValidas_NaoLancaExcecao;
var
  LExecutor: IExecutorValidador;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome').Valida('lider'));
  Assert.WillNotRaise(
    procedure
    begin
      LExecutor.VerificaTodosErro;
    end);
end;

procedure TTesteExecutorValidador.Test_VerificaTodosErro_VariasFalhas_LancaComTodosOsErros;
var
  LExecutor: IExecutorValidador;
  LMensagem: string;
begin
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('nome')
    .Mensagem('Nome e obrigatorio').Requerido(True).Valida(''));
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('email')
    .Mensagem('Email e obrigatorio').Requerido(True).Valida(''));

  LMensagem := '';
  try
    LExecutor.VerificaTodosErro;
    Assert.Fail('Esperava TValidadorException com os dois erros agregados');
  except
    on E: TValidadorException do
      LMensagem := E.Message;
  end;

  Assert.Contains(LMensagem, 'nome');
  Assert.Contains(LMensagem, 'email');
end;

procedure TTesteExecutorValidador.Test_Errors_MensagemContemPalavraNull_NaoEhRemovida;
var
  LExecutor: IExecutorValidador;
  LErrors: string;
begin
  // Regressao: Errors() usava .Replace('null','') pra limpar um artefato
  // do TJsonTextWriter — isso quebrava qualquer mensagem customizada que
  // contivesse a palavra "null" de verdade. Agora usa TJSONObject/TJSONArray
  // (System.JSON), sem replace pos-hoc.
  LExecutor := TExecutorValidador.New;
  LExecutor.Add(TValidacaoNaoEstaVazio.New.Propriedade('campo')
    .Mensagem('Campo nao pode ser null').Requerido(True).Valida(''));
  LErrors := LExecutor.Errors;
  Assert.Contains(LErrors, 'Campo nao pode ser null');
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteExecutorValidador);

end.
