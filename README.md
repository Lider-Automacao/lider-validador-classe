# lider-validador-classe

Biblioteca de validação fluente para Object Pascal / Delphi. Encadeia
regras de validação por campo e agrega os erros — de um único `Boolean`
até um JSON estruturado pronto pra resposta de API.

```pascal
TValidador.New
  .Add('nome', pDto.Nome)
    .Requerido('Nome é obrigatório')
    .NaoVazio('Nome não pode ser vazio')
  .&End
  .Add('cpf', pDto.CPF)
    .Nullable
    .CPF('CPF inválido')
  .&End
  .Executa
  .VerificaTodosErro; // levanta TValidadorException se algo falhar
```

## Instalação

Via [Boss](https://github.com/HashLoad/boss) (`boss.json` já configurado neste
repositório):

```
boss install github.com/<org>/lider-validador-classe
```

**Atenção:** o código-fonte vive em duas pastas (`src/Legado/` e
`src/Estrito/`, ver seção "Duas trilhas" abaixo). `boss.json`'s `mainsrc`
só aceita **um** caminho e o search path do Delphi não é recursivo, então
o `boss install` sozinho não resolve as duas pastas — depois de instalar,
adicione **as duas** manualmente em **Project > Options > Search Path**
do seu projeto:

```
modules\lider-validador-classe\src\Legado
modules\lider-validador-classe\src\Estrito
```

(ajuste o caminho base conforme onde o Boss instalou o pacote no seu
projeto).

## Duas trilhas

- **`Legado/`** — a API `Variant`-based original (exemplos abaixo). Ainda
  funciona, mas está `deprecated` — remoção planejada pra v2.0.
- **`Estrito/`** — API nova, sem `Variant`, com segurança de tipo checada
  em compile-time (`TValidadorString`, `TValidadorInteiro`,
  `TValidadorInt64`, `TValidadorDouble`, `TValidadorData`). Recomendada
  pra código novo. Exemplo:

  ```pascal
  uses
    Validador.Estrito.Strings;

  if not TValidadorString.New.Requerido.CPF.Valida(pDto.CPF).Valido then
    raise Exception.Create('CPF inválido');
  ```

  Cada validador estrito valida **um valor por vez**. Para validar um
  objeto inteiro e receber todos os erros de uma vez, use o esquema
  (próxima seção). Design completo em
  `docs/superpowers/specs/2026-08-26-trilha-estrita-design.md`.

### Esquema de objeto (`Validador.Estrito.Esquema`)

Descreve a forma do objeto uma vez e devolve todos os erros, cada um com o
caminho do campo (comportamento parecido com o zod). O esquema é montado uma
vez e pode ser reutilizado; o validador de cada campo entra como fábrica
porque os validadores estritos guardam o valor entre `Valida` e `Valido`.

```pascal
uses
  Validador.Estrito.Types,
  Validador.Estrito.Strings,
  Validador.Estrito.Double,
  Validador.Estrito.Esquema;

LEsquema := TEsquema<TPessoa>.New
  .Campo('nome',
    function(APessoa: TPessoa): TNullable<string>
    begin
      Result := APessoa.Nome;
    end,
    function: IValidadorString
    begin
      Result := TValidadorString.New.Requerido('Nome obrigatório').NaoVazio('Nome obrigatório');
    end)
  .Regra(TCampoObjeto<TPessoa, TEndereco>.New('endereco',
    function(APessoa: TPessoa): TEndereco
    begin
      Result := APessoa.Endereco;
    end,
    LEsquemaEndereco))
  .Regra(TCampoLista<TPessoa, TItem>.New('itens',
    function(APessoa: TPessoa): TArray<TItem>
    begin
      Result := APessoa.Itens;
    end,
    LEsquemaItem));

LResultado := LEsquema.Valida(LPessoa);
if not LResultado.Valido then
  LResultado.VerificaErro; // EValidadorEsquema, mensagem = JSON de erros
```

Para propriedades que nunca são nulas, `CampoTexto`, `CampoReal`, `CampoInteiro`,
`CampoInt64` e `CampoData` aceitam o leitor com o tipo simples, e a fábrica pode
ser uma função global reaproveitada em vários campos:

```pascal
function NomeObrigatorio: IValidadorString;
begin
  Result := TValidadorString.New.Requerido('Nome obrigatório').NaoVazio('Nome obrigatório');
end;

LEsquema := TEsquema<TPessoa>.New
  .CampoTexto('nome',
    function(APessoa: TPessoa): string
    begin
      Result := APessoa.Nome;
    end, NomeObrigatorio);
```

- `Erros` devolve `TArray<TErroCampo>` (`Caminho`, `Mensagem`), com caminhos
  como `endereco.numero` e `itens[1].codigo`.
- `ComoJson` devolve `[{"field":"...","error":"..."}]`, o mesmo formato do
  `Errors` do legado, e texto vazio quando válido.
- Campos aceitos em `Campo`: texto, `Double`, `Integer`, `Int64` e
  `TDateTime`. Objeto aninhado e lista entram por `Regra`.
- Objeto aninhado `nil` e lista vazia não geram erro.

