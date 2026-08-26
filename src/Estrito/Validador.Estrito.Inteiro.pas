unit Validador.Estrito.Inteiro;

interface

uses
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  IValidadorInteiro = interface
    ['{6F727746-CE84-4443-A87B-D53B9C2C3574}']
    function Requerido(aMensagem: string = ''): IValidadorInteiro;
    function Nullable: IValidadorInteiro;

    function MaiorQue(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function MaiorQueOuIgual(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function MenorQue(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function MenorQueOuIgual(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function Entre(const aMinimo, aMaximo: Integer; aMensagem: string = ''): IValidadorInteiro;
    function Igual(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;

    function Valida(const aValor: TNullable<Integer>): IValidadorInteiro;
    function Valido: Boolean;
    function Mensagem: string;
  end;

  TValidadorInteiro = class(TInterfacedObject, IValidadorInteiro)
  private
    FRegras: TList<IValidacaoEstrita<Integer>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IValidadorInteiro;

    function Requerido(aMensagem: string = ''): IValidadorInteiro;
    function Nullable: IValidadorInteiro;

    function MaiorQue(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function MaiorQueOuIgual(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function MenorQue(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function MenorQueOuIgual(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;
    function Entre(const aMinimo, aMaximo: Integer; aMensagem: string = ''): IValidadorInteiro;
    function Igual(const aComparacao: Integer; aMensagem: string = ''): IValidadorInteiro;

    function Valida(const aValor: TNullable<Integer>): IValidadorInteiro;
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

class function TValidadorInteiro.New: IValidadorInteiro;
begin
  Result := TValidadorInteiro.Create;
end;

function TValidadorInteiro.Requerido(aMensagem: string): IValidadorInteiro;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<Integer>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorInteiro.Nullable: IValidadorInteiro;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorInteiro.MaiorQue(const aComparacao: Integer; aMensagem: string): IValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMaiorQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.MaiorQueOuIgual(const aComparacao: Integer; aMensagem: string): IValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMaiorOuIgualQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.MenorQue(const aComparacao: Integer; aMensagem: string): IValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMenorQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.MenorQueOuIgual(const aComparacao: Integer; aMensagem: string): IValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaMenorOuIgualQue<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.Entre(const aMinimo, aMaximo: Integer; aMensagem: string): IValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaEntre<Integer>.New(aMinimo, aMaximo).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.Igual(const aComparacao: Integer; aMensagem: string): IValidadorInteiro;
begin
  FRegras.Add(TValidacaoEstritaIgual<Integer>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorInteiro.Valida(const aValor: TNullable<Integer>): IValidadorInteiro;
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
