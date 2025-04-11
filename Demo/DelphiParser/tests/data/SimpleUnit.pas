unit SimpleUnit;

interface

type
  TSimpleClass = class
  private
  FValue: Integer;
  public
  procedure DoSomething;
  property Value: Integer read FValue write FValue;
  end;

implementation

procedure TSimpleClass.DoSomething;
begin
  Inc(FValue);
end;

end.
