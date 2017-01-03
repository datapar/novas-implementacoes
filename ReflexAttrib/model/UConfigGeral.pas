unit UConfigGeral;

interface

uses
  UAttributes;


const
  IDConfig_Transferir = $00001;
  IDConfig_Importar = $00002;

type
  [TDisplayLabelAttribute('>>> TConfigGeral <<<')]
  TConfigGeral = class
  protected
    function GetValor(Index: Integer): Variant;
    procedure SetValor(Index: Integer; Value: Variant);
  public
    [TDisplayLabelAttribute('Descri��o Transferir2222')]
    property Transferir: Variant index IDConfig_Transferir read GetValor write SetValor;

    [TDisplayLabelAttribute('Descri��o Importar')]
    property Importar: Variant index IDConfig_Importar read GetValor write SetValor;

    [TDisplayLabelAttribute('NOVO Importar')]
    property Importar2: Variant index IDConfig_Importar read GetValor write SetValor;
  end;

implementation

uses
  System.Generics.Collections;

//pseudo DAO
var
  L: TDictionary<Integer, Variant>;

procedure InicializaListaFake();
begin
  L := TDictionary<Integer, Variant>.Create();

  L.Add(IDConfig_Transferir, 'N');
  L.Add(IDConfig_Importar, 'S');
end;


{ TConfigGeral }

function TConfigGeral.GetValor(Index: Integer): Variant;
begin
  Result := L.Items[{key}Index];
end;

procedure TConfigGeral.SetValor(Index: Integer; Value: Variant);
begin
  L.AddOrSetValue(Index, Value);
end;

initialization
  InicializaListaFake();

end.



