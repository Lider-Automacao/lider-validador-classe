unit Validador.Estrito.Url;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaUrl = class(TValidacaoEstritaBase<string>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions;

const
  REGEX_URL = '^(https?:\/\/)?([\w-]+\.)+[\w-]{2,}(:\d+)?(\/[\w\-._~:/?#\[\]@!$&''()*+,;=%]*)?$';

constructor TValidacaoEstritaUrl.Create;
begin
  inherited Create('URL inválida');
end;

class function TValidacaoEstritaUrl.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaUrl.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := TRegEx.IsMatch(FValue.Value, REGEX_URL);
end;

end.
