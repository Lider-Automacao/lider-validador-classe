unit Validador.Estrito.String;

interface

uses
  System.Generics.Collections,
  Validador.Estrito.Types;

type
  TValidadorString = class
  private
    FRegras: TList<IValidacaoEstrita<string>>;
    FRequerido: Boolean;
    FMensagemFalha: string;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TValidadorString;

    function Requerido(aMensagem: string = ''): TValidadorString;
    function Nullable: TValidadorString;

    function NaoVazio(aMensagem: string = ''): TValidadorString;
    function Vazio(aMensagem: string = ''): TValidadorString;
    function Regex(const aRegex: string; aMensagem: string = ''): TValidadorString;
    function Email(aMensagem: string = ''): TValidadorString;
    function Url(aMensagem: string = ''): TValidadorString;
    function CEP(aMensagem: string = ''): TValidadorString;
    function Telefone(aMensagem: string = ''): TValidadorString;
    function Celular(aMensagem: string = ''): TValidadorString;
    function TamanhoMinimo(aTamanho: Integer; aMensagem: string = ''): TValidadorString;
    function TamanhoMaximo(aTamanho: Integer; aMensagem: string = ''): TValidadorString;
    function CPF(aMensagem: string = ''): TValidadorString;
    function CNPJ(aMensagem: string = ''): TValidadorString;
    function Enum(const aEnum: TArray<string>; aMensagem: string = ''): TValidadorString;
    function DataString(aMensagem: string = ''): TValidadorString;

    function Valida(const aValor: TNullable<string>): TValidadorString;
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
  Validador.Estrito.DataString;

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

class function TValidadorString.New: TValidadorString;
begin
  Result := TValidadorString.Create;
end;

function TValidadorString.Requerido(aMensagem: string): TValidadorString;
begin
  FRequerido := True;
  FRegras.Add(TValidacaoEstritaRequerido<string>.New.Mensagem(aMensagem).Requerido(True));
  Result := Self;
end;

function TValidadorString.Nullable: TValidadorString;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidadorString.NaoVazio(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaNaoEstaVazio.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Vazio(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaEstaVazio.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Regex(const aRegex: string; aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaRegex.New(aRegex).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Email(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaEmail.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Url(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaUrl.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.CEP(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCEP.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Telefone(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaTelefone.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Celular(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCelular.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.TamanhoMinimo(aTamanho: Integer; aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaTamanhoMinimo.New(aTamanho).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.TamanhoMaximo(aTamanho: Integer; aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaTamanhoMaximo.New(aTamanho).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.CPF(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCPF.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.CNPJ(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaCNPJ.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Enum(const aEnum: TArray<string>; aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaEnum.New(aEnum).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.DataString(aMensagem: string): TValidadorString;
begin
  FRegras.Add(TValidacaoEstritaDataString.New.Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidadorString.Valida(const aValor: TNullable<string>): TValidadorString;
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
