# trilha de validação estrita (`Validador.Estrito.*`) — design

**Status:** aprovado em conversa, aguardando revisão final antes do plano de implementação.
**Data:** 2026-08-26

## Contexto

A API atual (`TValidador`, `TValidacaoBase<Variant>` e todas as classes
`TValidacaoXxx` em `src/`) usa `Variant` como tipo universal pra carregar
qualquer valor de campo. Isso resolve o problema de "campo pode ou não ter
valor" (`Null`), mas custa segurança de tipo em compile-time — nada impede
`.MaiorQue('abc')` ou passar um número onde a regra espera string, e o
compilador não pega isso. É também a raiz estrutural dos bugs de
`EVariantTypeCastError` corrigidos nesta mesma sessão.

Este spec cobre uma **trilha paralela, aditiva, sem Variant**, pra quem
quer o mesmo estilo fluente de validação com tipo forte checado em
compile-time. A trilha atual (`Validador.pas` e afins) continua existindo
e funcionando exatamente como hoje — só passa a ser marcada como
`deprecated`, sinalizando remoção numa v2.0 futura, sem quebrar ninguém
agora.

## Objetivo

- Segurança de tipo em compile-time é a prioridade (não performance,
  embora eliminar `Variant` também remova o overhead de boxing/dispatch
  como efeito colateral).
- Zero uso de `Variant` na trilha nova — `Null`/ausência de valor
  representado por um `TNullable<T>` genérico próprio.
- Não quebrar nenhum consumidor existente da trilha atual.
- Organizar o código-fonte em pastas (`Legado/` e `Estrito/`) sem renomear
  nenhuma unit existente.

## Não-objetivos (fora de escopo deste spec)

- Não redesenha o `TValidador`/`IValidadorAdd`/`INullValidador`
  multi-campo (`Add(prop, valor).Requerido.NaoVazio.End`) pra ser
  genérico por campo. A trilha estrita valida **um valor por vez**, não
  agrega múltiplos campos heterogêneos num único JSON de erros como o
  `TValidador` atual faz.
- Não remove nem reescreve nenhuma classe da trilha atual nesta rodada —
  só marca como `deprecated`.
- Não adiciona dependência externa (Spring4D ou outra) — `TNullable<T>`
  é implementado localmente.
- Não migra `Validador.Lista.pas`/`Validador.Base.Schema.pas`
  (composição de objeto/lista) pra trilha estrita — ficam só na trilha
  legada por ora.

## Arquitetura

### `TNullable<T>` (novo, `Validador.Estrito.Types.pas`)

Record genérico local, sem dependência externa:

```pascal
TNullable<T> = record
private
  FValue: T;
  FHasValue: Boolean;
public
  class function Create(const aValue: T): TNullable<T>; static;
  class function Empty: TNullable<T>; static;
  property HasValue: Boolean read FHasValue;
  property Value: T read FValue;
  class operator Implicit(const aValue: T): TNullable<T>;
  class operator Implicit(const aValue: TNullable<T>): T;
end;
```

O operator `Implicit(T): TNullable<T>` permite `.Valida('algumaString')`
sem precisar escrever `.Valida(TNullable<string>.Create('algumaString'))`
no caso comum (valor presente). Ausência de valor é explícita:
`.Valida(TNullable<string>.Empty)`.

### `IValidacaoEstrita<T>` / `TValidacaoEstritaBase<T>` (`Validador.Estrito.Base.pas`)

Espelham `IValidacao<T>` / `TValidacaoBase<T>` de hoje, trocando
`FValue: T` (ou `Variant`) por `FValue: TNullable<T>`, e
`VarIsNull(FValue)` por `not FValue.HasValue`.

```pascal
IValidacaoEstritaBase = interface
  function Mensagem: string; overload;
  function Propriedade: string; overload;
  function Valido: Boolean;
  procedure VerificaErro;
end;

IValidacaoEstrita<T> = interface(IValidacaoEstritaBase)
  function Requerido(const aRequerido: Boolean): IValidacaoEstrita<T>;
  function Propriedade(const aPropriedade: string): IValidacaoEstrita<T>;
  function Valida(const aValue: TNullable<T>): IValidacaoEstrita<T>;
  function Mensagem(const aMensagem: string): IValidacaoEstrita<T>; overload;
end;
```

