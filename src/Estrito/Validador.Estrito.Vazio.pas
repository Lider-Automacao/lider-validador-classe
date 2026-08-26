unit Validador.Estrito.Vazio;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaEstaVazio = class(TValidacaoEstritaBase<string>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

  TValidacaoEstritaNaoEstaVazio = class(TValidacaoEstritaBase<string>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils;

constructor TValidacaoEstritaEstaVazio.Create;
begin
  inherited Create('Deve ser Vazio');
end;

class function TValidacaoEstritaEstaVazio.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaEstaVazio.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := FValue.Value.Trim.IsEmpty;
end;

constructor TValidacaoEstritaNaoEstaVazio.Create;
begin
  inherited Create('Não deve ser Vazio');
end;

class function TValidacaoEstritaNaoEstaVazio.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaNaoEstaVazio.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := not FValue.Value.Trim.IsEmpty;
end;

end.
