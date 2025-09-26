unit Validador.Lista;

interface

uses
  Validador,
  Validador.Types,
  Validador.Base,
  System.Generics.Collections;

type
  TValidacaoLista<T: class, constructor> = class
    (TValidacaoBase < TObjectList < T >> )
  private
    [week]
    FValidacao: IValidacao<T>;
  public
    function Valido: Boolean; override;
    constructor Create(const aValidacao: IValidacao<T>); reintroduce;
    class function New(const aValidacao: IValidacao<T>)
      : IValidacao<TObjectList<T>>;
  end;

implementation

uses
  System.SysUtils,
  Variants,
  System.JSON.Writers,
  System.JSON.Types,
  System.Classes, 
  System.StrUtils;

constructor TValidacaoLista<T>.Create(const aValidacao: IValidacao<T>);
begin
  inherited Create(aValidacao.Mensagem);
  FValidacao := aValidacao;
end;

class function TValidacaoLista<T>.New(const aValidacao: IValidacao<T>)
  : IValidacao<TObjectList<T>>;
begin
  Result := Self.Create(aValidacao);
end;

function TValidacaoLista<T>.Valido: Boolean;
var
  vItem: T;
  vIndex: Integer;
  vStringWriter: TStringWriter;
  vJsonTextWriter: TJsonTextWriter;
  vErrorCount: Integer;
begin
  vErrorCount := 0;
  FMensagem := '';
  Result := True;

  vStringWriter := TStringWriter.Create;
  vJsonTextWriter := TJsonTextWriter.Create(vStringWriter);
  try
    vJsonTextWriter.WriteStartArray;
    for vIndex := 0 to Pred(FValue.Count) do
    begin
      vItem := FValue[vIndex];
      FValidacao.Valida(vItem);

      if not FValidacao.Valido then
      begin
        vErrorCount := vErrorCount + 1;

        if Trim(FValidacao.Mensagem).IsEmpty then
          Continue;

        vJsonTextWriter.WriteStartObject;
        vJsonTextWriter.WritePropertyName('index');
        vJsonTextWriter.WriteValue(vIndex);
        vJsonTextWriter.WritePropertyName('error');
        if FValidacao.Mensagem.StartsWith('{') or
          FValidacao.Mensagem.StartsWith('[') then
          vJsonTextWriter.WriteRaw(FValidacao.Mensagem)
        else
          vJsonTextWriter.WriteValue(FValidacao.Mensagem);
        vJsonTextWriter.WriteEndObject;
      end;
    end;

    vJsonTextWriter.WriteEndArray;

    Result := vErrorCount = 0;

    if not Result then
      FMensagem := Trim(vStringWriter.ToString).Replace('null','');

  finally
    FreeAndNil(vJsonTextWriter);
    FreeAndNil(vStringWriter);
  end;
end;

end.
