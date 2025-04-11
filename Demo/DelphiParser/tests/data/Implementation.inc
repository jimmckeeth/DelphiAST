procedure DoSomething;
begin
  {$IFDEF DEBUG}
  Writeln('Debug mode');
  {$ENDIF}
end;
