unit Validador.Enum;

interface

uses
  Validador.Types,
  Validador.Base,
  System.Generics.Collections;

type
  TEnumValues = Array of string;
  TValidacaoEnum = class(TValidacaoBase<Variant>)
  private
    FEnumValues: TEnumValues;
  public
    constructor Create(aEnum: TEnumValues); reintroduce;
    function Valido: Boolean; override;
    class function New(aEnum: TEnumValues): IValidacao<Variant>;
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';

implementation

uses
  System.SysUtils, Variants;

constructor TValidacaoEnum.Create(aEnum: TEnumValues);
begin
  inherited Create(Concat('Valor informado não esta contido no enumerado(', String.Join(',', aEnum), ')'));
  FEnumValues := Copy(aEnum, Low(aEnum), Length(aEnum)); ;
end;

class function TValidacaoEnum.New(aEnum: TEnumValues): IValidacao<Variant>;
begin
  Result := Self.Create(aEnum);
end;

function TValidacaoEnum.Valido: Boolean;
var
  i: Integer;
  LValue: string;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  Result := False;
  LValue := VarToStr(FValue);

  if LValue = '' then
    Exit(True);

  for i := Low(FEnumValues) to High(FEnumValues) do
  begin
    if FEnumValues[i] = LValue then
    begin
      Result := True;
      Break;
    end;
  end;
end;

end.
