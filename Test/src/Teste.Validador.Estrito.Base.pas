unit Teste.Validador.Estrito.Base;

interface

uses
  DUnitX.TestFramework,
  Validador.Types,
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaTeste = class(TValidacaoEstritaBase<Integer>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
  end;

  [TestFixture]
  TTesteValidacaoEstritaBase = class
  published
    [Test]
    procedure Test_Create_MensagemVazia_LancaExcecao;
    [Test]
    procedure Test_Propriedade_DevolveValorAtribuido;
    [Test]
    procedure Test_Mensagem_SemOverride_DevolveMensagemDoConstrutor;
    [Test]
    procedure Test_Mensagem_ComOverrideNaoVazio_Sobrescreve;
    [Test]
    procedure Test_VerificaErro_ValidoFalso_LancaTValidadorException;
    [Test]
    procedure Test_VerificaErro_ValidoTrue_NaoLanca;
  end;

implementation

uses
  System.SysUtils;

constructor TValidacaoEstritaTeste.Create;
begin
  inherited Create('mensagem padrao');
end;

function TValidacaoEstritaTeste.Valido: Boolean;
begin
  Result := FValue.HasValue and (FValue.Value > 0);
end;

procedure TTesteValidacaoEstritaBase.Test_Create_MensagemVazia_LancaExcecao;
begin
  Assert.WillRaise(
    procedure
    begin
      TValidacaoEstritaBase<Integer>.Create('');
    end, Exception);
end;

procedure TTesteValidacaoEstritaBase.Test_Propriedade_DevolveValorAtribuido;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaTeste.Create;
  LValidacao.Propriedade('idade');
  Assert.AreEqual('idade', LValidacao.Propriedade);
end;

procedure TTesteValidacaoEstritaBase.Test_Mensagem_SemOverride_DevolveMensagemDoConstrutor;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaTeste.Create;
  Assert.AreEqual('mensagem padrao', LValidacao.Mensagem);
end;

procedure TTesteValidacaoEstritaBase.Test_Mensagem_ComOverrideNaoVazio_Sobrescreve;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaTeste.Create;
  LValidacao.Mensagem('mensagem customizada');
  Assert.AreEqual('mensagem customizada', LValidacao.Mensagem);
end;

procedure TTesteValidacaoEstritaBase.Test_VerificaErro_ValidoFalso_LancaTValidadorException;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaTeste.Create;
  LValidacao.Valida(TNullable<Integer>.Empty);
  Assert.WillRaise(
    procedure
    begin
      LValidacao.VerificaErro;
    end, TValidadorException);
end;

procedure TTesteValidacaoEstritaBase.Test_VerificaErro_ValidoTrue_NaoLanca;
var
  LValidacao: IValidacaoEstrita<Integer>;
begin
  LValidacao := TValidacaoEstritaTeste.Create;
  LValidacao.Valida(TNullable<Integer>.Create(5));
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.VerificaErro;
    end);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoEstritaBase);

end.
