unit Validador.Url;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoUrl = class(TValidacaoBase<Variant>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions,
  Variants;

const
  REGEX_URL = '^(https?:\/\/)?([\w-]+\.)+[\w-]{2,}(:\d+)?(\/[\w\-._~:/?#\[\]@!$&''()*+,;=%]*)?$';

constructor TValidacaoUrl.Create;
begin
  inherited Create('URL inválida');
end;

class function TValidacaoUrl.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoUrl.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegEx.IsMatch(VarToStr(FValue), REGEX_URL);
end;

end.