### Validadores genéricos reais (`Validador.Estrito.Comparacao.pas`, `Validador.Estrito.Requerido.pas`)

`T` livre, comparação via `TComparer<T>.Default.Compare` (do
`System.Generics.Defaults`, já na RTL, sem dependência nova):

- `TValidacaoEstritaRequerido<T>` — `Valido := FValue.HasValue`.
- `TValidacaoEstritaMaiorQue<T>`, `MenorQue<T>`, `MaiorOuIgualQue<T>`,
  `MenorOuIgualQue<T>`, `Entre<T>`, `Igual<T>`.

Nota de risco: `TComparer<T>.Default` funciona bem pra tipos ordinais,
`string`, `TDateTime` e afins; pra um `T` sem ordem natural o
comportamento em runtime é indefinido/sem sentido — documentar isso na
unit (comentário no topo, não checagem em runtime).

### Validadores string-only (não genéricos, um por unit — mesmo padrão de arquivo da trilha legada)

`NaoVazio`, `Vazio`, `Regex`, `Email`, `Url`, `CEP`, `Telefone`,
`Celular`, `TamanhoMinimo`, `TamanhoMaximo`, `CPF`, `CNPJ`, `Enum`,
`DataString` — mesma lógica/regex/algoritmo de dígito verificador já
existente na trilha legada (incluindo o fix de CNPJ alfanumérico e
`DataValida` real desta sessão), só trocando o acesso ao valor de
`VarToStr(FValue)`/`VarIsNull(FValue)` pra `FValue.Value`/`not
FValue.HasValue`.

### Fachadas fluentes por tipo (`Validador.Estrito.String.pas`, `.Inteiro.pas`, `.Int64.pas`, `.Double.pas`, `.Data.pas`)

Uma classe concreta por tipo, cada uma só expõe os métodos que fazem
sentido pro tipo — isso é o que dá a segurança de tipo real (o
compilador não deixa nem tentar chamar `.CPF` numa fachada `Double`):

```pascal
TValidadorString = class
public
  function Requerido(aMensagem: string = ''): TValidadorString;
  function Nullable: TValidadorString;
  function NaoVazio(aMensagem: string = ''): TValidadorString;
  function Vazio(aMensagem: string = ''): TValidadorString;
  function Regex(aRegex: string; aMensagem: string = ''): TValidadorString;
  function Email(aMensagem: string = ''): TValidadorString;
  function Url(aMensagem: string = ''): TValidadorString;
  function CEP(aMensagem: string = ''): TValidadorString;
  function Telefone(aMensagem: string = ''): TValidadorString;
  function Celular(aMensagem: string = ''): TValidadorString;
  function TamanhoMinimo(aTamanho: Integer; aMensagem: string = ''): TValidadorString;
  function TamanhoMaximo(aTamanho: Integer; aMensagem: string = ''): TValidadorString;
  function CPF(aMensagem: string = ''): TValidadorString;
  function CNPJ(aMensagem: string = ''): TValidadorString;
  function Enum(aEnum: TArray<string>; aMensagem: string = ''): TValidadorString;
  function DataString(aMensagem: string = ''): TValidadorString;
  function Valida(const aValor: TNullable<string>): TValidadorString;
  function Valido: Boolean;
  function Mensagem: string;
  class function New: TValidadorString;
end;
```

`TValidadorInteiro`/`Int64`/`Double`/`Data` seguem o mesmo desenho, só
com `MaiorQue`/`MenorQue`/`MaiorOuIgualQue`/`MenorOuIgualQue`/`Entre`/`Igual`
no lugar dos métodos string-only.

Cada fachada acumula as regras adicionadas (lista interna de
`IValidacaoEstrita<T>`, mesmo espírito do `IExecutorValidador` de hoje) e
`.Valido` roda todas; `.Mensagem` devolve a mensagem da primeira regra
que falhar (não é JSON agregado — isso é explicitamente não-objetivo
aqui).

Exemplo de uso:

```pascal
if not TValidadorInteiro.New.Requerido.Entre(1, 120).Valida(pIdade).Valido then
  raise Exception.Create('Idade inválida');
```

