program FindPropertyAssignments;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  uFindPropertyAssignment in 'uFindPropertyAssignment.pas';

var
  Finder: TFindPropertyAssignment;
begin
  try
    Finder := TFindPropertyAssignment.Create('TPanel','Color');
    try
      Finder.TargetClassName := 'TPanel';
      Finder.TargetPropertyName := 'Color';
      Finder.CurrentFileName := ParamStr(1);

      if Finder.CurrentFileName = '' then
      begin
        Writeln('Please provide path to Delphi source file.');
        //Finder.CurrentFileName := 'TestFiles\TPanelColorAssignments.pas';
        Exit;
      end;

      if not FileExists(Finder.CurrentFileName) then
      begin
        Writeln('File not found: ', Finder.CurrentFileName);
        Exit;
      end;

      for var ass in Finder.Results do
      begin
        Writeln(Format('Line # %4d: %s = %s',[ass.LineNumber, ass.FullName, ass.Value]));
      end;

    finally
      Finder.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

