unit Teste.Validador.Estrito.Objeto;

interface

uses
  DUnitX.TestFramework,
  Validador.Estrito.Types,
  Validador.Estrito.Objeto;

type
  TClienteDTO = class
  public
    Nome: string;
  end;

  [TestFixture]
  TTesteEstritaObjeto = class
  published
    [Test]
    procedure Test_Valido_PredicadoTrue_RetornaTrue;
    [Test]
    procedure Test_Valido_PredicadoFalse_RetornaFalse;
    [Test]
    procedure Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
    [Test]
    procedure Test_Valido_ValorAusente_Requerido_RetornaFalse;
  end;

  [TestFixture]
  TTesteEstritaLista = class
  published
    [Test]
    procedure Test_Valido_TodosItensValidos_RetornaTrue;
    [Test]
    procedure Test_Valido_AlgumItemInvalido_RetornaFalse;
    [Test]
    procedure Test_Valido_ItemInvalido_MensagemContemIndice;
    [Test]
    procedure Test_Valido_ListaVazia_RetornaTrue;
  end;

implementation

function ValidadorDeCliente: IValidacaoEstrita<TClienteDTO>;
begin
  Result := TValidacaoEstritaObjeto<TClienteDTO>.New(
    function(aCliente: TClienteDTO): Boolean
    begin
      Result := (aCliente <> nil) and (Trim(aCliente.Nome) <> '');
    end,
    'Cliente inválido');
end;

procedure TTesteEstritaObjeto.Test_Valido_PredicadoTrue_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<TClienteDTO>;
  LCliente: TClienteDTO;
begin
  LCliente := TClienteDTO.Create;
  try
    LCliente.Nome := 'Lider';
    LValidacao := ValidadorDeCliente;
    LValidacao.Valida(LCliente);
    Assert.IsTrue(LValidacao.Valido);
  finally
    LCliente.Free;
  end;
end;

procedure TTesteEstritaObjeto.Test_Valido_PredicadoFalse_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<TClienteDTO>;
  LCliente: TClienteDTO;
begin
  LCliente := TClienteDTO.Create;
  try
    LCliente.Nome := '';
    LValidacao := ValidadorDeCliente;
    LValidacao.Valida(LCliente);
    Assert.IsFalse(LValidacao.Valido);
  finally
    LCliente.Free;
  end;
end;

procedure TTesteEstritaObjeto.Test_Valido_ValorAusente_NaoRequerido_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<TClienteDTO>;
begin
  LValidacao := ValidadorDeCliente.Requerido(False);
  LValidacao.Valida(TNullable<TClienteDTO>.Empty);
  Assert.IsTrue(LValidacao.Valido);
end;

procedure TTesteEstritaObjeto.Test_Valido_ValorAusente_Requerido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<TClienteDTO>;
begin
  LValidacao := ValidadorDeCliente.Requerido(True);
  LValidacao.Valida(TNullable<TClienteDTO>.Empty);
  Assert.IsFalse(LValidacao.Valido);
end;

procedure TTesteEstritaLista.Test_Valido_TodosItensValidos_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<TArray<TClienteDTO>>;
  LItens: TArray<TClienteDTO>;
  LCliente1, LCliente2: TClienteDTO;
begin
  LCliente1 := TClienteDTO.Create;
  LCliente1.Nome := 'Parafuso';
  LCliente2 := TClienteDTO.Create;
  LCliente2.Nome := 'Porca';
  LItens := [LCliente1, LCliente2];
  try
    LValidacao := TValidacaoEstritaLista<TClienteDTO>.New(ValidadorDeCliente);
    LValidacao.Valida(LItens);
    Assert.IsTrue(LValidacao.Valido);
  finally
    LCliente1.Free;
    LCliente2.Free;
  end;
end;

procedure TTesteEstritaLista.Test_Valido_AlgumItemInvalido_RetornaFalse;
var
  LValidacao: IValidacaoEstrita<TArray<TClienteDTO>>;
  LItens: TArray<TClienteDTO>;
  LCliente1, LCliente2: TClienteDTO;
begin
  LCliente1 := TClienteDTO.Create;
  LCliente1.Nome := 'Parafuso';
  LCliente2 := TClienteDTO.Create;
  LCliente2.Nome := '';
  LItens := [LCliente1, LCliente2];
  try
    LValidacao := TValidacaoEstritaLista<TClienteDTO>.New(ValidadorDeCliente);
    LValidacao.Valida(LItens);
    Assert.IsFalse(LValidacao.Valido);
  finally
    LCliente1.Free;
    LCliente2.Free;
  end;
end;

procedure TTesteEstritaLista.Test_Valido_ItemInvalido_MensagemContemIndice;
var
  LValidacao: IValidacaoEstrita<TArray<TClienteDTO>>;
  LItens: TArray<TClienteDTO>;
  LCliente: TClienteDTO;
begin
  LCliente := TClienteDTO.Create;
  LCliente.Nome := '';
  LItens := [LCliente];
  try
    LValidacao := TValidacaoEstritaLista<TClienteDTO>.New(ValidadorDeCliente);
    LValidacao.Valida(LItens);
    LValidacao.Valido;
    Assert.Contains(LValidacao.Mensagem, 'item 0');
  finally
    LCliente.Free;
  end;
end;

procedure TTesteEstritaLista.Test_Valido_ListaVazia_RetornaTrue;
var
  LValidacao: IValidacaoEstrita<TArray<TClienteDTO>>;
  LItensVazios: TArray<TClienteDTO>;
begin
  LValidacao := TValidacaoEstritaLista<TClienteDTO>.New(ValidadorDeCliente);
  LValidacao.Valida(LItensVazios);
  Assert.IsTrue(LValidacao.Valido);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEstritaObjeto);
  TDUnitX.RegisterTestFixture(TTesteEstritaLista);

end.
