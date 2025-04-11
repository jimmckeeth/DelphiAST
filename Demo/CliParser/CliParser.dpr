program CliParser;

{$APPTYPE CONSOLE}

{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

{$R *.res}

uses
  System.SysUtils,
  AstParseToXml in 'AstParseToXml.pas';

begin
  try
  { TODO -oUser -cConsole Main : Insert code here }
  except
  on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
  end;
end.
