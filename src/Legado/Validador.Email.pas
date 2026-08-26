unit Validador.Email;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoEmail = class(TValidacaoBase<Variant>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';

implementation

uses
  System.SysUtils,
  System.RegularExpressions,
  Variants;

const
  REGEX_EMAIL = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

constructor TValidacaoEmail.Create;
begin
  inherited Create('E-mail inválido');
end;

class function TValidacaoEmail.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoEmail.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegEx.IsMatch(VarToStr(FValue), REGEX_EMAIL);
end;

end.
