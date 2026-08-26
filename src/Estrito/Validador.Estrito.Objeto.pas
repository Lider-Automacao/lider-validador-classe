unit Validador.Estrito.Objeto;

interface

uses
  System.SysUtils,
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaObjeto<T: class> = class(TValidacaoEstritaBase<T>)
  private
    FPredicado: TFunc<T, Boolean>;
  public
    constructor Create(const aPredicado: TFunc<T, Boolean>; const aMensagem: string); reintroduce;
    function Valido: Boolean; override;
    class function New(const aPredicado: TFunc<T, Boolean>; const aMensagem: string): IValidacaoEstrita<T>;
  end;

  TValidacaoEstritaLista<T: class> = class(TValidacaoEstritaBase<TArray<T>>)
  private
    FValidacaoItem: IValidacaoEstrita<T>;
    FMensagemFalhas: string;
  public
    constructor Create(const aValidacaoItem: IValidacaoEstrita<T>); reintroduce;
    function Valido: Boolean; override;
    function Mensagem: string; reintroduce; overload;
    class function New(const aValidacaoItem: IValidacaoEstrita<T>): IValidacaoEstrita<TArray<T>>;
  end;

implementation

{ TValidacaoEstritaObjeto<T> }

constructor TValidacaoEstritaObjeto<T>.Create(const aPredicado: TFunc<T, Boolean>; const aMensagem: string);
begin
  inherited Create(aMensagem);
  FPredicado := aPredicado;
end;

class function TValidacaoEstritaObjeto<T>.New(const aPredicado: TFunc<T, Boolean>; const aMensagem: string): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aPredicado, aMensagem);
end;

function TValidacaoEstritaObjeto<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := FPredicado(FValue.Value);
end;

{ TValidacaoEstritaLista<T> }

constructor TValidacaoEstritaLista<T>.Create(const aValidacaoItem: IValidacaoEstrita<T>);
begin
  inherited Create(aValidacaoItem.Mensagem);
  FValidacaoItem := aValidacaoItem;
end;

class function TValidacaoEstritaLista<T>.New(const aValidacaoItem: IValidacaoEstrita<T>): IValidacaoEstrita<TArray<T>>;
begin
  Result := Self.Create(aValidacaoItem);
end;

function TValidacaoEstritaLista<T>.Valido: Boolean;
var
  I: Integer;
  LFalhas: TArray<string>;
begin
  FMensagemFalhas := '';

  if not FValue.HasValue then
    Exit(not FRequerido);

  SetLength(LFalhas, 0);

  for I := 0 to High(FValue.Value) do
  begin
    FValidacaoItem.Valida(FValue.Value[I]);
    if not FValidacaoItem.Valido then
      LFalhas := LFalhas + [Format('item %d: %s', [I, FValidacaoItem.Mensagem])];
  end;

  Result := Length(LFalhas) = 0;

  if not Result then
    FMensagemFalhas := String.Join('; ', LFalhas);
end;

function TValidacaoEstritaLista<T>.Mensagem: string;
begin
  if FMensagemFalhas <> '' then
    Exit(FMensagemFalhas);
  Result := inherited Mensagem;
end;

end.
