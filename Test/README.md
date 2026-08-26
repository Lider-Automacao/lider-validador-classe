# Suíte de testes — lider-validador-classe

Suíte DUnitX cobrindo 100% das classes públicas do pacote (15 arquivos de
teste, ~90 casos), incluindo a matriz **Requerido × Null × Vazio ×
Preenchido** em cada validador — exatamente onde viveram os bugs
corrigidos nesta sessão (ver `VALIDADOR_NAOESTAVAZIO_NULLABLE_AUSENTE_BUG.md`
e o laudo técnico).

## Pré-requisitos

- RAD Studio com **DUnitX** disponível (via GetIt, ou como source no
  library path). Este projeto não empacota o DUnitX — ele referencia as
  units `DUnitX.*` esperando que estejam no path do compilador.
- Não há dependência do pacote `lider-validador-classe` via Boss: as units
  de `src/` são referenciadas diretamente por caminho relativo
  (`..\src\Validador.*.pas`) em `Test.dpr`/`Test.dproj`, então a suíte
  sempre testa o código local, não uma versão publicada.

## Rodando

Abra `Test.dproj` no RAD Studio e rode (F9), ou via linha de comando:

```
msbuild Test.dproj /t:Build /p:Config=Release /p:Platform=Win32
bin\Win32\Release\Test.exe
```

O executável roda no console, imprime resultado por `[Test]` e também
grava `nunit.xml` (via `DUnitX.Loggers.Xml.NUnit`) pra integrar com CI.
Se o RAD Studio suportar TestInsight, ele é usado automaticamente
(`{$IFDEF TESTINSIGHT}`) no lugar do runner de console.

## O que este `Test.dproj` **não** tem certeza de resolver sozinho

Ele foi escrito à mão (sem compilador Delphi disponível neste ambiente pra
gerar/validar via IDE). Se o RAD Studio reclamar de path do DUnitX ao abrir
o projeto, adicione manualmente em **Project > Options > Search Path** o
diretório onde o DUnitX está instalado, e deixe o IDE re-salvar o `.dproj`.

## Nota sobre o bug de Null — resolvido e confirmado por execução real

A primeira rodada do fix (guarda `VarIsNull` só dentro de `Valido`) **não
era suficiente** pra `TValidacaoEstaVazio`, `TValidacaoNaoEstaVazio`,
`TValidacaoRegex`, `TValidacaoEnum`, `TValidacaoCPF` e `TValidacaoCNPJ` —
confirmado rodando esta suíte no RAD Studio: 13 testes quebraram com
`EVariantTypeCastError` mesmo com o fix aplicado.

Causa raiz real: essas 6 classes eram `TValidacaoBase<String>`. Passar um
`Variant` (`Null`) pra um parâmetro `String` (`.Valida`) estoura
`EVariantTypeCastError` **na própria passagem do parâmetro**, antes de
`Valido` sequer começar a rodar — a guarda `VarIsNull(FValue)` dentro de
`Valido` nunca era alcançada nesses casos. `Igual`, `MaiorQue`, `MenorQue`
e `Requerido` nunca tiveram esse problema porque já eram
`TValidacaoBase<Variant>`.

Fix real aplicado: as 6 classes agora são `TValidacaoBase<Variant>`
também, com `VarToStr(FValue)` usado explicitamente depois da guarda de
Null. Isso elimina a conversão implícita arriscada tanto dentro de
`Valido` quanto no ponto de chamada em `Validador.pas`
(`.Valida(FValue)`, `FValue: variant`). Rode a suíte de novo — os 13
testes que falharam devem passar agora.
