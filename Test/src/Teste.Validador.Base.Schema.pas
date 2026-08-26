unit Teste.Validador.Base.Schema;

interface

uses
  DUnitX.TestFramework,
  Validador.Types,
  Validador.Base.Schema,
  Validador,
  Validador.Base;

type
  TEnderecoDTO = class
  public
    Rua: string;
  end;

  TSchemaEndereco = class(TValidacaoSchemaBase<TEnderecoDTO>)
  public
    function MontaValidador: IValidadorAdd; override;
  end;

  [TestFixture]
  TTesteValidacaoSchemaBase = class
  published
    [Test]
    procedure Test_Valido_ObjetoComRuaPreenchida_RetornaTrue;
    [Test]
    procedure Test_Valido_ObjetoComRuaVazia_RetornaFalse;
    [Test]
    procedure Test_Valido_ObjetoInvalido_MensagemContemErroDoCampo;
  end;

implementation

uses
  System.SysUtils;

{ TSchemaEndereco }

function TSchemaEndereco.MontaValidador: IValidadorAdd;
begin
  Result := TValidador.New
    .Add('rua', FValue.Rua)
      .Requerido('Rua e obrigatoria')
      .NaoVazio('Rua nao pode ser vazia')
    .&End;
end;

{ TTesteValidacaoSchemaBase }

procedure TTesteValidacaoSchemaBase.Test_Valido_ObjetoComRuaPreenchida_RetornaTrue;
var
  LSchema: IValidacao<TEnderecoDTO>;
  LEndereco: TEnderecoDTO;
begin
  // LSchema e interface (nao classe concreta): TSchemaEndereco herda de
  // TInterfacedObject, entao gerenciar o ciclo de vida manualmente com
  // .Free junto de chamadas que tiram referencia de interface (.Valida)
  // causa destruicao prematura por refcount — deixe a interface cuidar disso.
  LEndereco := TEnderecoDTO.Create;
  try
    LEndereco.Rua := 'Av. Brasil, 100';
    LSchema := TSchemaEndereco.Create('Endereco invalido');
    LSchema.Valida(LEndereco);
    Assert.IsTrue(LSchema.Valido);
  finally
    LEndereco.Free;
  end;
end;

procedure TTesteValidacaoSchemaBase.Test_Valido_ObjetoComRuaVazia_RetornaFalse;
var
  LSchema: IValidacao<TEnderecoDTO>;
  LEndereco: TEnderecoDTO;
begin
  LEndereco := TEnderecoDTO.Create;
  try
    LEndereco.Rua := '';
    LSchema := TSchemaEndereco.Create('Endereco invalido');
    LSchema.Valida(LEndereco);
    Assert.IsFalse(LSchema.Valido);
  finally
    LEndereco.Free;
  end;
end;

procedure TTesteValidacaoSchemaBase.Test_Valido_ObjetoInvalido_MensagemContemErroDoCampo;
var
  LSchema: IValidacao<TEnderecoDTO>;
  LEndereco: TEnderecoDTO;
begin
  LEndereco := TEnderecoDTO.Create;
  try
    LEndereco.Rua := '';
    LSchema := TSchemaEndereco.Create('Endereco invalido');
    LSchema.Valida(LEndereco);
    LSchema.Valido;
    Assert.Contains(LSchema.Mensagem, 'rua');
  finally
    LEndereco.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoSchemaBase);

end.
