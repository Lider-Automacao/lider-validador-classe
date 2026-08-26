unit Validador.Tamanho;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoTamanhoMinimo = class deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'(TValidacaoBase<Variant>)
  private
    FTamanho: Integer;
  public
    constructor Create(aTamanho: Integer); reintroduce;
    function Valido: Boolean; override;
    class function New(aTamanho: Integer): IValidacao<Variant>;
  end;

  TValidacaoTamanhoMaximo = class deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'(TValidacaoBase<Variant>)
  private
    FTamanho: Integer;
  public
    constructor Create(aTamanho: Integer); reintroduce;
    function Valido: Boolean; override;
    class function New(aTamanho: Integer): IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils,
  Variants;

{ TValidacaoTamanhoMinimo }

constructor TValidacaoTamanhoMinimo.Create(aTamanho: Integer);
begin
  inherited Create(Format('Deve ter no mínimo %d caracteres', [aTamanho]));
  FTamanho := aTamanho;
end;

class function TValidacaoTamanhoMinimo.New(aTamanho: Integer): IValidacao<Variant>;
begin
  Result := Self.Create(aTamanho);
end;

function TValidacaoTamanhoMinimo.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := Length(VarToStr(FValue).Trim) >= FTamanho;
end;

{ TValidacaoTamanhoMaximo }

constructor TValidacaoTamanhoMaximo.Create(aTamanho: Integer);
begin
  inherited Create(Format('Deve ter no máximo %d caracteres', [aTamanho]));
  FTamanho := aTamanho;
end;

class function TValidacaoTamanhoMaximo.New(aTamanho: Integer): IValidacao<Variant>;
begin
  Result := Self.Create(aTamanho);
end;

function TValidacaoTamanhoMaximo.Valido: Boolean;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  if (VarToStr(FValue).Trim = '') and not FRequerido then
    Exit(True);

  Result := Length(VarToStr(FValue).Trim) <= FTamanho;
end;

end.
