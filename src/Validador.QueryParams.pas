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

uses Validador.Commons, System.Types;

function ValidaCodigoExterno(const pQuery: TDictionary<string, string>): Boolean;
var
  CodigoExterno: TIntegerDynArray;
  I: Integer;
begin
  Result := False;

  if pQuery.ContainsKey('codigoExterno') then
  begin
    try
      try
      // Tenta converter a string para um array de inteiros
        CodigoExterno := InStringToArray(pQuery['codigoExterno']);
      except
       raise EValidationException.Create('Todos os valores devem ser Inteiros');
      end;

      // Verifica se todos os valores são maiores ou iguais a 1
      for I := 0 to High(CodigoExterno) do
      begin
        if CodigoExterno[I] < 1 then
          raise EValidationException.Create('Todos os valores devem ser maiores ou iguais a 1');
      end;

      // ResultArray := CodigoExterno;
      Result := True;
    except
      on E: Exception do
        raise EValidationException.Create('codigoExterno: ' + E.Message);
    end;
  end;
end;

function ValidaPage(const pQuery: TDictionary<string, string>): Boolean;
var
  PageValue: Integer;
begin
  Result := False;
  if pQuery.ContainsKey('page') then
  begin
    try
      PageValue := pQuery['page'].ToInteger;

      if PageValue <= 0 then
        raise EValidationException.Create('O valor de page deve ser maior que 0');

      Result := True;
    except
      on E: Exception do
        raise EValidationException.Create('Erro ao converter page para inteiro: ' + E.Message);
    end;
  end;
end;

function ValidaLimit(const pQuery: TDictionary<string, string>): Boolean;
var
  LimitValue: Integer;
begin
  Result := False;
  if pQuery.ContainsKey('limit') then
  begin
    try
      LimitValue := pQuery['limit'].ToInteger;
      if LimitValue <= 0 then
        raise EValidationException.Create('O valor de limit deve ser maior que 0');
      Result := True;
    except
      on E: Exception do
        raise EValidationException.Create('Erro ao converter limit para inteiro: ' + E.Message);
    end;
  end;
end;

end.
