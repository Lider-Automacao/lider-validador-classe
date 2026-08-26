unit Validador.Estrito.Enum;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaEnum = class(TValidacaoEstritaBase<string>)
  private
    FEnumValues: TArray<string>;
  public
    constructor Create(const aEnum: TArray<string>); reintroduce;
    function Valido: Boolean; override;
    class function New(const aEnum: TArray<string>): IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils;

constructor TValidacaoEstritaEnum.Create(const aEnum: TArray<string>);
begin
  inherited Create(Concat('Valor informado não esta contido no enumerado(', String.Join(',', aEnum), ')'));
  FEnumValues := Copy(aEnum, Low(aEnum), Length(aEnum));
end;

class function TValidacaoEstritaEnum.New(const aEnum: TArray<string>): IValidacaoEstrita<string>;
begin
  Result := Self.Create(aEnum);
end;

function TValidacaoEstritaEnum.Valido: Boolean;
var
  I: Integer;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);

  if FValue.Value = '' then
    Exit(not FRequerido);

  Result := False;
  for I := Low(FEnumValues) to High(FEnumValues) do
    if FEnumValues[I] = FValue.Value then
      Exit(True);
end;

end.
