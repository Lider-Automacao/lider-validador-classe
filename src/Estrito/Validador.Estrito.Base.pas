unit Validador.Estrito.Base;

interface

uses
  Validador.Estrito.Types;

type
  TValidacaoEstritaBase<T> = class(TInterfacedObject, IValidacaoEstrita<T>)
  protected
    FRequerido: Boolean;
    FMensagem: string;
    FPropriedade: string;
    FValue: TNullable<T>;
  public
    function Requerido(const aRequerido: Boolean): IValidacaoEstrita<T>;
    function Propriedade(const aPropriedade: string): IValidacaoEstrita<T>; overload;
    function Valida(const aValue: TNullable<T>): IValidacaoEstrita<T>; virtual;
    function Mensagem(const aMensagem: string): IValidacaoEstrita<T>; overload;
    function Valido: Boolean; virtual; abstract;
    procedure VerificaErro;
    constructor Create(const aMensagem: string); virtual;
    function Mensagem: string; overload;
    function Propriedade: string; overload;
  end;

implementation

uses
  System.SysUtils,
  Validador.Types;

constructor TValidacaoEstritaBase<T>.Create(const aMensagem: string);
begin
  FRequerido := False;
  FPropriedade := 'Campo';

  if Trim(aMensagem).Length = 0 then
    raise Exception.Create('Mensagem é requerida');

  FMensagem := aMensagem;
end;

function TValidacaoEstritaBase<T>.Mensagem(const aMensagem: string): IValidacaoEstrita<T>;
begin
  if Trim(aMensagem) <> '' then
    FMensagem := aMensagem;
  Result := Self;
end;

function TValidacaoEstritaBase<T>.Mensagem: string;
begin
  Result := Trim(FMensagem);
end;

function TValidacaoEstritaBase<T>.Propriedade: string;
begin
  Result := FPropriedade;
end;

function TValidacaoEstritaBase<T>.Requerido(const aRequerido: Boolean): IValidacaoEstrita<T>;
begin
  FRequerido := aRequerido;
  Result := Self;
end;

function TValidacaoEstritaBase<T>.Propriedade(const aPropriedade: string): IValidacaoEstrita<T>;
begin
  FPropriedade := aPropriedade;
  Result := Self;
end;

function TValidacaoEstritaBase<T>.Valida(const aValue: TNullable<T>): IValidacaoEstrita<T>;
begin
  FValue := aValue;
  Result := Self;
end;

procedure TValidacaoEstritaBase<T>.VerificaErro;
begin
  if not Valido then
    raise TValidadorException.Create(Mensagem);
end;

end.