## Estrutura de pastas

```
src/
  Legado/
    Validador.pas
    Validador.Types.pas
    Validador.Base.pas
    Validador.Base.Schema.pas
    Validador.Commons.pas
    Validador.Enum.pas
    Validador.Igual.pas
    Validador.Lista.pas
    Validador.MaiorQue.pas
    Validador.MenorQue.pas
    Validador.QueryParams.pas
    Validador.Regex.pas
    Validador.Requerido.pas
    Validador.Vazio.pas
    Validador.CPF.pas
    Validador.CNPJ.pas
    Validador.Email.pas
    Validador.Url.pas
    Validador.Telefone.pas
    Validador.CEP.pas
    Validador.Tamanho.pas
    Validador.Entre.pas
    Validador.DataString.pas
  Estrito/
    Validador.Estrito.Types.pas
    Validador.Estrito.Base.pas
    Validador.Estrito.Comparacao.pas
    Validador.Estrito.Requerido.pas
    Validador.Estrito.Vazio.pas
    Validador.Estrito.Regex.pas
    Validador.Estrito.Email.pas
    Validador.Estrito.Url.pas
    Validador.Estrito.CEP.pas
    Validador.Estrito.Telefone.pas
    Validador.Estrito.Tamanho.pas
    Validador.Estrito.CPF.pas
    Validador.Estrito.CNPJ.pas
    Validador.Estrito.Enum.pas
    Validador.Estrito.DataString.pas
    Validador.Estrito.String.pas
    Validador.Estrito.Inteiro.pas
    Validador.Estrito.Int64.pas
    Validador.Estrito.Double.pas
    Validador.Estrito.Data.pas
```

Nenhum nome de `unit` muda — só o caminho físico. `boss.json` continua
com `"mainsrc": "./src"` (Boss resolve por nome de unit via search path,
não por arquivo individual). O que muda de fato:

- `Test/Test.dpr` e `Test/Test.dproj`: todo `in '..\src\Validador.Xxx.pas'`
  vira `in '..\src\Legado\Validador.Xxx.pas'`.
- Qualquer consumidor que hardcode caminho relativo (fora deste repo, não
  detectável daqui) precisa ajustar — inevitável numa reorganização de
  pastas; mitigado por ser exatamente o tipo de mudança que uma major
  version (ou pelo menos um changelog claro) sinaliza.

## Depreciação da trilha atual

Cada `type`/classe pública da trilha legada ganha `deprecated`:

```pascal
TValidacaoCPF = class(TValidacaoBase<Variant>) deprecated
  'Use Validador.Estrito.CPF (TValidadorString.CPF) — remoção planejada pra v2.0';
```

Isso emite warning de compilador (W1000 SYMBOL_DEPRECATED) em qualquer
código que ainda referencie a trilha legada, sem quebrar a compilação.
Aplica-se a todas as classes concretas e interfaces (`IValidador`,
`IValidadorAdd`, `INullValidador`, `TValidador`, e cada `TValidacaoXxx`)
em `Legado/`.

## Tratamento de erros

Mesmo padrão da trilha atual: `Valido: Boolean` não lança, `VerificaErro`
lança `TValidadorException` (reaproveita a mesma classe de
`Validador.Types.pas` — não cria uma nova exceção só pra trilha estrita).

## Testes

Um `Teste.Validador.Estrito.Xxx.pas` por unit nova em `Test/src/`, mesma
matriz `Requerido × Ausente (TNullable.Empty) × Válido × Inválido` já
usada nos testes da trilha legada. `Test.dproj`/`Test.dpr` ganham as
novas units (path `Estrito/`).

## Riscos conhecidos

- `TComparer<T>.Default` sem constraint no genérico: nenhum erro de
  compilação impede instanciar `TValidacaoEstritaMaiorQue<TObject>`, por
  exemplo — o comportamento em runtime seria comparação por referência,
  sem sentido pra "maior que". Não há como constranger isso de forma
  limpa nas versões de Delphi alvo (sem `T: IComparable`); fica como
  limitação documentada, não bug.
- Reorganizar pastas quebra qualquer caminho relativo hardcoded fora
  deste repo — não detectável/mitigável daqui além de documentar no
  changelog.
