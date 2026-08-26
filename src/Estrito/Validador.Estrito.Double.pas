unit Validador.Estrito.Double;

interface

uses
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  TValidadorDouble = class
  private
    FRegras: TList<IValidacaoEstrita<Double>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TValidadorDouble;

    function Requerido(aMensagem: string = ''): TValidadorDouble;
    function Nullable: TValidadorDouble;

    function MaiorQue(const aComparacao: Double; aMensagem: string = ''): TValidadorDouble;
    function MaiorQueOuIgual(const aComparacao: Double; aMensagem: string = ''): TValidadorDouble;
    function MenorQue(const aComparacao: Double; aMensagem: string = ''): TValidadorDouble;
    function MenorQueOuIgual(const aComparacao: Double; aMensagem: string = ''): TValidadorDouble;
    function Entre(const aMinimo, aMaximo: Double; aMensagem: string = ''): TValidadorDouble;
    function Igual(const aComparacao: Double; aMensagem: string = ''): TValidadorDouble;

    function Valida(const aValor: TNullable<Double>): TValidadorDouble;
    function Valido: Boolean;
    function Mensagem: string;
  end;

implementation

uses
  Validador.Estrito.Requerido,
  Validador.Estrito.Comparacao;

constructor TValidadorDouble.Create;
begin
  FRegras := TList<IValidacaoEstrita<Double>>.Create;
  FRequerido := False;
end;

destructor TValidadorDouble.Destroy;
begin
  FRegras.Free;
  inherited;
end;

class function TValidadorDouble.New: TValidadorDouble;
begin
  Result := TValidadorDouble.Create;
end;

function TValidadorDouble.Requerido(aMensagem: string): TValidadorDouble;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<Double>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorDouble.Nullable: TValidadorDouble;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorDouble.MaiorQue(const aComparacao: Double; aMensagem: string): TValidadorDouble;
begin
  FRegras.Add(TValidacaoEstritaMaiorQue<Double>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorDouble.MaiorQueOuIgual(const aComparacao: Double; aMensagem: string): TValidadorDouble;
begin
  FRegras.Add(TValidacaoEstritaMaiorOuIgualQue<Double>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorDouble.MenorQue(const aComparacao: Double; aMensagem: string): TValidadorDouble;
begin
  FRegras.Add(TValidacaoEstritaMenorQue<Double>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorDouble.MenorQueOuIgual(const aComparacao: Double; aMensagem: string): TValidadorDouble;
begin
  FRegras.Add(TValidacaoEstritaMenorOuIgualQue<Double>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorDouble.Entre(const aMinimo, aMaximo: Double; aMensagem: string): TValidadorDouble;
begin
  FRegras.Add(TValidacaoEstritaEntre<Double>.New(aMinimo, aMaximo).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorDouble.Igual(const aComparacao: Double; aMensagem: string): TValidadorDouble;
begin
  FRegras.Add(TValidacaoEstritaIgual<Double>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorDouble.Valida(const aValor: TNullable<Double>): TValidadorDouble;
var
  LRegra: IValidacaoEstrita<Double>;
begin
  for LRegra in FRegras do
    LRegra.Valida(aValor);
  Result := Self;
end;

function TValidadorDouble.Valido: Boolean;
var
  LRegra: IValidacaoEstrita<Double>;
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

function TValidadorDouble.Mensagem: string;
begin
  Result := FMensagemFalha;
end;

end.
