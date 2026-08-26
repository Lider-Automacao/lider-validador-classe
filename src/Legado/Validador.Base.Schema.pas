unit Validador.Base.Schema;

interface

uses
  Validador.Types, Validador, Validador.Base;

type
  TValidacaoSchemaBase<T> = class deprecated 'Use Validador.Estrito.* — remocao planejada pra v2.0'(TValidacaoBase<T>)
  protected
    FValidador: IValidadorAdd;
  public
    function Valida(const aValue: T): IValidacao<T>; override;
    function MontaValidador: IValidadorAdd; virtual; abstract;
    function Valido: Boolean; override;
  end;

implementation

{ TValidacaoSchemaBase<T> }

function TValidacaoSchemaBase<T>.Valida(const aValue: T): IValidacao<T>;
begin
  Result := Self;
  inherited Valida(aValue);
  FValidador := MontaValidador;
end;

function TValidacaoSchemaBase<T>.Valido: Boolean;
begin
  FMensagem := FValidador.Executa.Errors;
  Result := FValidador.Executa.Valido;
end;

end.
