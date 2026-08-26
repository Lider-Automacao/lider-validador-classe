unit Validador.Estrito.Data;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  IValidadorData = interface
    ['{C5DEBF89-0BBC-4CC1-835B-EBEC3AF989FC}']
    function Requerido(aMensagem: string = ''): IValidadorData;
    function Nullable: IValidadorData;

    function MaiorQue(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function MaiorQueOuIgual(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function MenorQue(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function MenorQueOuIgual(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function Entre(const aMinimo, aMaximo: TDateTime; aMensagem: string = ''): IValidadorData;
    function Igual(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;

    function Valida(const aValor: TNullable<TDateTime>): IValidadorData;
    function Valido: Boolean;
    function Mensagem: string;
  end;

  TValidadorData = class(TInterfacedObject, IValidadorData)
  private
    FRegras: TList<IValidacaoEstrita<TDateTime>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IValidadorData;

    function Requerido(aMensagem: string = ''): IValidadorData;
    function Nullable: IValidadorData;

    function MaiorQue(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function MaiorQueOuIgual(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function MenorQue(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function MenorQueOuIgual(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;
    function Entre(const aMinimo, aMaximo: TDateTime; aMensagem: string = ''): IValidadorData;
    function Igual(const aComparacao: TDateTime; aMensagem: string = ''): IValidadorData;

    function Valida(const aValor: TNullable<TDateTime>): IValidadorData;
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

class function TValidadorData.New: IValidadorData;
begin
  Result := TValidadorData.Create;
end;

function TValidadorData.Requerido(aMensagem: string): IValidadorData;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<TDateTime>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorData.Nullable: IValidadorData;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorData.MaiorQue(const aComparacao: TDateTime; aMensagem: string): IValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMaiorQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.MaiorQueOuIgual(const aComparacao: TDateTime; aMensagem: string): IValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMaiorOuIgualQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.MenorQue(const aComparacao: TDateTime; aMensagem: string): IValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMenorQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.MenorQueOuIgual(const aComparacao: TDateTime; aMensagem: string): IValidadorData;
begin
  FRegras.Add(TValidacaoEstritaMenorOuIgualQue<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.Entre(const aMinimo, aMaximo: TDateTime; aMensagem: string): IValidadorData;
begin
  FRegras.Add(TValidacaoEstritaEntre<TDateTime>.New(aMinimo, aMaximo).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.Igual(const aComparacao: TDateTime; aMensagem: string): IValidadorData;
begin
  FRegras.Add(TValidacaoEstritaIgual<TDateTime>.New(aComparacao).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorData.Valida(const aValor: TNullable<TDateTime>): IValidadorData;
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
