unit Validador.Estrito.Inteiro;

interface

uses
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  TValidadorInteiro = class
  private
    FRegras: TList<IValidacaoEstrita<Integer>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TValidadorInteiro;

    function Requerido(aMensagem: string = ''): TValidadorInteiro;
    function Nullable: TValidadorInteiro;

    function MaiorQue(const aComparacao: Integer; aMensagem: string = ''): TValidadorInteiro;
    function MaiorQueOuIgual(const aComparacao: Integer; aMensagem: string = ''): TValidadorInteiro;
    function MenorQue(const aComparacao: Integer; aMensagem: string = ''): TValidadorInteiro;
    function MenorQueOuIgual(const aComparacao: Integer; aMensagem: string = ''): TValidadorInteiro;
    function Entre(const aMinimo, aMaximo: Integer; aMensagem: string = ''): TValidadorInteiro;
    function Igual(const aComparacao: Integer; aMensagem: string = ''): TValidadorInteiro;

    function Valida(const aValor: TNullable<Integer>): TValidadorInteiro;
    function Valido: Boolean;
    function Mensagem: string;
  end;

implementation

uses
  Validador.Estrito.Requerido,
  Validador.Estrito.Comparacao;

constructor TValidadorInteiro.Create;
begin
  FRegras := TList<IValidacaoEstrita<Integer>>.Create;
  FRequerido := False;
end;

destructor TValidadorInteiro.Destroy;
begin
  FRegras.Free;
  inherited;
end;

class function TValidadorInteiro.New: TValidadorInteiro;
begin
  Result := TValidadorInteiro.Create;
end;

function TValidadorInteiro.Requerido(aMensagem: string): TValidadorInteiro;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<Integer>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorInteiro.Nullable: TValidadorInteiro;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorInteiro.MaiorQue(const aComparacao: Integer; aMensagem: string): TValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMaiorQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.MaiorQueOuIgual(const aComparacao: Integer; aMensagem: string): TValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMaiorOuIgualQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.MenorQue(const aComparacao: Integer; aMensagem: string): TValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMenorQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.MenorQueOuIgual(const aComparacao: Integer; aMensagem: string): TValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMenorOuIgualQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.Entre(const aMinimo, aMaximo: Integer; aMensagem: string): TValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaEntre<Integer>.New(aMinimo, aMaximo).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.Igual(const aComparacao: Integer; aMensagem: string): TValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaIgual<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.Valida(const aValor: TNullable<Integer>): TValidadorInteiro;
var
  LRegra: IValidacaoEstrita<Integer>;
begin
  for LRegra in FRegras do
    LRegra.Valida(aValor);
  Result := Self;
end;

function TValidadorInteiro.Valido: Boolean;
var
  LRegra: IValidacaoEstrita<Integer>;
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

function TValidadorInteiro.Mensagem: string;
begin
  Result := FMensagemFalha;
end;

end.