## Uso básico (trilha legada)

Toda validação começa em `TValidador.New`, encadeia `.Add(propriedade, valor)`
e uma ou mais regras, e fecha o campo com `.&End`. Depois de `.End`, o
`Add` seguinte abre o próximo campo.

```pascal
uses
  Validador;

var
  LValidador: IExecutorValidador;
begin
  LValidador := TValidador.New
    .Add('email', pDto.Email)
      .Requerido('E-mail é obrigatório')
      .Email('E-mail inválido')
    .&End
    .Add('idade', pDto.Idade)
      .Nullable
      .Entre(18, 120, 'Idade deve estar entre 18 e 120')
    .&End
    .Executa;

  if not LValidador.Valido then
    // LValidador.Errors retorna o JSON de erros (ver secao abaixo)
    raise TValidadorException.Create(LValidador.Errors);
end;
```

`Requerido` marca o campo como obrigatório (reprova `Null`/ausente).
`Nullable` marca como opcional (o padrão) — nesse caso as demais regras só
são aplicadas quando o campo de fato tem valor.

## Regras disponíveis

| Método | Regra |
|---|---|
| `Vazio` / `NaoVazio` | string vazia (após `Trim`) ou não |
| `Enum(aEnum: TEnumValues)` | valor precisa estar num array de strings permitidas |
| `MaiorQue` / `MaiorQueOuIgual` | comparação numérica (ou de comprimento, se string) |
| `MenorQue` / `MenorQueOuIgual` | comparação numérica (ou de comprimento, se string) |
| `Entre(aMinimo, aMaximo)` | valor dentro de um intervalo numérico, inclusive |
| `Igual(aComparacao)` | igualdade (ou comprimento de string == número) |
| `Regex(aRegex)` | casa contra um padrão arbitrário |
| `DataString` | data em texto (`dd/mm/yyyy`, `dd-mm-yyyy` ou `dd.mm.yyyy`) — valida formato **e** calendário real (`31/02` reprova) |
| `CPF` / `CNPJ` | dígito verificador — CNPJ já suporta o formato alfanumérico do rollout Receita Federal 2026 |
| `Email` | formato de e-mail |
| `Url` | URL com ou sem protocolo |
| `Telefone` / `Celular` | telefone fixo (DDD + 8 dígitos) ou celular (DDD + 9 dígitos, com o 9 líder) |
| `CEP` | CEP brasileiro (`00000-000` ou `00000000`) |
| `TamanhoMinimo(n)` / `TamanhoMaximo(n)` | comprimento mínimo/máximo de string |
| `Igual(aComparacao)` (`IValidadorString`) | texto igual ao comparado, ignorando espaços nas pontas |
| `Personalizada(aValidacao)` | injeta qualquer `IValidacaoBase` próprio na cadeia |

Todo método aceita uma mensagem customizada opcional; sem ela, cada regra
usa uma mensagem padrão em pt-BR.

## Schema aninhado

Pra validar um objeto complexo (não só campos primitivos), crie uma
subclasse de `TValidacaoSchemaBase<T>` que monta seu próprio `TValidador`
a partir dos campos de `T`:

```pascal
type
  TSchemaEndereco = class(TValidacaoSchemaBase<TEndereco>)
  public
    function MontaValidador: IValidadorAdd; override;
  end;

function TSchemaEndereco.MontaValidador: IValidadorAdd;
begin
  Result := TValidador.New
    .Add('rua', FValue.Rua)
      .Requerido('Rua é obrigatória')
      .NaoVazio('Rua não pode ser vazia')
    .&End;
end;
```

Uso: `TSchemaEndereco.Create('Endereço inválido').Valida(LEndereco).Valido`.
Se inválido, `.Mensagem` traz o JSON de erros dos campos internos.

## Lista de objetos

`TValidacaoLista<T>` valida cada item de uma `TObjectList<T>` reaproveitando
um validador de item (tipicamente um `TValidacaoSchemaBase<T>`), agregando
os erros por índice:

```pascal
TValidacaoLista<TEndereco>.New(TSchemaEndereco.Create('Endereço inválido'))
  .Valida(LListaDeEnderecos)
  .Valido;
```

## Saída de erros (`Errors`)

`IExecutorValidador.Errors` devolve um JSON (array) com um objeto por
campo/índice que falhou — pronto pra virar corpo de resposta HTTP:

```json
[
  { "field": "email", "error": "E-mail é obrigatório" },
  { "field": "idade", "error": "Idade deve estar entre 18 e 120" }
]
```

Uma mensagem customizada que já seja JSON (começa com `{` ou `[` — como a
saída de um `TValidacaoSchemaBase`/`TValidacaoLista` aninhado) é embutida
como valor estruturado, não como string escapada.

`VerificaTodosErro` levanta `TValidadorException` com esse JSON como
mensagem se houver qualquer erro; `VerificaErro` levanta na primeira regra
que falhar (comportamento por regra, não agregado).

## Testes

Suíte DUnitX completa em [`Test/`](Test/) — ver [`Test/README.md`](Test/README.md)
pra como compilar e rodar.
