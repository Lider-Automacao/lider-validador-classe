unit Validador.MenorQue;

interface

uses
  variants,
  Validador.Types,
  Validador.Base;

type
  TValidacaoMenorQue = class(TValidacaoBase<variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  private
    FComparador: variant;
  public
    function Valido: Boolean; override;
    constructor Create(aComparador: variant); reintroduce;
    class function New(aComparador: variant): IValidacao<variant>;
  end;

  TValidacaoMenorOuIgualQue = class(TValidacaoBase<variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  private
    FComparador: variant;
  public
    function Valido: Boolean; override;
    constructor Create(aComparador: variant); reintroduce;
    class function New(aComparador: variant): IValidacao<variant>;
  end;

implementation

uses
  System.SysUtils;

{ TValidacaoMenorOuIgualQue }

constructor TValidacaoMenorOuIgualQue.Create(aComparador: variant);
begin
  inherited Create(Format('Deve ser menor ou igual que %s', [VarToStr(aComparador)]));
  FComparador := aComparador;
end;

class function TValidacaoMenorOuIgualQue.New(aComparador: variant): IValidacao<variant>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoMenorOuIgualQue.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if VarIsEmpty(FValue) then
    Exit(False);

  if VarIsStr(FValue) then
    Exit(VarToStr(fValue).trim.length <= FComparador);

  Result := FValue <= FComparador;
end;

{ TValidacaoMenorQue }

constructor TValidacaoMenorQue.Create(aComparador: variant);
begin
  inherited Create(Format('Deve ser menor que %s', [VarToStr(aComparador)]));
  FComparador := aComparador;
end;

class function TValidacaoMenorQue.New(aComparador: variant): IValidacao<variant>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoMenorQue.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if VarIsEmpty(FValue) then
    Exit(False);

  if VarIsStr(FValue) then
    Exit(VarToStr(fValue).trim.length < FComparador);

  Result := FValue < FComparador;
end;

end.
