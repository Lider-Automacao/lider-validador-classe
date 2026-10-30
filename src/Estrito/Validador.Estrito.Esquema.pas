unit Validador.Estrito.Esquema;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Validador.Estrito.Types,
  Validador.Estrito.Strings,
  Validador.Estrito.Double,
  Validador.Estrito.Inteiro,
  Validador.Estrito.Int64,
  Validador.Estrito.Data;

const
  C_SEPARADOR_CAMINHO = '.';
  C_FORMATO_ITEM = '%s[%d]';

type
  EValidadorEsquema = class(Exception);

  TErroCampo = record
    Caminho: string;
    Mensagem: string;
  end;

function JuntaCaminho(const aPrefixo, aNome: string): string;
function NovoErro(const aCaminho, aMensagem: string): TErroCampo;

type
  IResultadoEsquema = interface
    function Valido: Boolean;
    function Erros: TArray<TErroCampo>;
    function ComoJson: string;
    procedure VerificaErro;
  end;

  TResultadoEsquema = class(TInterfacedObject, IResultadoEsquema)
  strict private
    FErros: TArray<TErroCampo>;
  public
    constructor Create(const aErros: TArray<TErroCampo>);
    function Valido: Boolean;
    function Erros: TArray<TErroCampo>;
    function ComoJson: string;
    procedure VerificaErro;
  end;

  IRegraCampo<T: class> = interface
    procedure Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
  end;

  IEsquema<T: class> = interface(IRegraCampo<T>)
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<string>>;
      const aValidador: TFunc<IValidadorString>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Double>>;
      const aValidador: TFunc<IValidadorDouble>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Integer>>;
      const aValidador: TFunc<IValidadorInteiro>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Int64>>;
      const aValidador: TFunc<IValidadorInt64>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<TDateTime>>;
      const aValidador: TFunc<IValidadorData>): IEsquema<T>; overload;
    function Regra(const aRegra: IRegraCampo<T>): IEsquema<T>;
    function Valida(const aObjeto: T): IResultadoEsquema;
  end;

  TRegraVerificacao<T: class> = class(TInterfacedObject, IRegraCampo<T>)
  strict private
    FNome: string;
    FVerifica: TFunc<T, string>;
  public
    constructor Create(const aNome: string; const aVerifica: TFunc<T, string>);
    procedure Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
  end;

  TEsquema<T: class> = class(TInterfacedObject, IEsquema<T>)
  strict private
    FRegras: TList<IRegraCampo<T>>;
    function Verificacao(const aNome: string; const aVerifica: TFunc<T, string>): IEsquema<T>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IEsquema<T>;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<string>>;
      const aValidador: TFunc<IValidadorString>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Double>>;
      const aValidador: TFunc<IValidadorDouble>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Integer>>;
      const aValidador: TFunc<IValidadorInteiro>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Int64>>;
      const aValidador: TFunc<IValidadorInt64>): IEsquema<T>; overload;
    function Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<TDateTime>>;
      const aValidador: TFunc<IValidadorData>): IEsquema<T>; overload;
    function Regra(const aRegra: IRegraCampo<T>): IEsquema<T>;
    function Valida(const aObjeto: T): IResultadoEsquema;
    procedure Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
  end;

  TCampoObjeto<T: class; TFilho: class> = class(TInterfacedObject, IRegraCampo<T>)
  strict private
    FNome: string;
    FLeitor: TFunc<T, TFilho>;
    FEsquema: IEsquema<TFilho>;
  public
    constructor Create(const aNome: string; const aLeitor: TFunc<T, TFilho>; const aEsquema: IEsquema<TFilho>);
    class function New(const aNome: string; const aLeitor: TFunc<T, TFilho>;
      const aEsquema: IEsquema<TFilho>): IRegraCampo<T>;
    procedure Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
  end;

  TCampoLista<T: class; TFilho: class> = class(TInterfacedObject, IRegraCampo<T>)
  strict private
    FNome: string;
    FLeitor: TFunc<T, TArray<TFilho>>;
    FEsquema: IEsquema<TFilho>;
  public
    constructor Create(const aNome: string; const aLeitor: TFunc<T, TArray<TFilho>>;
      const aEsquema: IEsquema<TFilho>);
    class function New(const aNome: string; const aLeitor: TFunc<T, TArray<TFilho>>;
      const aEsquema: IEsquema<TFilho>): IRegraCampo<T>;
    procedure Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
  end;

