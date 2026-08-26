unit Validador.QueryParams;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  EValidationException = class(Exception);

function ValidaCodigoExterno(const pQuery: TDictionary<string, string>): Boolean;
function ValidaPage(const pQuery: TDictionary<string, string>): Boolean;
function ValidaLimit(const pQuery: TDictionary<string, string>): Boolean;

implementation

uses
  Validador,
  Validador.Types,
  Validador.Commons,
  System.Types;

function ValidaCampoInteiroPositivo(const pQuery: TDictionary<string, string>; const pCampo: string): Boolean;
var
  LValor: Integer;
  LExecutor: IExecutorValidador;
begin
  Result := False;

  if not pQuery.ContainsKey(pCampo) then
    Exit;

  try
    LValor := pQuery[pCampo].ToInteger;
  except
    on E: Exception do
      raise EValidationException.Create(Format('Erro ao converter %s para inteiro: %s', [pCampo, E.Message]));
  end;

  LExecutor := TValidador.New
    .Add(pCampo, LValor)
      .Nullable
      .MaiorQueOuIgual(1)
    .&End
    .Executa;

  if not LExecutor.Valido then
    raise EValidationException.Create(Format('O valor de %s deve ser maior que 0', [pCampo]));

  Result := True;
end;

function ValidaCodigoExterno(const pQuery: TDictionary<string, string>): Boolean;
var
  LCodigoExterno: TIntegerDynArray;
  I: Integer;
begin
  Result := False;

  if not pQuery.ContainsKey('codigoExterno') then
    Exit;

  try
    LCodigoExterno := InStringToArray(pQuery['codigoExterno']);
  except
    raise EValidationException.Create('codigoExterno: Todos os valores devem ser Inteiros');
  end;

  for I := 0 to High(LCodigoExterno) do
    if LCodigoExterno[I] < 1 then
      raise EValidationException.Create('codigoExterno: Todos os valores devem ser maiores ou iguais a 1');

  Result := True;
end;

function ValidaPage(const pQuery: TDictionary<string, string>): Boolean;
begin
  Result := ValidaCampoInteiroPositivo(pQuery, 'page');
end;

function ValidaLimit(const pQuery: TDictionary<string, string>): Boolean;
begin
  Result := ValidaCampoInteiroPositivo(pQuery, 'limit');
end;

end.
