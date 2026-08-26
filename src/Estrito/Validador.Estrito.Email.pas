unit Validador.Estrito.Email;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaEmail = class(TValidacaoEstritaBase<string>)
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
  REGEX_EMAIL = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

constructor TValidacaoEstritaEmail.Create;
begin
  inherited Create('E-mail inválido');
end;

class function TValidacaoEstritaEmail.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaEmail.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := TRegEx.IsMatch(FValue.Value, REGEX_EMAIL);
end;

end.