implementation

uses
  System.JSON;

const
  C_CHAVE_CAMPO = 'field';
  C_CHAVE_ERRO = 'error';

function JuntaCaminho(const aPrefixo, aNome: string): string;
begin
  if aPrefixo.IsEmpty then
    Result := aNome
  else
    Result := aPrefixo + C_SEPARADOR_CAMINHO + aNome;
end;

function NovoErro(const aCaminho, aMensagem: string): TErroCampo;
begin
  Result.Caminho := aCaminho;
  Result.Mensagem := aMensagem;
end;

{ TResultadoEsquema }

constructor TResultadoEsquema.Create(const aErros: TArray<TErroCampo>);
begin
  inherited Create;
  FErros := aErros;
end;

function TResultadoEsquema.Valido: Boolean;
begin
  Result := Length(FErros) = 0;
end;

function TResultadoEsquema.Erros: TArray<TErroCampo>;
begin
  Result := FErros;
end;

function TResultadoEsquema.ComoJson: string;
var
  LLista: TJSONArray;
  LItem: TJSONObject;
  LErro: TErroCampo;
begin
  if Valido then
    Exit('');
  LLista := TJSONArray.Create;
  try
    for LErro in FErros do
    begin
      LItem := TJSONObject.Create;
      LItem.AddPair(C_CHAVE_CAMPO, LErro.Caminho);
      LItem.AddPair(C_CHAVE_ERRO, LErro.Mensagem);
      LLista.Add(LItem);
    end;
    Result := LLista.ToJSON;
  finally
    LLista.Free;
  end;
end;

procedure TResultadoEsquema.VerificaErro;
begin
  if not Valido then
    raise EValidadorEsquema.Create(ComoJson);
end;

{ TRegraVerificacao<T> }

constructor TRegraVerificacao<T>.Create(const aNome: string; const aVerifica: TFunc<T, string>);
begin
  inherited Create;
  FNome := aNome;
  FVerifica := aVerifica;
end;

procedure TRegraVerificacao<T>.Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
var
  LMensagem: string;
begin
  LMensagem := FVerifica(aObjeto);
  if not LMensagem.IsEmpty then
    aErros.Add(NovoErro(JuntaCaminho(aPrefixo, FNome), LMensagem));
end;

{ TEsquema<T> }

constructor TEsquema<T>.Create;
begin
  inherited Create;
  FRegras := TList<IRegraCampo<T>>.Create;
end;

destructor TEsquema<T>.Destroy;
begin
  FRegras.Free;
  inherited;
end;

class function TEsquema<T>.New: IEsquema<T>;
begin
  Result := Self.Create;
end;

function TEsquema<T>.Verificacao(const aNome: string; const aVerifica: TFunc<T, string>): IEsquema<T>;
begin
  Result := Regra(TRegraVerificacao<T>.Create(aNome, aVerifica));
end;

function TEsquema<T>.Regra(const aRegra: IRegraCampo<T>): IEsquema<T>;
begin
  FRegras.Add(aRegra);
  Result := Self;
end;

function TEsquema<T>.Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<string>>;
  const aValidador: TFunc<IValidadorString>): IEsquema<T>;
begin
  Result := Verificacao(aNome,
    function(aObjeto: T): string
    var
      LValidador: IValidadorString;
    begin
      LValidador := aValidador().Valida(aLeitor(aObjeto));
      if LValidador.Valido then
        Result := ''
      else
        Result := LValidador.Mensagem;
    end);
end;

function TEsquema<T>.Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Double>>;
  const aValidador: TFunc<IValidadorDouble>): IEsquema<T>;
begin
  Result := Verificacao(aNome,
    function(aObjeto: T): string
    var
      LValidador: IValidadorDouble;
    begin
      LValidador := aValidador().Valida(aLeitor(aObjeto));
      if LValidador.Valido then
        Result := ''
      else
        Result := LValidador.Mensagem;
    end);
end;

function TEsquema<T>.Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Integer>>;
  const aValidador: TFunc<IValidadorInteiro>): IEsquema<T>;
