unit Validador.Estrito.Types;

interface

type
  TNullable<T> = record
  private
    FValue: T;
    FHasValue: Boolean;
  public
    class function Create(const aValue: T): TNullable<T>; static;
    class function Empty: TNullable<T>; static;
    property HasValue: Boolean read FHasValue;
    property Value: T read FValue;
    class operator Implicit(const aValue: T): TNullable<T>;
    class operator Implicit(const aValue: TNullable<T>): T;
  end;

  IValidacaoEstritaBase = interface
    ['{994888BE-AF8A-47FC-BECA-7383A574AFFD}']
    function Mensagem: string; overload;
    function Propriedade: string; overload;
    function Valido: Boolean;
    procedure VerificaErro;
  end;

  IValidacaoEstrita<T> = interface(IValidacaoEstritaBase)
    ['{4FAEC098-519E-42E2-A797-6285848FD0BA}']
    function Requerido(const aRequerido: Boolean): IValidacaoEstrita<T>;
    function Propriedade(const aPropriedade: string): IValidacaoEstrita<T>;
    function Valida(const aValue: TNullable<T>): IValidacaoEstrita<T>;
    function Mensagem(const aMensagem: string): IValidacaoEstrita<T>; overload;
  end;

implementation

class function TNullable<T>.Create(const aValue: T): TNullable<T>;
begin
  Result.FValue := aValue;
  Result.FHasValue := True;
end;

class function TNullable<T>.Empty: TNullable<T>;
begin
  Result.FHasValue := False;
end;

class operator TNullable<T>.Implicit(const aValue: T): TNullable<T>;
begin
  Result := TNullable<T>.Create(aValue);
end;

class operator TNullable<T>.Implicit(const aValue: TNullable<T>): T;
begin
  Result := aValue.Value;
end;

end.
