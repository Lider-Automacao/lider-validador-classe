unit Validador.Estrito.Int64;

interface

uses
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  TValidadorInt64 = class
  private
    FRegras: TList<IValidacaoEstrita<Int64>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TValidadorInt64;

    function Requerido(aMensagem: string = ''): TValidadorInt64;
    function Nullable: TValidadorInt64;

    function MaiorQue(const aComparacao: Int64; aMensagem: string = ''): TValidadorInt64;
    function MaiorQueOuIgual(const aComparacao: Int64; aMensagem: string = ''): TValidadorInt64;
    function MenorQue(const aComparacao: Int64; aMensagem: string = ''): TValidadorInt64;
    function MenorQueOuIgual(const aComparacao: Int64; aMensagem: string = ''): TValidadorInt64;
    function Entre(const aMinimo, aMaximo: Int64; aMensagem: string = ''): TValidadorInt64;
    function Igual(const aComparacao: Int64; aMensagem: string = ''): TValidadorInt64;

    function Valida(const aValor: TNullable<Int64>): TValidadorInt64;
    function Valido: Boolean;
    function Mensagem: string;
  end;

implementation

uses
  Validador.Estrito.Requerido,
  Validador.Estrito.Comparacao;

constructor TValidadorInt64.Create;
begin
  FRegras := TList<IValidacaoEstrita<Int64>>.Create;
  FRequerido := False;
end;

destructor TValidadorInt64.Destroy;
begin
  FRegras.Free;
  inherited;
end;

class function TValidadorInt64.New: TValidadorInt64;
begin
  Result := TValidadorInt64.Create;
end;

function TValidadorInt64.Requerido(aMensagem: string): TValidadorInt64;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<Int64>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorInt64.Nullable: TValidadorInt64;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorInt64.MaiorQue(const aComparacao: Int64; aMensagem: string): TValidadorInt64;
begin
  FRegras.Add(TValidacaoEstritaMaiorQue<Int64>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInt64.MaiorQueOuIgual(const aComparacao: Int64; aMensagem: string): TValidadorInt64;
begin
  FRegras.Add(TValidacaoEstritaMaiorOuIgualQue<Int64>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInt64.MenorQue(const aComparacao: Int64; aMensagem: string): TValidadorInt64;
begin
  FRegras.Add(TValidacaoEstritaMenorQue<Int64>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInt64.MenorQueOuIgual(const aComparacao: Int64; aMensagem: string): TValidadorInt64;
begin
  FRegras.Add(TValidacaoEstritaMenorOuIgualQue<Int64>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInt64.Entre(const aMinimo, aMaximo: Int64; aMensagem: string): TValidadorInt64;
begin
  FRegras.Add(TValidacaoEstritaEntre<Int64>.New(aMinimo, aMaximo).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInt64.Igual(const aComparacao: Int64; aMensagem: string): TValidadorInt64;
begin
  FRegras.Add(TValidacaoEstritaIgual<Int64>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInt64.Valida(const aValor: TNullable<Int64>): TValidadorInt64;
var
  LRegra: IValidacaoEstrita<Int64>;
begin
  for LRegra in FRegras do
    LRegra.Valida(aValor);
  Result := Self;
end;

function TValidadorInt64.Valido: Boolean;
var
  LRegra: IValidacaoEstrita<Int64>;
begin
  Result := True;
  FMensagemFalha := '';
  for LRegra in FRegras do
    if not LRegra.Valido then
    begin
      Result := False;
      FMensagemFalha := LRegra.Mensagem;
      Exit;
    end;
end;

function TValidadorInt64.Mensagem: string;
begin
  Result := FMensagemFalha;
end;

end.
