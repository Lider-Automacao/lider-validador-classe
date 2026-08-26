unit Validador.Igual;

interface

uses
  variants,
  Validador.Types,
  Validador.Base;

type
  TValidacaoIgual = class(TValidacaoBase<Variant>)
  private
    FComparador: Variant;
  public
    constructor Create(aComparador: Variant); reintroduce;
    function Valido: Boolean; override;
    function Valida(const aValue: Variant): IValidacao<Variant>; override;
    class function New(aComparador: Variant): IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils;

constructor TValidacaoIgual.Create(aComparador: Variant);
begin
  inherited Create('Os valores devem ser iguais');
  FComparador := aComparador;
end;

class function TValidacaoIgual.New(aComparador: Variant): IValidacao<Variant>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoIgual.Valida(const aValue: Variant): IValidacao<Variant>;
begin
  Result := Self;
  inherited Valida(aValue);
  FMensagem := Format('valor %s deve ser igual a %s', [VarToStr(FValue), VarToStr(FComparador)])
end;

function TValidacaoIgual.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if VarIsStr(FValue) then
    Exit(VarToStr(FValue).trim.length = FComparador);

  Result := FValue = FComparador;
end;

end.
