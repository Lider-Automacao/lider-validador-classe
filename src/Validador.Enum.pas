unit Validador.Enum;

interface

uses
  Validador.Types,
  Validador.Base,
  System.Generics.Collections;

type
  TEnumValues = Array of string;
  TValidacaoEnum = class(TValidacaoBase<String>)
  private
    FEnumValues: TEnumValues;
  public
    constructor Create(aEnum: TEnumValues); reintroduce;
    function Valido: Boolean; override;
    class function New(aEnum: TEnumValues): IValidacao<String>;
  end;

implementation

uses
  System.SysUtils, Variants;

constructor TValidacaoEnum.Create(aEnum: TEnumValues);
begin
  inherited Create(Concat('Valor informado não esta contido no enumerado(', String.Join(',', aEnum), ')'));
  FEnumValues := Copy(aEnum, Low(aEnum), Length(aEnum)); ;
end;

class function TValidacaoEnum.New(aEnum: TEnumValues): IValidacao<String>;
begin
  Result := Self.Create(aEnum);
end;

function TValidacaoEnum.Valido: Boolean;
var
  i: Integer;
begin
 if VarIsNull(FValue) and not FRequerido then
    Exit(True);

  Result := False;

  if FValue = '' then
    Exit(True);

  for i := Low(FEnumValues) to High(FEnumValues) do
  begin
    if FEnumValues[i] = FValue then
    begin
      Result := True;
      Break;
    end;
  end;
end;

end.
