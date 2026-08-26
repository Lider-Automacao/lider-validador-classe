unit Validador.Estrito.Tamanho;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaTamanhoMinimo = class(TValidacaoEstritaBase<string>)
  private
    FTamanho: Integer;
  public
    constructor Create(aTamanho: Integer); reintroduce;
    function Valido: Boolean; override;
    class function New(aTamanho: Integer): IValidacaoEstrita<string>;
  end;

  TValidacaoEstritaTamanhoMaximo = class(TValidacaoEstritaBase<string>)
  private
    FTamanho: Integer;
  public
    constructor Create(aTamanho: Integer); reintroduce;
    function Valido: Boolean; override;
    class function New(aTamanho: Integer): IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils;

{ TValidacaoEstritaTamanhoMinimo }

constructor TValidacaoEstritaTamanhoMinimo.Create(aTamanho: Integer);
begin
  inherited Create(Format('Deve ter no mínimo %d caracteres', [aTamanho]));
  FTamanho := aTamanho;
end;

class function TValidacaoEstritaTamanhoMinimo.New(aTamanho: Integer): IValidacaoEstrita<string>;
begin
  Result := Self.Create(aTamanho);
end;

function TValidacaoEstritaTamanhoMinimo.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := Length(FValue.Value.Trim) >= FTamanho;
end;

{ TValidacaoEstritaTamanhoMaximo }

constructor TValidacaoEstritaTamanhoMaximo.Create(aTamanho: Integer);
begin
  inherited Create(Format('Deve ter no máximo %d caracteres', [aTamanho]));
  FTamanho := aTamanho;
end;

class function TValidacaoEstritaTamanhoMaximo.New(aTamanho: Integer): IValidacaoEstrita<string>;
begin
  Result := Self.Create(aTamanho);
end;

function TValidacaoEstritaTamanhoMaximo.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := Length(FValue.Value.Trim) <= FTamanho;
end;

end.
