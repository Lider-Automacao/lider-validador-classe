unit Validador.Vazio;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoEstaVazio = class(TValidacaoBase<String>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<String>;
  end;

  TValidacaoNaoEstaVazio = class(TValidacaoBase<String>)
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<String>;
  end;

implementation

uses
  System.SysUtils, variants;

constructor TValidacaoEstaVazio.Create;
begin
  inherited Create('Deve ser Vazio');
end;

class function TValidacaoEstaVazio.New: IValidacao<String>;
begin
  Result := Self.Create;
end;

function TValidacaoEstaVazio.Valido: Boolean;
begin
 if VarIsNull(FValue) and not FRequerido then
    Exit(True);

  Result := Trim(FValue).IsEmpty;
end;

{ TValidacaoNaoEstaVazio }

constructor TValidacaoNaoEstaVazio.Create;
begin
  inherited Create('Não deve ser Vazio');
end;

class function TValidacaoNaoEstaVazio.New: IValidacao<String>;
begin
  Result := Self.Create;
end;

function TValidacaoNaoEstaVazio.Valido: Boolean;
begin
 if VarIsNull(FValue) and not FRequerido then
    Exit(True);

  Result := not Trim(FValue).IsEmpty;
end;

end.
