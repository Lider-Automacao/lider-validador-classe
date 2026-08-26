unit Validador.Regex;

interface

uses
  variants,
  Validador.Types,
  Validador.Base;

type
  TValidacaoRegex = class(TValidacaoBase<Variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  private
    FRegex: String;
  public
    constructor Create(aRegex: String); reintroduce;
    function Valido: Boolean; override;
    function Valida(const aValue: Variant): IValidacao<Variant>; override;
    class function New(aRegex: String): IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils, System.RegularExpressions;

constructor TValidacaoRegex.Create(aRegex: String);
begin
  inherited Create('Valor não condiz com o padrão');
  FRegex := aRegex;
end;

class function TValidacaoRegex.New(aRegex: String): IValidacao<Variant>;
begin
  Result := Self.Create(aRegex);
end;

function TValidacaoRegex.Valida(const aValue: Variant): IValidacao<Variant>;
begin
  Result := Self;
  inherited Valida(aValue);
  FMensagem := Format('Valor %s condiz com o padrão %s',[VarToStr(FValue),FRegex])
end;

function TValidacaoRegex.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

 if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegex.create(FRegex).IsMatch(VarToStr(FValue));
end;


end.
