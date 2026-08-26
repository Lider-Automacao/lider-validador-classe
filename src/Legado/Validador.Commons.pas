unit Validador.Commons;

interface

uses
  System.Types;

  function InStringToArray(const aValue: string): TIntegerDynArray;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.RegularExpressions;

  function InStringToArray(const aValue: string): TIntegerDynArray;
  var
    vOutput: TStringDynArray;
    vIndex, vLength: Integer;
  begin
    vOutput := SplitString(aValue.Trim, ',');
    vLength := Length(vOutput);

    SetLength(Result, vLength);

    if vLength = 0 then
     Exit;

    if not TRegex.create('^\d+(,\d+){0,}$').IsMatch(aValue.Trim) then
      raise Exception.create('O array deve conter apenas números inteiros');

    for vIndex := 0 to Pred(vLength) do
      Result[vIndex] := StrToInt(vOutput[vIndex]);
  end;

end.
