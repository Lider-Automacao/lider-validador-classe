unit Validador.Base;

interface

uses
  Validador.Types;

type
  TValidacaoBase<T> = class(TInterfacedObject, IValidacao<T>)
  protected
    FRequerido: Boolean;
    FMensagem: string;
    FPropriedade: string;
    FValue: T;
  public
    function Requerido(const aRequerido: Boolean): IValidacao<T>;
    function Propriedade(const aPropriedade: string): IValidacao<T>; overload;
    function Valida(const aValue: T): IValidacao<T>; virtual;
    function Mensagem(const aMensagem: string): IValidacao<T>; overload;
    function Valido: Boolean; virtual; abstract;
    procedure VerificaErro;
    constructor Create(const aMensagem: string); virtual;
    function Mensagem: string; overload;
    function Propriedade: string; overload;
  end deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0';


implementation

uses
  System.SysUtils, System.Variants;

constructor TValidacaoBase<T>.Create(const aMensagem: string);
begin
  FRequerido := False;
  FMensagem := 'Campo Inválido';
  FPropriedade := 'Campo';

  if Trim(aMensagem).Length = 0 then
    raise Exception.Create('Mensagem é requerida');

  FMensagem := aMensagem;
end;

function TValidacaoBase<T>.Mensagem(const aMensagem: string): IValidacao<T>;
begin
  if Trim(aMensagem) <> '' then
    FMensagem := aMensagem;
  Result := Self;
end;

function TValidacaoBase<T>.Mensagem: string;
begin
  if FMensagem = null then
    Exit('');

  Result := Trim(FMensagem);
end;

function TValidacaoBase<T>.Propriedade: string;
begin
  Result := FPropriedade;
end;

function TValidacaoBase<T>.Requerido(const aRequerido: Boolean): IValidacao<T>;
begin
  FRequerido := aRequerido;
  Result := Self;
end;

function TValidacaoBase<T>.Propriedade(const aPropriedade: string): IValidacao<T>;
begin
  FPropriedade := aPropriedade;
  Result := Self;
end;

function TValidacaoBase<T>.Valida(const aValue: T): IValidacao<T>;
begin
  FValue := aValue;
  Result := Self;
end;

procedure TValidacaoBase<T>.VerificaErro;
begin
  if not Valido then
    raise TValidadorException.Create(Mensagem);
end;


end.
