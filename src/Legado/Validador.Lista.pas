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
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';

implementation

uses
  System.SysUtils,
  Variants,
  System.JSON,
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
  vErros: TJSONArray;
  vErro: TJSONObject;
  vErroAninhado: TJSONValue;
  vErrorCount: Integer;
begin
  vErrorCount := 0;
  FMensagem := '';
  Result := True;

  vErros := TJSONArray.Create;
  try
    for vIndex := 0 to Pred(FValue.Count) do
    begin
      vItem := FValue[vIndex];
      FValidacao.Valida(vItem);

      if not FValidacao.Valido then
      begin
        vErrorCount := vErrorCount + 1;

        if Trim(FValidacao.Mensagem).IsEmpty then
          Continue;

        vErro := TJSONObject.Create;
        vErro.AddPair('index', TJSONNumber.Create(vIndex));

        if FValidacao.Mensagem.StartsWith('{') or
          FValidacao.Mensagem.StartsWith('[') then
        begin
          vErroAninhado := TJSONObject.ParseJSONValue(FValidacao.Mensagem);
          if Assigned(vErroAninhado) then
            vErro.AddPair('error', vErroAninhado)
          else
            vErro.AddPair('error', FValidacao.Mensagem);
        end
        else
          vErro.AddPair('error', FValidacao.Mensagem);

        vErros.Add(vErro);
      end;
    end;

    Result := vErrorCount = 0;

    if not Result then
      FMensagem := vErros.ToJSON;

  finally
    vErros.Free;
  end;
end;

end.
