unit Validador.Estrito.Comparacao;

interface

uses
  Validador.Estrito.Types,
  Validador.Estrito.Base;

type
  TValidacaoEstritaMaiorQue<T> = class(TValidacaoEstritaBase<T>)
  private
    FComparador: T;
  public
    constructor Create(const aComparador: T); reintroduce;
    function Valido: Boolean; override;
    class function New(const aComparador: T): IValidacaoEstrita<T>;
  end;

  TValidacaoEstritaMaiorOuIgualQue<T> = class(TValidacaoEstritaBase<T>)
  private
    FComparador: T;
  public
    constructor Create(const aComparador: T); reintroduce;
    function Valido: Boolean; override;
    class function New(const aComparador: T): IValidacaoEstrita<T>;
  end;

  TValidacaoEstritaMenorQue<T> = class(TValidacaoEstritaBase<T>)
  private
    FComparador: T;
  public
    constructor Create(const aComparador: T); reintroduce;
    function Valido: Boolean; override;
    class function New(const aComparador: T): IValidacaoEstrita<T>;
  end;

  TValidacaoEstritaMenorOuIgualQue<T> = class(TValidacaoEstritaBase<T>)
  private
    FComparador: T;
  public
    constructor Create(const aComparador: T); reintroduce;
    function Valido: Boolean; override;
    class function New(const aComparador: T): IValidacaoEstrita<T>;
  end;

  TValidacaoEstritaEntre<T> = class(TValidacaoEstritaBase<T>)
  private
    FMinimo: T;
    FMaximo: T;
  public
    constructor Create(const aMinimo, aMaximo: T); reintroduce;
    function Valido: Boolean; override;
    class function New(const aMinimo, aMaximo: T): IValidacaoEstrita<T>;
  end;

  TValidacaoEstritaIgual<T> = class(TValidacaoEstritaBase<T>)
  private
    FComparador: T;
  public
    constructor Create(const aComparador: T); reintroduce;
    function Valido: Boolean; override;
    class function New(const aComparador: T): IValidacaoEstrita<T>;
  end;

implementation

uses
  System.SysUtils,
  System.Rtti,
  System.Generics.Defaults;

{ TValidacaoEstritaMaiorQue<T> }

constructor TValidacaoEstritaMaiorQue<T>.Create(const aComparador: T);
begin
  inherited Create(Format('Deve ser maior que %s', [TValue.From<T>(aComparador).ToString]));
  FComparador := aComparador;
end;

class function TValidacaoEstritaMaiorQue<T>.New(const aComparador: T): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoEstritaMaiorQue<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := TComparer<T>.Default.Compare(FValue.Value, FComparador) > 0;
end;

{ TValidacaoEstritaMaiorOuIgualQue<T> }

constructor TValidacaoEstritaMaiorOuIgualQue<T>.Create(const aComparador: T);
begin
  inherited Create(Format('Deve ser maior ou igual que %s', [TValue.From<T>(aComparador).ToString]));
  FComparador := aComparador;
end;

class function TValidacaoEstritaMaiorOuIgualQue<T>.New(const aComparador: T): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoEstritaMaiorOuIgualQue<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := TComparer<T>.Default.Compare(FValue.Value, FComparador) >= 0;
end;

{ TValidacaoEstritaMenorQue<T> }

constructor TValidacaoEstritaMenorQue<T>.Create(const aComparador: T);
begin
  inherited Create(Format('Deve ser menor que %s', [TValue.From<T>(aComparador).ToString]));
  FComparador := aComparador;
end;

class function TValidacaoEstritaMenorQue<T>.New(const aComparador: T): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoEstritaMenorQue<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := TComparer<T>.Default.Compare(FValue.Value, FComparador) < 0;
end;

{ TValidacaoEstritaMenorOuIgualQue<T> }

constructor TValidacaoEstritaMenorOuIgualQue<T>.Create(const aComparador: T);
begin
  inherited Create(Format('Deve ser menor ou igual que %s', [TValue.From<T>(aComparador).ToString]));
  FComparador := aComparador;
end;

class function TValidacaoEstritaMenorOuIgualQue<T>.New(const aComparador: T): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoEstritaMenorOuIgualQue<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := TComparer<T>.Default.Compare(FValue.Value, FComparador) <= 0;
end;

{ TValidacaoEstritaEntre<T> }

constructor TValidacaoEstritaEntre<T>.Create(const aMinimo, aMaximo: T);
begin
  inherited Create(Format('Deve estar entre %s e %s', [TValue.From<T>(aMinimo).ToString, TValue.From<T>(aMaximo).ToString]));
  FMinimo := aMinimo;
  FMaximo := aMaximo;
end;

class function TValidacaoEstritaEntre<T>.New(const aMinimo, aMaximo: T): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aMinimo, aMaximo);
end;

function TValidacaoEstritaEntre<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := (TComparer<T>.Default.Compare(FValue.Value, FMinimo) >= 0) and
    (TComparer<T>.Default.Compare(FValue.Value, FMaximo) <= 0);
end;

{ TValidacaoEstritaIgual<T> }

constructor TValidacaoEstritaIgual<T>.Create(const aComparador: T);
begin
  inherited Create('Os valores devem ser iguais');
  FComparador := aComparador;
end;

class function TValidacaoEstritaIgual<T>.New(const aComparador: T): IValidacaoEstrita<T>;
begin
  Result := Self.Create(aComparador);
end;

function TValidacaoEstritaIgual<T>.Valido: Boolean;
begin
  if not FValue.HasValue then
    Exit(not FRequerido);
  Result := TComparer<T>.Default.Compare(FValue.Value, FComparador) = 0;
end;

end.
