unit Validador.Estrito.Strings;

interface

uses
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  IValidadorString = interface
    ['{C9B81598-B2AF-4712-86F0-BD494AC76F7B}']
    function Requerido(aMensagem: string = ''): IValidadorString;
    function Nullable: IValidadorString;

    function NaoVazio(aMensagem: string = ''): IValidadorString;
    function Vazio(aMensagem: string = ''): IValidadorString;
    function Regex(const aRegex: string; aMensagem: string = ''): IValidadorString;
    function Email(aMensagem: string = ''): IValidadorString;
    function Url(aMensagem: string = ''): IValidadorString;
    function CEP(aMensagem: string = ''): IValidadorString;
    function Telefone(aMensagem: string = ''): IValidadorString;
    function Celular(aMensagem: string = ''): IValidadorString;
    function TamanhoMinimo(aTamanho: Integer; aMensagem: string = ''): IValidadorString;
    function TamanhoMaximo(aTamanho: Integer; aMensagem: string = ''): IValidadorString;
    function CPF(aMensagem: string = ''): IValidadorString;
    function CNPJ(aMensagem: string = ''): IValidadorString;
    function Enum(const aEnum: TArray<string>; aMensagem: string = ''): IValidadorString;
    function DataString(aMensagem: string = ''): IValidadorString;
    function Igual(const aComparacao: string; aMensagem: string = ''): IValidadorString;

    function Valida(const aValor: TNullable<string>): IValidadorString;
    function Valido: Boolean;
    function Mensagem: string;
  end;

  TValidadorString = class(TInterfacedObject, IValidadorString)
  private
    FRegras: TList<IValidacaoEstrita<string>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IValidadorString;

    function Requerido(aMensagem: string = ''): IValidadorString;
    function Nullable: IValidadorString;

    function NaoVazio(aMensagem: string = ''): IValidadorString;
    function Vazio(aMensagem: string = ''): IValidadorString;
    function Regex(const aRegex: string; aMensagem: string = ''): IValidadorString;
    function Email(aMensagem: string = ''): IValidadorString;
    function Url(aMensagem: string = ''): IValidadorString;
    function CEP(aMensagem: string = ''): IValidadorString;
    function Telefone(aMensagem: string = ''): IValidadorString;
    function Celular(aMensagem: string = ''): IValidadorString;
    function TamanhoMinimo(aTamanho: Integer; aMensagem: string = ''): IValidadorString;
    function TamanhoMaximo(aTamanho: Integer; aMensagem: string = ''): IValidadorString;
    function CPF(aMensagem: string = ''): IValidadorString;
    function CNPJ(aMensagem: string = ''): IValidadorString;
    function Enum(const aEnum: TArray<string>; aMensagem: string = ''): IValidadorString;
    function DataString(aMensagem: string = ''): IValidadorString;
    function Igual(const aComparacao: string; aMensagem: string = ''): IValidadorString;

    function Valida(const aValor: TNullable<string>): IValidadorString;
    function Valido: Boolean;
    function Mensagem: string;
  end;

implementation

uses
  Validador.Estrito.Requerido,
  Validador.Estrito.Vazio,
  Validador.Estrito.Regex,
  Validador.Estrito.Email,
  Validador.Estrito.Url,
  Validador.Estrito.CEP,
  Validador.Estrito.Telefone,
  Validador.Estrito.Tamanho,
  Validador.Estrito.CPF,
  Validador.Estrito.CNPJ,
  Validador.Estrito.Enum,
  Validador.Estrito.DataString,
  Validador.Estrito.Comparacao;

constructor TValidadorString.Create;
begin
  FRegras := TList<IValidacaoEstrita<string>>.Create;
  FRequerido := False;
end;

destructor TValidadorString.Destroy;
begin
  FRegras.Free;
  inherited;
end;

class function TValidadorString.New: IValidadorString;
begin
  Result := TValidadorString.Create;
end;

function TValidadorString.Requerido(aMensagem: string): IValidadorString;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<string>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorString.Nullable: IValidadorString;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorString.NaoVazio(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaNaoEstaVazio.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Vazio(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaEstaVazio.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Regex(const aRegex: string; aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaRegex.New(aRegex).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Email(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaEmail.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Url(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaUrl.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.CEP(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCEP.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Telefone(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaTelefone.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Celular(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCelular.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.TamanhoMinimo(aTamanho: Integer; aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaTamanhoMinimo.New(aTamanho).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.TamanhoMaximo(aTamanho: Integer; aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaTamanhoMaximo.New(aTamanho).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.CPF(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCPF.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.CNPJ(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCNPJ.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Enum(const aEnum: TArray<string>; aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaEnum.New(aEnum).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.DataString(aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaDataString.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Igual(const aComparacao: string; aMensagem: string): IValidadorString;
begin
  FRegras.Add(TValidacaoEstritaIgualTexto.New(aComparacao, aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Valida(const aValor: TNullable<string>): IValidadorString;
var
  LRegra: IValidacaoEstrita<string>;
begin
  for LRegra in FRegras do
    LRegra.Valida(aValor);
  Result := Self;
end;

function TValidadorString.Valido: Boolean;
var
  LRegra: IValidacaoEstrita<string>;
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

function TValidadorString.Mensagem: string;
begin
  Result := FMensagemFalha;
end;

end.
