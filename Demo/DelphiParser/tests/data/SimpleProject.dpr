program SimpleProject;

uses
  System.SysUtils,
  SimpleUnit in 'SimpleUnit.pas';

begin
  try
  // Do something
  except
  on E: Exception do
    Writeln(E.Message);
  end;
end.
