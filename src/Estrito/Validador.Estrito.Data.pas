unit Validador.Estrito.Data;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  TValidadorData = class
  private
    FRegras: TList<IValidacaoEstrita<TDateTime>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TValidadorData;

    function Requerido(aMensagem: string = ''): TValidadorData;
    function Nullable: TValidadorData;

    function MaiorQue(const aComparacao: TDateTime; aMensagem: string = ''): TValidadorData;
    function MaiorQueOuIgual(const aComparacao: TDateTime; aMensagem: string = ''): TValidadorData;
    function MenorQue(const aComparacao: TDateTime; aMensagem: string = ''): TValidadorData;
    function MenorQueOuIgual(const aComparacao: TDateTime; aMensagem: string = ''): TValidadorData;
    function Entre(const aMinimo, aMaximo: TDateTime; aMensagem: string = ''): TValidadorData;
    function Igual(const aComparacao: TDateTime; aMensagem: string = ''): TValidadorData;

    function Valida(const aValor: TNullable<TDateTime>): TValidadorData;
    function Valido: Boolean;
    function Mensagem: string;
  end;

implementation

uses
  Validador.Estrito.Requerido,
  Validador.Estrito.Comparacao;

constructor TValidadorData.Create;
begin
  FRegras := TList<IValidacaoEstrita<TDateTime>>.Create;
  FRequerido := False;
end;

destructor TValidadorData.Destroy;
begin
  FRegras.Free;
  inherited;
end;

class function TValidadorData.New: TValidadorData;
begin
  Result := TValidadorData.Create;
end;

function TValidadorData.Requerido(aMensagem: string): TValidadorData;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<TDateTime>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorData.Nullable: TValidadorData;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorData.MaiorQue(const aComparacao: TDateTime; aMensagem: string): TValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMaiorQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.MaiorQueOuIgual(const aComparacao: TDateTime; aMensagem: string): TValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMaiorOuIgualQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.MenorQue(const aComparacao: TDateTime; aMensagem: string): TValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMenorQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.MenorQueOuIgual(const aComparacao: TDateTime; aMensagem: string): TValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMenorOuIgualQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.Entre(const aMinimo, aMaximo: TDateTime; aMensagem: string): TValidadorData;
begin
  FRegras.Add(TValidacaoEstritaEntre<TDateTime>.New(aMinimo, aMaximo).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.Igual(const aComparacao: TDateTime; aMensagem: string): TValidadorData;
begin
  FRegras.Add(TValidacaoEstritaIgual<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.Valida(const aValor: TNullable<TDateTime>): TValidadorData;
var
  LRegra: IValidacaoEstrita<TDateTime>;
begin
  for LRegra in FRegras do
    LRegra.Valida(aValor);
  Result := Self;
end;

function TValidadorData.Valido: Boolean;
var
  LRegra: IValidacaoEstrita<TDateTime>;
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

function TValidadorData.Mensagem: string;
begin
  Result := FMensagemFalha;
end;

end.
