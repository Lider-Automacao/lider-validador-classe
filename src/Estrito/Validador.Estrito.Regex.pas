unit Validador.Estrito.Regex;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaRegex = class(TValidacaoEstritaBase<string>)
  private
    FRegex: string;
  public
    constructor Create(const aRegex: string); reintroduce;
    function Valido: Boolean; override;
    class function New(const aRegex: string): IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions;

constructor TValidacaoEstritaRegex.Create(const aRegex: string);
begin
  inherited Create('Valor não condiz com o padrão');
  FRegex := aRegex;
end;

class function TValidacaoEstritaRegex.New(const aRegex: string): IValidacaoEstrita<string>;
begin
  Result := Self.Create(aRegex);
end;

function TValidacaoEstritaRegex.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := TRegEx.IsMatch(FValue.Value, FRegex);
end;

end.
