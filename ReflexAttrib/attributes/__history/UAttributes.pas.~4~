unit UAttributes;

interface

type
  TDisplayLabelAttribute = class(TCustomAttribute)
  private
    FText: string;
  public
    constructor Create(const aText: string);
    property Text: string read FText write FText;
  end;

implementation

constructor TDisplayLabelAttribute.Create(const aText: string);
begin
  FText := aText;
end;

end.
