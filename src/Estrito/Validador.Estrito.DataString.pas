unit Validador.Estrito.DataString;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaDataString = class(TValidacaoEstritaBase<string>)
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
  REGEX_DATA =
      '^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)'+
      '(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)'+
      '0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|'+
      '^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';

constructor TValidacaoEstritaDataString.Create;
begin
  inherited Create('Data inválida');
end;

class function TValidacaoEstritaDataString.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaDataString.Valido: Boolean;
var
  LValor: string;
  LNormalizada: string;
  LFormato: TFormatSettings;
  LData: TDateTime;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);

  LValor := FValue.Value.Trim;

  if LValor = '' then
    Exit(not FRequerido);

  if not TRegEx.IsMatch(LValor, REGEX_DATA) then
    Exit(False);

  LNormalizada := LValor.Replace('-', '/').Replace('.', '/');

  LFormato := TFormatSettings.Create;
  LFormato.ShortDateFormat := 'dd/mm/yyyy';
  LFormato.DateSeparator := '/';

  Result := TryStrToDate(LNormalizada, LData, LFormato);
end;

end.
