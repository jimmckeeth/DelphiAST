unit anonymousmethodstdcall;

interface

implementation

procedure Run;
type
  TCallback = reference to procedure stdcall;
var
  Callback: TCallback;
begin
  Callback :=
    procedure stdcall
    begin
    end;
end;

end.
