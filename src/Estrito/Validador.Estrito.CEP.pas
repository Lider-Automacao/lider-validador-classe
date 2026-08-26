unit Validador.Estrito.CEP;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaCEP = class(TValidacaoEstritaBase<string>)
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
  REGEX_CEP = '^\d{5}-?\d{3}$';

constructor TValidacaoEstritaCEP.Create;
begin
  inherited Create('CEP inválido');
end;

class function TValidacaoEstritaCEP.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaCEP.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := TRegEx.IsMatch(FValue.Value, REGEX_CEP);
end;

end.
