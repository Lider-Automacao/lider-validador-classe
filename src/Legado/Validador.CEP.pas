unit Validador.CEP;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoCEP = class(TValidacaoBase<Variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
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
  REGEX_CEP = '^\d{5}-?\d{3}$';

constructor TValidacaoCEP.Create;
begin
  inherited Create('CEP inválido');
end;

class function TValidacaoCEP.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoCEP.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegEx.IsMatch(VarToStr(FValue), REGEX_CEP);
end;

end.
