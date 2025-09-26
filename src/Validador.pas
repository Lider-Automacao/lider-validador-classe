unit Validador;

interface

uses
  variants,
  Validador.Enum,
  Validador.Types,
  System.Generics.Collections;

type
  IValidadorAdd = interface;
  INullValidador = interface;

  IValidador = interface
    ['{07439CC1-095B-4F4B-9B1F-6B6324E3AF78}']
    function Vazio(aMensagem : string = ''): IValidador;
    function NaoVazio(aMensagem : string = ''): IValidador;
    function Enum(aEnum: TEnumValues): IValidador;

    function MaiorQue(aComparacao: Real; aMensagem : string = ''): IValidador;
    function MaiorQueOuIgual(aComparacao: Variant; aMensagem : string = ''): IValidador;

    function MenorQue(aComparacao: Real; aMensagem : string = ''): IValidador;
    function MenorQueOuIgual(aComparacao: Variant; aMensagem : string = ''): IValidador;

    function Igual(aComparacao: Variant; aMensagem : string = ''): IValidador;
    function Regex(aRegex: string; aMensagem : string = ''): IValidador;
    function DataString(aMensagem : string = ''): IValidador;
    function CPF(aMensagem : string = ''): IValidador;
    function CNPJ(aMensagem : string = ''): IValidador;

    function &End: IValidadorAdd;
  end;

  INullValidador = interface
    ['{B8B91E30-BAC1-4F07-B61B-A097E3D6EBA0}']
    function Requerido(aMensagem : string = ''): IValidador;
    function Nullable: IValidador;
  end;

  IValidadorAdd = interface
    ['{07439CC1-095B-4F4B-9B1F-6B6324E3AF78}']
    function Personalizada(aValidacao: IValidacaoBase): IValidadorAdd;
    function Add(aPropriedede: string; aValue: variant): INullValidador;
    function Executa: IExecutorValidador;
  end;

  TValidador = class(TInterfacedObject, IValidador, IValidadorAdd, INullValidador)
  private
    FValidador: IExecutorValidador;
    FValue: variant;
    FPropriedede: string;
    FRequerido : Boolean;
  public
    function Add(aPropriedede: string; aValue: variant): INullValidador;
    function Executa: IExecutorValidador;

    function Requerido(aMensagem : string = ''): IValidador;
    function Nullable: IValidador;

    function Vazio(aMensagem : string = ''): IValidador;
    function NaoVazio(aMensagem : string = ''): IValidador;
    function Enum(aEnum: TEnumValues): IValidador;

    function MaiorQue(aComparacao: Real; aMensagem : string = ''): IValidador;
    function MaiorQueOuIgual(aComparacao: Variant; aMensagem : string = ''): IValidador;

    function MenorQue(aComparacao: Real; aMensagem : string = ''): IValidador;
    function MenorQueOuIgual(aComparacao: Variant; aMensagem : string = ''): IValidador;

    function Regex(aRegex: string; aMensagem : string = ''): IValidador;
    function DataString(aMensagem : string = ''): IValidador;

    function Personalizada(aValidacao: IValidacaoBase): IValidadorAdd;

    function Igual(aComparacao: Variant; aMensagem : string = ''): IValidador;

    function CPF(aMensagem : string = ''): IValidador;
    function CNPJ(aMensagem : string = ''): IValidador;

    function &End: IValidadorAdd;

    constructor Create;
    class function New: IValidadorAdd;
  end;

implementation

uses
  Validador.Igual,
  Validador.Requerido,
  Validador.Vazio,
  Validador.Regex,
  Validador.MaiorQue,
  Validador.MenorQue,
  Validador.CPF ,
  Validador.CNPJ;


function TValidador.Add(aPropriedede: string; aValue: variant): INullValidador;
begin
  FValue := aValue;
  FPropriedede := aPropriedede;
  FRequerido := False;
  Result := Self;
end;

function TValidador.&End: IValidadorAdd;
begin
  FValue := null;
  FPropriedede := '';
  FRequerido := False;
  Result := Self;
end;

function TValidador.Enum(aEnum: TEnumValues): IValidador;
begin
  FValidador.Add(TValidacaoEnum.New(aEnum).Valida(FValue).Propriedade(FPropriedede).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.CNPJ(aMensagem: string): IValidador;
begin
  FValidador.Add(TValidacaoCNPJ.New.Valida(FValue).Propriedade(FPropriedede).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.CPF(aMensagem: string): IValidador;
begin
  FValidador.Add(TValidacaoCPF.New.Valida(FValue).Propriedade(FPropriedede).Requerido(FRequerido));
  Result := Self;
end;

constructor TValidador.Create;
begin
  FValidador := TExecutorValidador.New;
end;

function TValidador.DataString(aMensagem: string): IValidador;
const
 REGEX_DATA =
      '^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)'+
      '(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)'+
      '0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|'+
      '^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';
begin
  Result := Regex(REGEX_DATA, aMensagem);
end;

function TValidador.Executa: IExecutorValidador;
begin
  Result := FValidador;
end;

function TValidador.Igual(aComparacao: Variant; aMensagem: string): IValidador;
begin
  FValidador.Add(TValidacaoIgual.New(aComparacao).Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.MaiorQue(aComparacao: Real; aMensagem : string = ''): IValidador;
begin
  FValidador.Add(TValidacaoMaiorQue.New(aComparacao).Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.MaiorQueOuIgual(aComparacao: Variant; aMensagem : string = ''): IValidador;
begin
  FValidador.Add(TValidacaoMaiorOuIgualQue.New(aComparacao).Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.MenorQue(aComparacao: Real; aMensagem : string): IValidador;
begin
  FValidador.Add(TValidacaoMenorQue.New(aComparacao).Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.MenorQueOuIgual(aComparacao: Variant; aMensagem : string = ''): IValidador;
begin
  FValidador.Add(TValidacaoMenorOuIgualQue.New(aComparacao).Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.NaoVazio(aMensagem : string = ''): IValidador;
begin
  FValidador.Add(TValidacaoNaoEstaVazio.New.Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

class function TValidador.New: IValidadorAdd;
begin
  Result := Self.Create;
end;

function TValidador.Nullable: IValidador;
begin
  FRequerido := False;
  Result := Self;
end;

function TValidador.Personalizada(aValidacao: IValidacaoBase): IValidadorAdd;
begin
  FValidador.Add(aValidacao);
  Result := Self;
end;

function TValidador.Regex(aRegex, aMensagem: string): IValidador;
begin
  FValidador.Add(TValidacaoRegex.New(aRegex).Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.Requerido(aMensagem : string = ''): IValidador;
begin
  FRequerido := True;
  FValidador.Add(TValidacaoRequerido.New.Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

function TValidador.Vazio(aMensagem : string = ''): IValidador;
begin
  FValidador.Add(TValidacaoEstaVazio.New.Valida(FValue).Propriedade(FPropriedede).Mensagem(aMensagem).Requerido(FRequerido));
  Result := Self;
end;

end.
