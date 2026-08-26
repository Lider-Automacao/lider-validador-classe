unit Teste.Validador.Enum;

interface

uses
  DUnitX.TestFramework,
  Variants,
  Validador.Types,
  Validador.Enum;

type
  [TestFixture]
  TTesteValidacaoEnum = class
  published
    [Test]
    procedure Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
    [Test]
    procedure Test_Valido_ValorContidoNoEnum_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorForaDoEnum_RetornaFalse;
    [Test]
    procedure Test_Valido_Requerido_ValorVazio_RetornaTrue_BugConhecido;
  end;

implementation

function Enum: TEnumValues;
begin
  Result := ['ATIVO', 'INATIVO', 'PENDENTE'];
end;

procedure TTesteValidacaoEnum.Test_Valido_NaoRequerido_ValorNull_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEnum.New(Enum).Requerido(False);
  LValidacao.Valida(Null);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEnum.Test_Valido_Requerido_ValorNull_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEnum.New(Enum).Requerido(True);
  LValidacao.Valida(Null);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEnum.Test_Valido_Requerido_ValorNull_NaoLancaExcecao;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEnum.New(Enum).Requerido(True);
  Assert.WillNotRaise(
    procedure
    begin
      LValidacao.Valida(Null);
      LValidacao.Valido;
    end);
end;

procedure TTesteValidacaoEnum.Test_Valido_ValorContidoNoEnum_RetornaTrue;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEnum.New(Enum).Valida('ATIVO');
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteValidacaoEnum.Test_Valido_ValorForaDoEnum_RetornaFalse;
var
  LValidacao: IValidacao<Variant>;
begin
  LValidacao := TValidacaoEnum.New(Enum).Valida('CANCELADO');
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteValidacaoEnum.Test_Valido_Requerido_ValorVazio_RetornaTrue_BugConhecido;
var
  LValidacao: IValidacao<Variant>;
begin
  // Caracteriza o bug do Laudo §6 "Enum obrigatorio aceita vazio":
  // TValicaoEnum.Valido ignora FRequerido pra string vazia. Nao corrigido
  // nesta rodada (fora do escopo das correcoes imediatas). Se corrigirem,
  // este teste deve passar a esperar Valido = False.
  LValidacao := TValidacaoEnum.New(Enum).Requerido(True).Valida('');
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoEnum);

end.
