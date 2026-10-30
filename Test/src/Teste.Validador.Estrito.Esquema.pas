unit Teste.Validador.Estrito.Esquema;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  Validador.Estrito.Types,
  Validador.Estrito.Strings,
  Validador.Estrito.Double,
  Validador.Estrito.Esquema;

type
  TEnderecoTeste = class
  public
    Rua: string;
    Numero: Double;
  end;

  TItemTeste = class
  public
    Codigo: string;
  end;

  TPessoaTeste = class
  public
    Nome: string;
    Idade: Double;
    Endereco: TEnderecoTeste;
    Itens: TArray<TItemTeste>;
  end;

  [TestFixture]
  TTesteEsquema = class
  strict private
    FPessoa: TPessoaTeste;
    function EsquemaEndereco: IEsquema<TEnderecoTeste>;
    function EsquemaItem: IEsquema<TItemTeste>;
    function EsquemaPessoa: IEsquema<TPessoaTeste>;
    function EsquemaSimples: IEsquema<TPessoaTeste>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test_Valida_ObjetoCorreto_RetornaValido;
    [Test]
    procedure Test_Valida_VariosCamposInvalidos_RetornaTodosOsErros;
    [Test]
    procedure Test_Valida_CampoInvalido_UsaNomeDoCampoComoCaminho;
    [Test]
    procedure Test_Valida_ObjetoAninhadoInvalido_UsaCaminhoComPonto;
    [Test]
    procedure Test_Valida_ObjetoAninhadoNil_NaoGeraErro;
    [Test]
    procedure Test_Valida_ListaComItemInvalido_UsaCaminhoComIndice;
    [Test]
    procedure Test_Valida_ListaVazia_NaoGeraErro;
    [Test]
    procedure Test_ComoJson_ObjetoCorreto_RetornaVazio;
    [Test]
    procedure Test_ComoJson_ComErros_RetornaFormatoDoLegado;
    [Test]
    procedure Test_VerificaErro_ObjetoCorreto_NaoLevantaExcecao;
    [Test]
    procedure Test_VerificaErro_ComErros_LevantaExcecaoComJson;
    [Test]
    procedure Test_Valida_MesmoEsquemaDuasVezes_NaoCarregaEstado;
    [Test]
    procedure Test_CampoSimples_ObjetoCorreto_RetornaValido;
    [Test]
    procedure Test_CampoSimples_VariosCamposInvalidos_RetornaTodosOsErros;
    [Test]
    procedure Test_CampoSimples_CampoInvalido_UsaNomeDoCampoComoCaminho;
  end;

implementation

const
  C_JSON_NOME_E_IDADE =
    '[{"field":"nome","error":"Nome obrigat\u00F3rio"},{"field":"idade","error":"Idade inv\u00E1lida"}]';

function TextoObrigatorio: IValidadorString;
begin
  Result := TValidadorString.New.Requerido('Nome obrigatório').NaoVazio('Nome obrigatório');
end;

function IdadeValida: IValidadorDouble;
begin
  Result := TValidadorDouble.New.Requerido.Entre(0, 120, 'Idade inválida');
end;

function TTesteEsquema.EsquemaSimples: IEsquema<TPessoaTeste>;
begin
  Result := TEsquema<TPessoaTeste>.New
    .CampoTexto('nome',
      function(APessoa: TPessoaTeste): string
      begin
        Result := APessoa.Nome;
      end, TextoObrigatorio)
    .CampoReal('idade',
      function(APessoa: TPessoaTeste): Double
      begin
        Result := APessoa.Idade;
      end, IdadeValida);
end;

function TTesteEsquema.EsquemaEndereco:IEsquema<TEnderecoTeste>;
begin
  Result := TEsquema<TEnderecoTeste>.New
    .Campo('rua',
      function(AEndereco: TEnderecoTeste): TNullable<string>
      begin
        Result := AEndereco.Rua;
      end,
      function: IValidadorString
      begin
        Result := TValidadorString.New.Requerido('Rua obrigatória').NaoVazio('Rua obrigatória');
      end)
    .Campo('numero',
      function(AEndereco: TEnderecoTeste): TNullable<Double>
      begin
        Result := AEndereco.Numero;
      end,
      function: IValidadorDouble
      begin
        Result := TValidadorDouble.New.Requerido.MaiorQue(0, 'Número inválido');
      end);
end;

function TTesteEsquema.EsquemaItem: IEsquema<TItemTeste>;
begin
  Result := TEsquema<TItemTeste>.New
    .Campo('codigo',
      function(AItem: TItemTeste): TNullable<string>
      begin
        Result := AItem.Codigo;
      end,
      function: IValidadorString
      begin
        Result := TValidadorString.New.Requerido('Código obrigatório').NaoVazio('Código obrigatório');
      end);
end;

function TTesteEsquema.EsquemaPessoa: IEsquema<TPessoaTeste>;
begin
  Result := TEsquema<TPessoaTeste>.New
    .Campo('nome',
      function(APessoa: TPessoaTeste): TNullable<string>
      begin
        Result := APessoa.Nome;
      end,
      function: IValidadorString
      begin
        Result := TValidadorString.New.Requerido('Nome obrigatório').NaoVazio('Nome obrigatório');
      end)
    .Campo('idade',
      function(APessoa: TPessoaTeste): TNullable<Double>
      begin
        Result := APessoa.Idade;
      end,
      function: IValidadorDouble
      begin
        Result := TValidadorDouble.New.Requerido.Entre(0, 120, 'Idade inválida');
      end)
    .Regra(TCampoObjeto<TPessoaTeste, TEnderecoTeste>.New('endereco',
      function(APessoa: TPessoaTeste): TEnderecoTeste
      begin
        Result := APessoa.Endereco;
      end,
      EsquemaEndereco))
    .Regra(TCampoLista<TPessoaTeste, TItemTeste>.New('itens',
      function(APessoa: TPessoaTeste): TArray<TItemTeste>
      begin
        Result := APessoa.Itens;
      end,
      EsquemaItem));
