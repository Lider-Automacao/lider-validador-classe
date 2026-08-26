unit Validador.Estrito.Telefone;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaTelefone = class(TValidacaoEstritaBase<string>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

  TValidacaoEstritaCelular = class(TValidacaoEstritaBase<string>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions;

const
  REGEX_TELEFONE = '^[1-9]\d{9}$';
  REGEX_CELULAR = '^[1-9]\d9\d{8}$';

{ TValidacaoEstritaTelefone }

constructor TValidacaoEstritaTelefone.Create;
begin
  inherited Create('Telefone inválido');
end;

class function TValidacaoEstritaTelefone.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaTelefone.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := TRegEx.IsMatch(TRegEx.Replace(FValue.Value, '\D', ''), REGEX_TELEFONE);
end;

{ TValidacaoEstritaCelular }

constructor TValidacaoEstritaCelular.Create;
begin
  inherited Create('Celular inválido');
end;

class function TValidacaoEstritaCelular.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaCelular.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  if (FValue.Value.Trim = '') and not FRequerido then
    Exit(True);
  Result := TRegEx.IsMatch(TRegEx.Replace(FValue.Value, '\D', ''), REGEX_CELULAR);
end;

end.
