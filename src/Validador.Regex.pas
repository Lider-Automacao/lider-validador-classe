unit Validador.Regex;

interface

uses
  variants,
  Validador.Types,
  Validador.Base;

type
  TValidacaoRegex = class(TValidacaoBase<String>)
  private
    FRegex: String;
  public
    constructor Create(aRegex: String); reintroduce;
    function Valido: Boolean; override;
    function Valida(const aValue: String): IValidacao<String>; override;
    class function New(aRegex: String): IValidacao<String>;
  end;

implementation

uses
  System.SysUtils, System.RegularExpressions;

constructor TValidacaoRegex.Create(aRegex: String);
begin
  inherited Create('Valor não condiz com o padrão');
  FRegex := aRegex;
end;

class function TValidacaoRegex.New(aRegex: String): IValidacao<String>;
begin
  Result := Self.Create(aRegex);
end;

function TValidacaoRegex.Valida(const aValue: String): IValidacao<String>;
begin
  Result := Self;
  inherited Valida(aValue);
  FMensagem := Format('Valor %s condiz com o padrão %s',[VarToStr(FValue),FRegex])
end;

function TValidacaoRegex.Valido: Boolean;
begin
 if VarIsNull(FValue) and not FRequerido then
    Exit(True);

 if (FValue.Trim = '') and not FRequerido then
    Exit(True);

  Result := TRegex.create(FRegex).IsMatch(FValue);
end;


end.
