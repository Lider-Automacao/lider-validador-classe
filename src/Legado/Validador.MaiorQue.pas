unit Validador.MaiorQue;

interface

uses
  variants,
  Validador.Types,
  Validador.Base;

type
  TValidacaoMaiorQue = class(TValidacaoBase<Variant>)
  private
    FComparador: Variant;
  public
    function Valido: Boolean; override;
    constructor Create(aComparador: Variant); reintroduce;
    class function New(aComparador: Variant): IValidacao<Variant>;
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';

  TValidacaoMaiorOuIgualQue = class(TValidacaoBase<Variant>)
  private
    FComparador: Variant;
  public
    function Valido: Boolean; override;
    constructor Create(aComparador: Variant); reintroduce;
    class function New(aComparador: Variant): IValidacao<Variant>;
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';

implementation

uses
  System.SysUtils;

{ TValidacaoMaiorOuIgualQue }

constructor TValidacaoMaiorOuIgualQue.Create(aComparador: Variant);
begin
  inherited Create(Format('Deve ser maior ou igual que %s', [VarToStr(aComparador)]));
  FComparador := aComparador;
end;

class function TValidacaoMaiorOuIgualQue.New(aComparador: Variant): IValidacao<Variant>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoMaiorOuIgualQue.Valido: Boolean;
var
  I: Integer;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if VarIsEmpty(FValue) then
    Exit(False);

  if VarIsStr(FValue) then
    Exit(varToStr(FValue).Trim.length >= FComparador);

  if VarIsArray(FValue) then
  begin
    for I := VarArrayLowBound(FValue, 1) to VarArrayHighBound(FValue, 1) do
      if FValue[I] >= FComparador then
        Exit(FValue[I] >= FComparador);
  end;

  Result := FValue >= FComparador;
end;

{ TValidacaoMaiorQue }

constructor TValidacaoMaiorQue.Create(aComparador: Variant);
begin
  inherited Create(Format('Deve ser maior que %s', [VarToStr(aComparador)]));
  FComparador := aComparador;
end;

class function TValidacaoMaiorQue.New(aComparador: Variant): IValidacao<Variant>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoMaiorQue.Valido: Boolean;
var
  I: Integer;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if VarIsEmpty(FValue) then
    Exit(False);

  if VarIsStr(FValue) then
    Exit(VarToStr(FValue).Trim.length > FComparador);

  if VarIsArray(FValue) then
  begin

    for I := VarArrayLowBound(FValue, 1) to VarArrayHighBound(FValue, 1) do
    begin
      if FValue[I] <= FComparador then
        Exit(False);
    end;

    Exit(True);
  end;

  Result := FValue > FComparador;
end;

end.
