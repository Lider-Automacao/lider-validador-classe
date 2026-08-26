program Test;

{$APPTYPE CONSOLE}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF}
  DUnitX.TestFramework,

  // Units do pacote lider-validador-classe (referenciadas direto do source,
  // sem depender de instalacao Boss, ja que os testes vivem no mesmo repo).
  Validador in '..\src\Legado\Validador.pas',
  Validador.Types in '..\src\Legado\Validador.Types.pas',
  Validador.Base in '..\src\Legado\Validador.Base.pas',
  Validador.Base.Schema in '..\src\Legado\Validador.Base.Schema.pas',
  Validador.Commons in '..\src\Legado\Validador.Commons.pas',
  Validador.CNPJ in '..\src\Legado\Validador.CNPJ.pas',
  Validador.CPF in '..\src\Legado\Validador.CPF.pas',
  Validador.Enum in '..\src\Legado\Validador.Enum.pas',
  Validador.Igual in '..\src\Legado\Validador.Igual.pas',
  Validador.Lista in '..\src\Legado\Validador.Lista.pas',
  Validador.MaiorQue in '..\src\Legado\Validador.MaiorQue.pas',
  Validador.MenorQue in '..\src\Legado\Validador.MenorQue.pas',
  Validador.QueryParams in '..\src\Legado\Validador.QueryParams.pas',
  Validador.Regex in '..\src\Legado\Validador.Regex.pas',
  Validador.Requerido in '..\src\Legado\Validador.Requerido.pas',
  Validador.Vazio in '..\src\Legado\Validador.Vazio.pas',
  Validador.Email in '..\src\Legado\Validador.Email.pas',
  Validador.Url in '..\src\Legado\Validador.Url.pas',
  Validador.Telefone in '..\src\Legado\Validador.Telefone.pas',
  Validador.CEP in '..\src\Legado\Validador.CEP.pas',
  Validador.Tamanho in '..\src\Legado\Validador.Tamanho.pas',
  Validador.Entre in '..\src\Legado\Validador.Entre.pas',
  Validador.DataString in '..\src\Legado\Validador.DataString.pas',
  Validador.Estrito.Types in '..\src\Estrito\Validador.Estrito.Types.pas',
  Validador.Estrito.Base in '..\src\Estrito\Validador.Estrito.Base.pas',
  Validador.Estrito.Requerido in '..\src\Estrito\Validador.Estrito.Requerido.pas',
  Validador.Estrito.Comparacao in '..\src\Estrito\Validador.Estrito.Comparacao.pas',
  Validador.Estrito.Vazio in '..\src\Estrito\Validador.Estrito.Vazio.pas',
  Validador.Estrito.Regex in '..\src\Estrito\Validador.Estrito.Regex.pas',
  Validador.Estrito.Email in '..\src\Estrito\Validador.Estrito.Email.pas',
  Validador.Estrito.Url in '..\src\Estrito\Validador.Estrito.Url.pas',
  Validador.Estrito.CEP in '..\src\Estrito\Validador.Estrito.CEP.pas',
  Validador.Estrito.Telefone in '..\src\Estrito\Validador.Estrito.Telefone.pas',
  Validador.Estrito.Tamanho in '..\src\Estrito\Validador.Estrito.Tamanho.pas',
  Validador.Estrito.Enum in '..\src\Estrito\Validador.Estrito.Enum.pas',
  Validador.Estrito.DataString in '..\src\Estrito\Validador.Estrito.DataString.pas',

  // Units de teste
  Teste.Validador in 'src\Teste.Validador.pas',
  Teste.Validador.Vazio in 'src\Teste.Validador.Vazio.pas',
  Teste.Validador.Requerido in 'src\Teste.Validador.Requerido.pas',
  Teste.Validador.Igual in 'src\Teste.Validador.Igual.pas',
  Teste.Validador.Regex in 'src\Teste.Validador.Regex.pas',
  Teste.Validador.Enum in 'src\Teste.Validador.Enum.pas',
  Teste.Validador.MaiorQue in 'src\Teste.Validador.MaiorQue.pas',
  Teste.Validador.MenorQue in 'src\Teste.Validador.MenorQue.pas',
  Teste.Validador.CPF in 'src\Teste.Validador.CPF.pas',
  Teste.Validador.CNPJ in 'src\Teste.Validador.CNPJ.pas',
  Teste.Validador.Types in 'src\Teste.Validador.Types.pas',
  Teste.Validador.Commons in 'src\Teste.Validador.Commons.pas',
  Teste.Validador.QueryParams in 'src\Teste.Validador.QueryParams.pas',
  Teste.Validador.Base.Schema in 'src\Teste.Validador.Base.Schema.pas',
  Teste.Validador.Lista in 'src\Teste.Validador.Lista.pas',
  Teste.Validador.Email in 'src\Teste.Validador.Email.pas',
  Teste.Validador.Url in 'src\Teste.Validador.Url.pas',
  Teste.Validador.Telefone in 'src\Teste.Validador.Telefone.pas',
  Teste.Validador.CEP in 'src\Teste.Validador.CEP.pas',
  Teste.Validador.Tamanho in 'src\Teste.Validador.Tamanho.pas',
  Teste.Validador.Entre in 'src\Teste.Validador.Entre.pas',
  Teste.Validador.DataString in 'src\Teste.Validador.DataString.pas',
  Teste.Validador.Estrito.Types in 'src\Teste.Validador.Estrito.Types.pas',
  Teste.Validador.Estrito.Base in 'src\Teste.Validador.Estrito.Base.pas',
  Teste.Validador.Estrito.Requerido in 'src\Teste.Validador.Estrito.Requerido.pas',
  Teste.Validador.Estrito.Comparacao in 'src\Teste.Validador.Estrito.Comparacao.pas',
  Teste.Validador.Estrito.Vazio in 'src\Teste.Validador.Estrito.Vazio.pas',
  Teste.Validador.Estrito.Regex in 'src\Teste.Validador.Estrito.Regex.pas',
  Teste.Validador.Estrito.Email in 'src\Teste.Validador.Estrito.Email.pas',
  Teste.Validador.Estrito.Url in 'src\Teste.Validador.Estrito.Url.pas',
  Teste.Validador.Estrito.CEP in 'src\Teste.Validador.Estrito.CEP.pas',
  Teste.Validador.Estrito.Telefone in 'src\Teste.Validador.Estrito.Telefone.pas',
  Teste.Validador.Estrito.Tamanho in 'src\Teste.Validador.Estrito.Tamanho.pas',
  Teste.Validador.Estrito.Enum in 'src\Teste.Validador.Estrito.Enum.pas',
  Teste.Validador.Estrito.DataString in 'src\Teste.Validador.Estrito.DataString.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;

begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  Exit;
{$ENDIF}
  try
    ReportMemoryLeaksOnShutdown := True;

    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    runner.FailsOnNoAsserts := False;

    logger := TDUnitXConsoleLogger.Create(True);
    runner.AddLogger(logger);

    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := 1;

    {$IFNDEF CI}
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Concluido. Pressione <Enter> pra sair.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
