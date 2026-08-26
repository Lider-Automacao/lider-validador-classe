unit Validador.Estrito.CNPJ;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaCNPJ = class(TValidacaoEstritaBase<string>)
  private
    function TodosCaracteresIguais(const ACNPJ: string): Boolean;
    function ValidaDigitos(const ACNPJ: string): Boolean;
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacaoEstrita<string>;
  end;

implementation

uses
  System.SysUtils,
  System.RegularExpressions;

function TValidacaoEstritaCNPJ.TodosCaracteresIguais(const ACNPJ: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 2 to Length(ACNPJ) do
    if ACNPJ[I] <> ACNPJ[1] then
      Exit(False);
end;

function TValidacaoEstritaCNPJ.ValidaDigitos(const ACNPJ: string): Boolean;
var
  LSum: Integer;
  LPeso: Integer;
  I: Integer;
  LResultSum: Integer;
  LDig13: String;
  LDig14: String;
begin
  Result := False;

  if (Length(ACNPJ) <> 14) or TodosCaracteresIguais(ACNPJ) then
    Exit;

  try
    LSum := 0;
    LPeso := 2;

    for I := 12 downto 1 do
    begin
      LSum := LSum + ((Ord(ACNPJ[I]) - 48) * LPeso);
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
      LSum := LSum + ((Ord(ACNPJ[I]) - 48) * LPeso);
      LPeso := LPeso + 1;

      if (LPeso = 10) then
        LPeso := 2;
    end;

    LResultSum := LSum mod 11;

    if ((LResultSum = 0) or (LResultSum = 1)) then
      LDig14 := '0'
    else
      str((11 - LResultSum): 1, LDig14);

    Result := (LDig13 = String(ACNPJ[13])) and (LDig14 = String(ACNPJ[14]));
  except
    Result := False
  end;
end;

constructor TValidacaoEstritaCNPJ.Create;
begin
  inherited Create('CNPJ inválido');
end;

class function TValidacaoEstritaCNPJ.New: IValidacaoEstrita<string>;
begin
  Result := Self.Create;
end;

function TValidacaoEstritaCNPJ.Valido: Boolean;
var
  LCNPJ: string;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);

  LCNPJ := TRegEx.Replace(FValue.Value, '[^0-9A-Za-z]', '').ToUpper;

  Result := TRegEx.IsMatch(LCNPJ, '^[0-9A-Z]{12}\d{2}$') and ValidaDigitos(LCNPJ);
end;

end.
