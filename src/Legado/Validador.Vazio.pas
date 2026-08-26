unit Validador.Vazio;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoEstaVazio = class(TValidacaoBase<Variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end;

  TValidacaoNaoEstaVazio = class(TValidacaoBase<Variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils, variants;

constructor TValidacaoEstaVazio.Create;
begin
  inherited Create('Deve ser Vazio');
end;

class function TValidacaoEstaVazio.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoEstaVazio.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  Result := VarToStr(FValue).Trim.IsEmpty;
end;

{ TValidacaoNaoEstaVazio }

constructor TValidacaoNaoEstaVazio.Create;
begin
  inherited Create('Não deve ser Vazio');
end;

class function TValidacaoNaoEstaVazio.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoNaoEstaVazio.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  Result := not VarToStr(FValue).Trim.IsEmpty;
end;

end.