begin
  Result := Verificacao(aNome,
    function(aObjeto: T): string
    var
      LValidador: IValidadorInteiro;
    begin
      LValidador := aValidador().Valida(aLeitor(aObjeto));
      if LValidador.Valido then
        Result := ''
      else
        Result := LValidador.Mensagem;
    end);
end;

function TEsquema<T>.Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<Int64>>;
  const aValidador: TFunc<IValidadorInt64>): IEsquema<T>;
begin
  Result := Verificacao(aNome,
    function(aObjeto: T): string
    var
      LValidador: IValidadorInt64;
    begin
      LValidador := aValidador().Valida(aLeitor(aObjeto));
      if LValidador.Valido then
        Result := ''
      else
        Result := LValidador.Mensagem;
    end);
end;

function TEsquema<T>.Campo(const aNome: string; const aLeitor: TFunc<T, TNullable<TDateTime>>;
  const aValidador: TFunc<IValidadorData>): IEsquema<T>;
begin
  Result := Verificacao(aNome,
    function(aObjeto: T): string
    var
      LValidador: IValidadorData;
    begin
      LValidador := aValidador().Valida(aLeitor(aObjeto));
      if LValidador.Valido then
        Result := ''
      else
        Result := LValidador.Mensagem;
    end);
end;

procedure TEsquema<T>.Coleta(const aObjeto: T; const aPrefixo: string; const aErros: TList<TErroCampo>);
var
  LRegra: IRegraCampo<T>;
begin
  for LRegra in FRegras do
    LRegra.Coleta(aObjeto, aPrefixo, aErros);
end;

function TEsquema<T>.Valida(const aObjeto: T): IResultadoEsquema;
var
  LErros: TList<TErroCampo>;
begin
  LErros := TList<TErroCampo>.Create;
  try
    Coleta(aObjeto, '', LErros);
    Result := TResultadoEsquema.Create(LErros.ToArray);
  finally
    LErros.Free;
  end;
end;

{ TCampoObjeto<T, TFilho> }

constructor TCampoObjeto<T, TFilho>.Create(const aNome: string; const aLeitor: TFunc<T, TFilho>;
  const aEsquema: IEsquema<TFilho>);
begin
  inherited Create;
  FNome := aNome;
  FLeitor := aLeitor;
  FEsquema := aEsquema;
end;

class function TCampoObjeto<T, TFilho>.New(const aNome: string; const aLeitor: TFunc<T, TFilho>;
  const aEsquema: IEsquema<TFilho>): IRegraCampo<T>;
begin
  Result := Self.Create(aNome, aLeitor, aEsquema);
end;

procedure TCampoObjeto<T, TFilho>.Coleta(const aObjeto: T; const aPrefixo: string;
  const aErros: TList<TErroCampo>);
var
  LFilho: TFilho;
begin
  LFilho := FLeitor(aObjeto);
  if Assigned(LFilho) then
    FEsquema.Coleta(LFilho, JuntaCaminho(aPrefixo, FNome), aErros);
end;

{ TCampoLista<T, TFilho> }

constructor TCampoLista<T, TFilho>.Create(const aNome: string; const aLeitor: TFunc<T, TArray<TFilho>>;
  const aEsquema: IEsquema<TFilho>);
begin
  inherited Create;
  FNome := aNome;
  FLeitor := aLeitor;
  FEsquema := aEsquema;
end;

class function TCampoLista<T, TFilho>.New(const aNome: string; const aLeitor: TFunc<T, TArray<TFilho>>;
  const aEsquema: IEsquema<TFilho>): IRegraCampo<T>;
begin
  Result := Self.Create(aNome, aLeitor, aEsquema);
end;

procedure TCampoLista<T, TFilho>.Coleta(const aObjeto: T; const aPrefixo: string;
  const aErros: TList<TErroCampo>);
var
  LItens: TArray<TFilho>;
  LIndice: Integer;
  LCaminho: string;
begin
  LItens := FLeitor(aObjeto);
  LCaminho := JuntaCaminho(aPrefixo, FNome);
  for LIndice := 0 to High(LItens) do
    if Assigned(LItens[LIndice]) then
      FEsquema.Coleta(LItens[LIndice], Format(C_FORMATO_ITEM, [LCaminho, LIndice]), aErros);
end;

end.
