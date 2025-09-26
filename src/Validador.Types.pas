unit Validador.Types;

interface

uses
  System.Classes, System.SysUtils;

type
  IValidacaoBase = interface
    ['{338C5DA7-E6A3-4355-8912-FEAB286C12F6}']
    function Mensagem: string; overload;
    function Propriedade: string; overload;
    function Valido: Boolean;
    procedure VerificaErro;
  end;

  IValidacao<T> = interface(IValidacaoBase)
    ['{AA0319D2-DFA9-4C53-9D47-EB3C1195AFE9}']
    function Requerido(const aRequerido: Boolean): IValidacao<T>;
    function Propriedade(const aPropriedade: string): IValidacao<T>;
    function Valida(const aValue: T): IValidacao<T>;
    function Mensagem(const aMensagem: string): IValidacao<T>; overload;
  end;

  IExecutorValidador = interface
    ['{1D6C10A5-E177-4561-8C3B-4197AC1AA819}']
    function Valido: Boolean;
    function Errors: String;
    procedure VerificaErro;
    procedure VerificaTodosErro;
    function Add(aComando: IValidacaoBase): IExecutorValidador;
  end;

  TValidadorException = class(Exception)
  end;

  TExecutorValidador = class(TInterfacedObject, IExecutorValidador)
  private
    FValidacoes: TInterfaceList;
  public
    function Add(aComando: IValidacaoBase): IExecutorValidador;
    function Valido: Boolean;

    function Errors: String;
    procedure VerificaErro;
    procedure VerificaTodosErro;

    constructor Create;

    class function New: IExecutorValidador;
    destructor Destroy; override;
  end;

implementation

uses
  System.JSON.Writers,
  System.JSON.Types,
  System.StrUtils,
  System.Variants;

function TExecutorValidador.Add(aComando: IValidacaoBase): IExecutorValidador;
begin
  FValidacoes.Add(aComando);
  Result := Self;
end;

constructor TExecutorValidador.Create;
begin
  FValidacoes := TInterfaceList.Create;
end;

destructor TExecutorValidador.Destroy;
begin
  FValidacoes.Clear;
  if Assigned(FValidacoes) then
    FreeAndNil(FValidacoes);
  inherited;
end;

function TExecutorValidador.Errors: String;
var
  vContador: integer;
  vValidacao: IValidacaoBase;
  vStringWriter: TStringWriter;
  vJsonTextWriter: TJsonTextWriter;
  vErrorCount: integer;
begin
  Result := '';
  vErrorCount := 0;

  vStringWriter := TStringWriter.Create;
  vJsonTextWriter := TJsonTextWriter.Create(vStringWriter);

  try
    vJsonTextWriter.WriteStartArray;
    for vContador := 0 to Pred(FValidacoes.Count) do
    begin
      vValidacao := IValidacaoBase(FValidacoes[vContador]);
      if not vValidacao.Valido then
      begin
        vErrorCount := vErrorCount + 1;

        if Trim(vValidacao.Mensagem).IsEmpty then
          Continue;

        vJsonTextWriter.WriteStartObject;
        vJsonTextWriter.WritePropertyName('field');
        vJsonTextWriter.WriteValue(vValidacao.Propriedade);
        vJsonTextWriter.WritePropertyName('error');

        if vValidacao.Mensagem.StartsWith('{') or
          vValidacao.Mensagem.StartsWith('[') then
          vJsonTextWriter.WriteRaw(vValidacao.Mensagem)
        else
          vJsonTextWriter.WriteValue(vValidacao.Mensagem);

        vJsonTextWriter.WriteEndObject;
      end;
    end;

    vJsonTextWriter.WriteEndArray;

    if vErrorCount = 0 then
      Exit('');

    Result := vStringWriter.ToString.Replace('null','');

  finally
    FreeAndNil(vJsonTextWriter);
    FreeAndNil(vStringWriter);
  end;
end;

class function TExecutorValidador.New: IExecutorValidador;
begin
  Result := Self.Create;
end;

function TExecutorValidador.Valido: Boolean;
var
  Contador: integer;
begin
  Result := True;
  for Contador := 0 to Pred(FValidacoes.Count) do
  begin
    if not IValidacaoBase(FValidacoes[Contador]).Valido then
      Exit(False);
  end;
end;

procedure TExecutorValidador.VerificaErro;
var
  Contador: integer;
begin
  for Contador := 0 to Pred(FValidacoes.Count) do
    IValidacaoBase(FValidacoes[Contador]).VerificaErro;
end;

procedure TExecutorValidador.VerificaTodosErro;
var
  vErrors: string;
begin
  vErrors := Errors.Trim;
  if vErrors.Length > 0 then
    raise TValidadorException.Create(vErrors);
end;

end.

