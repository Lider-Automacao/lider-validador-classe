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

## Uso básico

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
