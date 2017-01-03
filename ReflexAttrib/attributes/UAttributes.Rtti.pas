unit UAttributes.Rtti;

interface

uses
  System.Generics.Collections;

type
  //mover para helper
  TAttributesInspector<T: class> = class
  public
    class function GetAttr<Attr: TCustomAttribute>(): TList<Attr>;
  end;


implementation

uses
  Rtti;


{ TAttributesInspector }

class function TAttributesInspector<T>.GetAttr<Attr>(): TList<Attr>;
var
  rttiContext: TRttiContext;
  rttiType: TRttiType;
  attribute: TCustomAttribute;
begin
  rttiContext := TRttiContext.Create();
  Result:= TList<Attr>.Create();
  try
    rttiType := rttiContext.GetType(T);
    for attribute in rttiType.GetAttributes do
      if attribute is Attr then
        Result.Add( Attr(attribute) );
  finally
    rttiContext.Free();
  end; // try to recover and return the DisplayLabel
end;

end.
