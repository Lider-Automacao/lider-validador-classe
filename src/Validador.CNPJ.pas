unit Validador.CNPJ;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoCNPJ = class(TValidacaoBase<String>)
  private
    function ValidaDigitos(const ACNPJ: string): Boolean;
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<String>;
  end;

implementation

uses
  variants,
  System.SysUtils,
  System.RegularExpressions;

 function TValidacaoCNPJ.ValidaDigitos(const ACNPJ: string): Boolean;
var
  LCNPJ: string;
  LSum: Integer;
  LPeso: Integer;
  I: Integer;
  LResultSum: Integer;
  LDig13: String;
  LDig14: String;
begin
 if VarIsNull(FValue) and not FRequerido then
    Exit(True);

  Result := False;

  LCNPJ := TRegEx.Replace(ACNPJ, '\D', '');

  if ((LCNPJ = '00000000000000') or (LCNPJ = '11111111111111') or (LCNPJ = '22222222222222') or (LCNPJ = '33333333333333') or
    (LCNPJ = '44444444444444') or (LCNPJ = '55555555555555') or (LCNPJ = '66666666666666') or (LCNPJ = '77777777777777') or
    (LCNPJ = '88888888888888') or (LCNPJ = '99999999999999') or (Length(LCNPJ) <> 14)) then
    Exit;

  try
    LSum := 0;
    LPeso := 2;

    for I := 12 downto 1 do
    begin
      LSum := LSum + (StrToInt(LCNPJ[I]) * LPeso);
      LPeso := LPeso + 1;

      if (LPeso = 10) then
        LPeso := 2;
    end;

    LResultSum := LSum mod 11;

    if ((LResultSum = 0) or (LResultSum = 1)) then
      LDig13 := '0'
    else
      str((11 - LResultSum): 1, LDig13);

    LSum := 0;
    LPeso := 2;

    for I := 13 downto 1 do
    begin
      LSum := LSum + (StrToInt(LCNPJ[I]) * LPeso);
      LPeso := LPeso + 1;

      if (LPeso = 10) then
        LPeso := 2;
    end;

    LResultSum := LSum mod 11;

    if ((LResultSum = 0) or (LResultSum = 1)) then
      LDig14 := '0'
    else
      str((11 - LResultSum): 1, LDig14);

    Result := (LDig13 = String(LCNPJ[13])) and (LDig14 = String(LCNPJ[14]));
  except
    Result := False
  end;
end;

constructor TValidacaoCNPJ.Create;
begin
 inherited Create('CNPJ Inválido');
end;

class function TValidacaoCNPJ.New: IValidacao<String>;
begin
  Result := Self.Create;
end;

function TValidacaoCNPJ.Valido: Boolean;
begin
  Result := TRegEx.IsMatch(FValue, '^(\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}|\d{14})$') and ValidaDigitos(FValue);
end;

end.
