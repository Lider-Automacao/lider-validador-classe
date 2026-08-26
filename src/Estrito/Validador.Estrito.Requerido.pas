unit Validador.Estrito.Requerido;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaRequerido<T> = class(TValidacaoEstritaBase<T>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<T>;
  end;

implementation

constructor TValidacaoEstritaRequerido<T>.Create;
begin
  inherited Create('Obrigatório');
end;

class function TValidacaoEstritaRequerido<T>.New: IValidacaoEstrita<T>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaRequerido<T>.Valido: Boolean;
begin
  Result := FValue.HasValue;
end;

end.
