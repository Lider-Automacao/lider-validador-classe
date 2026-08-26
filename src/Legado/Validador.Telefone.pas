unit Validador.Telefone;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoTelefone = class(TValidacaoBase<Variant>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';

  TValidacaoCelular = class(TValidacaoBase<Variant>)
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
  // DDD (2 digitos, sem zero a esquerda) + numero fixo (8 digitos)
  REGEX_TELEFONE = '^[1-9]\d{9}$';
  // DDD (2 digitos) + celular (9 digitos, com o 9 na frente do numero)
  REGEX_CELULAR = '^[1-9]\d9\d{8}$';

{ TValidacaoTelefone }

constructor TValidacaoTelefone.Create;
begin
  inherited Create('Telefone inválido');
end;

class function TValidacaoTelefone.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoTelefone.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegEx.IsMatch(TRegEx.Replace(VarToStr(FValue), '\D', ''), REGEX_TELEFONE);
end;

{ TValidacaoCelular }

constructor TValidacaoCelular.Create;
begin
  inherited Create('Celular inválido');
end;

class function TValidacaoCelular.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoCelular.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegEx.IsMatch(TRegEx.Replace(VarToStr(FValue), '\D', ''), REGEX_CELULAR);
end;

end.
