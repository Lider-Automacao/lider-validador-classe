unit Validador.Entre;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoEntre = class(TValidacaoBase<Variant>)
  private
    FMinimo: Variant;
    FMaximo: Variant;
  public
    constructor Create(aMinimo, aMaximo: Variant); reintroduce;
    function Valido: Boolean; override;
    class function New(aMinimo, aMaximo: Variant): IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils,
  Variants;

constructor TValidacaoEntre.Create(aMinimo, aMaximo: Variant);
begin
  inherited Create(Format('Deve estar entre %s e %s', [VarToStr(aMinimo), VarToStr(aMaximo)]));
  FMinimo := aMinimo;
  FMaximo := aMaximo;
end;

class function TValidacaoEntre.New(aMinimo, aMaximo: Variant): IValidacao<Variant>;
begin
  Result := Self.Create(aMinimo, aMaximo);
end;

function TValidacaoEntre.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if VarIsEmpty(FValue) then
    Exit(False);

  Result := (FValue >= FMinimo) and (FValue <= FMaximo);
end;

end.
