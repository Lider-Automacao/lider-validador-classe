unit Validador.Requerido;

interface

uses
  variants,
  Validador.Types,
  Validador.Base;

type
  TValidacaoRequerido = class(TValidacaoBase<Variant>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils;

constructor TValidacaoRequerido.Create;
begin
  inherited Create('Obrigatório');
end;

class function TValidacaoRequerido.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoRequerido.Valido: Boolean;
begin
  Result := FValue <> null;
end;

end.
