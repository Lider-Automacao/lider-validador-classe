unit Validador.DataString;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoDataString = class(TValidacaoBase<Variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions,
  Variants;

const
  // Checagem de formato (dd/mm/yyyy, dd-mm-yyyy ou dd.mm.yyyy) com limites
  // de dia por mes e ano bissexto ja embutidos na propria regex.
  REGEX_DATA =
      '^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)'+
      '(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)'+
      '0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|'+
      '^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';

constructor TValidacaoDataString.Create;
begin
  inherited Create('Data inválida');
end;

class function TValidacaoDataString.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoDataString.Valido: Boolean;
var
  LValor: string;
  LNormalizada: string;
  LFormato: TFormatSettings;
  LData: TDateTime;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  LValor := VarToStr(FValue).Trim;

  if LValor = '' then
    Exit(not FRequerido);

  // A regex ja cobre dia-por-mes e ano bissexto, mas o parse real via
  // TryStrToDate e a garantia definitiva de calendario valido (evita
  // depender so da regex pra casos de borda) — as duas checagens tem
  // que passar.
  if not TRegEx.IsMatch(LValor, REGEX_DATA) then
    Exit(False);

  LNormalizada := LValor.Replace('-', '/').Replace('.', '/');

  LFormato := TFormatSettings.Create;
  LFormato.ShortDateFormat := 'dd/mm/yyyy';
  LFormato.DateSeparator := '/';

  Result := TryStrToDate(LNormalizada, LData, LFormato);
end;

end.
