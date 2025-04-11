program ParserCLI;

{$APPTYPE CONSOLE}

{$Include utils\Defines.inc}

{$R *.res}

uses
  {$IFDEF FastMM4}
  FastMM4,
  {$ENDIF}
  System.SysUtils, 
  System.Classes,
  uParserCore in 'core\uParserCore.pas',
  uIncludeHandler in 'core\uIncludeHandler.pas';

procedure WriteUsage;
begin
  WriteLn('Usage: ParserCLI <input_file> [xml_output_file] [comments_output_file]');
  WriteLn('  input_file       - Path to Delphi source file to parse');
  WriteLn('  xml_output_file    - Optional: Path to save XML output');
  WriteLn('  comments_output_file - Optional: Path to save comments');
  WriteLn;
  WriteLn('If output files are not specified, results are written to console.');
end;

procedure WriteToFileOrConsole(const Content: string; const FileName: string = '');
var
  FileStream: TStreamWriter;
begin
  if FileName <> '' then
  begin
  FileStream := TStreamWriter.Create(FileName, False, TEncoding.UTF8);
  try
    FileStream.Write(Content);
  finally
    FileStream.Free;
  end;
  end
  else
  WriteLn(Content);
end;

var
  Parser: TParserCore;
  InputFile, XMLOutput, CommentsOutput: string;

begin
  try
    if ParamCount < 1 then
    begin
      WriteUsage;
      Exit;
    end;

    InputFile := ParamStr(1);
    if ParamCount >= 2 then
      XMLOutput := ParamStr(2)
    else
      XMLOutput := '';

    if ParamCount >= 3 then
      CommentsOutput := ParamStr(3)
    else
      CommentsOutput := '';

    Parser := TParserCore.Create;
    try
      WriteLn('// Parsing ', InputFile, '...');

      if not Parser.Parse(InputFile) then
      begin
        ExitCode := 1;
        WriteLn('// Error parsing file');
        Writeln('// Error: ', Parser.Errors);
      end
      else
        ExitCode := 0;

      {$IFDEF FastMM4}
      WriteLn(Format('// Parsing completed in %d ms using %.0n K of memory',
        [Parser.ParseTime, Parser.MemoryUsage * 1.0]));
      {$ELSE}
      WriteLn(Format('// Parsing completed in %d ms', [Parser.ParseTime]));
      {$ENDIF}

      // Handle XML output
      Writeln('// Writing AST as XML');
    if XMLOutput = '' then
    Writeln('//   [xml_output_file] unspecified. Writing to standard output');

    WriteToFileOrConsole(Parser.XMLOutput, XMLOutput);

    // Handle comments output
    Writeln('// Writing Comments');
    if CommentsOutput = '' then
    Writeln('//   [comments_output_file] unspecified. Writing to standard output');
    if (Parser.Comments.Count > 0) then
    begin
    WriteToFileOrConsole(Parser.Comments.Text, CommentsOutput);
    end;
  finally
    Parser.Free;
  end;

  except
  on E: Exception do
  begin
    WriteLn('Error: ', E.ClassName, ': ', E.Message);
    ExitCode := 1;
  end;
  end;
end.
