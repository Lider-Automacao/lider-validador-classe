unit Teste.Validador.Lista;

interface

uses
  DUnitX.TestFramework,
  System.Generics.Collections,
  Validador.Types,
  Validador.Lista,
  Validador.Base.Schema,
  Validador;

type
  TItemDTO = class
  public
    Nome: string;
  end;

  TSchemaItem = class(TValidacaoSchemaBase<TItemDTO>)
  public
    function MontaValidador: IValidadorAdd; override;
  end;

  [TestFixture]
  TTesteValidacaoLista = class
  published
    [Test]
    procedure Test_Valido_ListaVazia_RetornaTrue;
    [Test]
    procedure Test_Valido_TodosItensValidos_RetornaTrue;
    [Test]
    procedure Test_Valido_AlgumItemInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_ItemInvalido_MensagemContemIndiceEErro;
  end;

implementation

{ TSchemaItem }

function TSchemaItem.MontaValidador: IValidadorAdd;
begin
  Result := TValidador.New
    .Add('nome', FValue.Nome)
      .Requerido('Nome e obrigatorio')
      .NaoVazio('Nome nao pode ser vazio')
    .&End;
end;

{ TTesteValidacaoLista }

procedure TTesteValidacaoLista.Test_Valido_ListaVazia_RetornaTrue;
var
  LValidacaoLista: IValidacao<TObjectList<TItemDTO>>;
  LLista: TObjectList<TItemDTO>;
begin
  LLista := TObjectList<TItemDTO>.Create;
  try
    LValidacaoLista := TValidacaoLista<TItemDTO>.New(TSchemaItem.Create('Item invalido'));
    LValidacaoLista.Valida(LLista);
    Assert.IsTrue(LValidacaoLista.Valido);
  finally
    LLista.Free;
  end;
end;

procedure TTesteValidacaoLista.Test_Valido_TodosItensValidos_RetornaTrue;
var
  LValidacaoLista: IValidacao<TObjectList<TItemDTO>>;
  LLista: TObjectList<TItemDTO>;
  LItem: TItemDTO;
begin
  LLista := TObjectList<TItemDTO>.Create;
  try
    LItem := TItemDTO.Create;
    LItem.Nome := 'Parafuso';
    LLista.Add(LItem);

    LItem := TItemDTO.Create;
    LItem.Nome := 'Porca';
    LLista.Add(LItem);

    LValidacaoLista := TValidacaoLista<TItemDTO>.New(TSchemaItem.Create('Item invalido'));
    LValidacaoLista.Valida(LLista);
    Assert.IsTrue(LValidacaoLista.Valido);
  finally
    LLista.Free;
  end;
end;

procedure TTesteValidacaoLista.Test_Valido_AlgumItemInvalido_RetornaFalse;
var
  LValidacaoLista: IValidacao<TObjectList<TItemDTO>>;
  LLista: TObjectList<TItemDTO>;
  LItem: TItemDTO;
begin
  LLista := TObjectList<TItemDTO>.Create;
  try
    LItem := TItemDTO.Create;
    LItem.Nome := 'Parafuso';
    LLista.Add(LItem);

    LItem := TItemDTO.Create;
    LItem.Nome := '';
    LLista.Add(LItem);

    LValidacaoLista := TValidacaoLista<TItemDTO>.New(TSchemaItem.Create('Item invalido'));
    LValidacaoLista.Valida(LLista);
    Assert.IsFalse(LValidacaoLista.Valido);
  finally
    LLista.Free;
  end;
end;

procedure TTesteValidacaoLista.Test_Valido_ItemInvalido_MensagemContemIndiceEErro;
var
  LValidacaoLista: IValidacao<TObjectList<TItemDTO>>;
  LLista: TObjectList<TItemDTO>;
  LItem: TItemDTO;
begin
  LLista := TObjectList<TItemDTO>.Create;
  try
    LItem := TItemDTO.Create;
    LItem.Nome := '';
    LLista.Add(LItem);

    LValidacaoLista := TValidacaoLista<TItemDTO>.New(TSchemaItem.Create('Item invalido'));
    LValidacaoLista.Valida(LLista);
    LValidacaoLista.Valido;
    Assert.Contains(LValidacaoLista.Mensagem, 'index');
    Assert.Contains(LValidacaoLista.Mensagem, 'nome');
  finally
    LLista.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteValidacaoLista);

end.
