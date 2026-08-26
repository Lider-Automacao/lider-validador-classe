unit Validador.CNPJ;

interface

uses
  Validador.Types,
  Validador.Base;

type
  TValidacaoCNPJ = class(TValidacaoBase<Variant>) deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'
  private
    function TodosCaracteresIguais(const ACNPJ: string): Boolean;
    function ValidaDigitos(const ACNPJ: string): Boolean;
  public
    constructor Create; reintroduce;
    function Valido: Boolean; override;
    class function New: IValidacao<Variant>;
  end;

implementation

uses
  variants,
  System.SysUtils,
  System.RegularExpressions;

function TValidacaoCNPJ.TodosCaracteresIguais(const ACNPJ: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 2 to Length(ACNPJ) do
    if ACNPJ[I] <> ACNPJ[1] then
      Exit(False);
end;

function TValidacaoCNPJ.ValidaDigitos(const ACNPJ: string): Boolean;
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
      // CNPJ alfanumerico (rollout RF 2026): peso usa o valor ASCII do
      // caractere menos 48, nao StrToInt — cobre digitos (0-9) e letras
      // (A-Z) com a mesma formula.
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

constructor TValidacaoCNPJ.Create;
begin
 inherited Create('CNPJ Inválido');
end;

class function TValidacaoCNPJ.New: IValidacao<Variant>;
begin
  Result := Self.Create;
end;

function TValidacaoCNPJ.Valido: Boolean;
var
  LCNPJ: string;
begin
  if VarIsNull(FValue) then
    Exit(not FRequerido);

  // Os digitos verificadores (posicoes 13-14) continuam sempre numericos;
  // as 12 primeiras posicoes aceitam digito ou letra maiuscula (CNPJ
  // alfanumerico). Remove so a mascara (.,/,-) antes de validar.
  LCNPJ := TRegEx.Replace(VarToStr(FValue), '[^0-9A-Za-z]', '').ToUpper;

  Result := TRegEx.IsMatch(LCNPJ, '^[0-9A-Z]{12}\d{2}$') and ValidaDigitos(LCNPJ);
end;

end.
