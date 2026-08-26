unit Validador.Estrito.CPF;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaCPF = class(TValidacaoEstritaBase<string>)
  private
    function ValidaDigitos(const ACPF: string): Boolean;
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions;

function TValidacaoEstritaCPF.ValidaDigitos(const ACPF: string): Boolean;
var
  LCPF: string;
  LSum: Integer;
  LPeso: Integer;
  I: Integer;
  LResultSum: Integer;
  LDig10: String;
  LDig11: String;
begin
  Result := False;

  LCPF := TRegEx.Replace(ACPF, '\D', '');

  if (
    (LCPF = '00000000000') or (LCPF = '11111111111') or
    (LCPF = '22222222222') or (LCPF = '33333333333') or
    (LCPF = '44444444444') or (LCPF = '55555555555') or
    (LCPF = '66666666666') or (LCPF = '77777777777') or
    (LCPF = '88888888888') or (LCPF = '99999999999') or
    (Length(LCPF) <> 11)
    )
  then
    Exit;

  try
    LSum := 0;
    LPeso := 10;

    for I := 1 to 9 do
    begin
      LSum := LSum + (StrToInt(LCPF[I]) * LPeso);
      LPeso := LPeso - 1;
    end;

    LResultSum := 11 - (LSum mod 11);

    if ((LResultSum = 10) or (LResultSum = 11)) then
      LDig10 := '0'
    else
      str(LResultSum: 1, LDig10);

    LSum := 0;
    LPeso := 11;

    for I := 1 to 10 do
    begin
      LSum := LSum + (StrToInt(LCPF[I]) * LPeso);
      LPeso := LPeso - 1;
    end;

    LResultSum := 11 - (LSum mod 11);

    if ((LResultSum = 10) or (LResultSum = 11)) then
      LDig11 := '0'
    else
      str(LResultSum: 1, LDig11);

    Result := (LDig10 = String(LCPF[10])) and (LDig11 = String(LCPF[11]));
  except
    Result := False
  end;
end;

constructor TValidacaoEstritaCPF.Create;
begin
  inherited Create('CPF inválido');
end;

class function TValidacaoEstritaCPF.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaCPF.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := TRegEx.IsMatch(FValue.Value, '^(\d{3}\.\d{3}\.\d{3}\-\d{2}|\d{11})$') and ValidaDigitos(FValue.Value);
end;

end.