end;

procedure TTesteEsquema.Setup;
begin
  FPessoa := TPessoaTeste.Create;
  FPessoa.Nome := 'Maria';
  FPessoa.Idade := 30;
end;

procedure TTesteEsquema.TearDown;
var
  LItem: TItemTeste;
begin
  for LItem in FPessoa.Itens do
    LItem.Free;
  FPessoa.Endereco.Free;
  FPessoa.Free;
end;

procedure TTesteEsquema.Test_Valida_ObjetoCorreto_RetornaValido;
begin
  Assert.IsTrue(EsquemaPessoa.Valida(FPessoa).Valido);
end;

procedure TTesteEsquema.Test_Valida_VariosCamposInvalidos_RetornaTodosOsErros;
begin
  FPessoa.Nome := '';
  FPessoa.Idade := 200;
  Assert.AreEqual(2, Length(EsquemaPessoa.Valida(FPessoa).Erros));
end;

procedure TTesteEsquema.Test_Valida_CampoInvalido_UsaNomeDoCampoComoCaminho;
begin
  FPessoa.Nome := '';
  Assert.AreEqual('nome', EsquemaPessoa.Valida(FPessoa).Erros[0].Caminho);
end;

procedure TTesteEsquema.Test_Valida_ObjetoAninhadoInvalido_UsaCaminhoComPonto;
begin
  FPessoa.Endereco := TEnderecoTeste.Create;
  FPessoa.Endereco.Rua := 'Rua A';
  FPessoa.Endereco.Numero := 0;
  Assert.AreEqual('endereco.numero', EsquemaPessoa.Valida(FPessoa).Erros[0].Caminho);
end;

procedure TTesteEsquema.Test_Valida_ObjetoAninhadoNil_NaoGeraErro;
begin
  FPessoa.Endereco := nil;
  Assert.IsTrue(EsquemaPessoa.Valida(FPessoa).Valido);
end;

procedure TTesteEsquema.Test_Valida_ListaComItemInvalido_UsaCaminhoComIndice;
begin
  SetLength(FPessoa.Itens, 2);
  FPessoa.Itens[0] := TItemTeste.Create;
  FPessoa.Itens[0].Codigo := '10';
  FPessoa.Itens[1] := TItemTeste.Create;
  FPessoa.Itens[1].Codigo := '';
  Assert.AreEqual('itens[1].codigo', EsquemaPessoa.Valida(FPessoa).Erros[0].Caminho);
end;

procedure TTesteEsquema.Test_Valida_ListaVazia_NaoGeraErro;
begin
  SetLength(FPessoa.Itens, 0);
  Assert.IsTrue(EsquemaPessoa.Valida(FPessoa).Valido);
end;

procedure TTesteEsquema.Test_ComoJson_ObjetoCorreto_RetornaVazio;
begin
  Assert.AreEqual('', EsquemaPessoa.Valida(FPessoa).ComoJson);
end;

procedure TTesteEsquema.Test_ComoJson_ComErros_RetornaFormatoDoLegado;
begin
  FPessoa.Nome := '';
  FPessoa.Idade := 200;
  Assert.AreEqual(C_JSON_NOME_E_IDADE, EsquemaPessoa.Valida(FPessoa).ComoJson);
end;

procedure TTesteEsquema.Test_VerificaErro_ObjetoCorreto_NaoLevantaExcecao;
begin
  Assert.WillNotRaise(
    procedure
    begin
      EsquemaPessoa.Valida(FPessoa).VerificaErro;
    end);
end;

procedure TTesteEsquema.Test_VerificaErro_ComErros_LevantaExcecaoComJson;
begin
  FPessoa.Nome := '';
  FPessoa.Idade := 200;
  Assert.WillRaiseWithMessage(
    procedure
    begin
      EsquemaPessoa.Valida(FPessoa).VerificaErro;
    end,
    EValidadorEsquema,
    C_JSON_NOME_E_IDADE);
end;

procedure TTesteEsquema.Test_Valida_MesmoEsquemaDuasVezes_NaoCarregaEstado;
var
  LEsquema: IEsquema<TPessoaTeste>;
begin
  LEsquema := EsquemaPessoa;
  FPessoa.Nome := '';
  LEsquema.Valida(FPessoa);
  FPessoa.Nome := 'Maria';
  Assert.IsTrue(LEsquema.Valida(FPessoa).Valido);
end;

procedure TTesteEsquema.Test_CampoSimples_ObjetoCorreto_RetornaValido;
begin
  Assert.IsTrue(EsquemaSimples.Valida(FPessoa).Valido);
end;

procedure TTesteEsquema.Test_CampoSimples_VariosCamposInvalidos_RetornaTodosOsErros;
begin
  FPessoa.Nome := '';
  FPessoa.Idade := 200;
  Assert.AreEqual(C_JSON_NOME_E_IDADE, EsquemaSimples.Valida(FPessoa).ComoJson);
end;

procedure TTesteEsquema.Test_CampoSimples_CampoInvalido_UsaNomeDoCampoComoCaminho;
begin
  FPessoa.Idade := -1;
  Assert.AreEqual('idade', EsquemaSimples.Valida(FPessoa).Erros[0].Caminho);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteEsquema);

end.
