unit AstParseToXml;

{$IFDEF FPC}{$MODE Delphi}{$ENDIF}

interface

uses SysUtils, Classes;

type
  TParseToXML = class
  
  procedure Parse(const FileName: string; UseStringInterning: Boolean);
end;

implementation

uses
  StringPool,
  DelphiAST, DelphiAST.Writer, DelphiAST.Classes,
  SimpleParser.Lexer.Types, IOUtils, Diagnostics,
  DelphiAST.SimpleParserEx;
  
type
  TIncludeHandler = class(TInterfacedObject, IIncludeHandler)
  private
  FPath: string;
  public
  constructor Create(const Path: string);
  function GetIncludeFileContent(const ParentFileName, IncludeName: string;
    out Content: string; out FileName: string): Boolean;
  end;


{ TIncludeHandler }

constructor TIncludeHandler.Create(const Path: string);
begin
  inherited Create;
  FPath := Path;
end;

function TIncludeHandler.GetIncludeFileContent(const ParentFileName, IncludeName: string;
  out Content: string; out FileName: string): Boolean;
var
  FileContent: TStringList;
begin
  FileContent := TStringList.Create;
  try
  if not FileExists(TPath.Combine(FPath, IncludeName)) then
  begin
    Result := False;
    Exit;
  end;

  FileContent.LoadFromFile(TPath.Combine(FPath, IncludeName));
  Content := FileContent.Text;
  FileName := TPath.Combine(FPath, IncludeName);

  Result := True;
  finally
  FileContent.Free;
  end;
end;


procedure TParseToXML.Parse(const FileName: string; UseStringInterning: Boolean);
var
  SyntaxTree: TSyntaxNode;
sw: TStopwatch;
  StringPool: TStringPool;
  OnHandleString: TStringEvent;
  Builder: TPasSyntaxTreeBuilder;
  StringStream: TStringStream;
  I: Integer;
begin
  OutputMemo.Clear;
  CommentsBox.Clear;

  try
  if UseStringInterning then
  begin
    StringPool := TStringPool.Create;
    OnHandleString := StringPool.StringIntern;
  end
  else
  begin
    StringPool := nil;
    OnHandleString := nil;
  end;

sw := TStopwatch.StartNew;
  try
    Builder := TPasSyntaxTreeBuilder.Create;
    try
    StringStream := TStringStream.Create;
    try
      StringStream.LoadFromFile(FileName);

      Builder.IncludeHandler := TIncludeHandler.Create(ExtractFilePath(FileName));
      Builder.OnHandleString := OnHandleString;
      StringStream.Position := 0;

      SyntaxTree := Builder.Run(StringStream);
      try
      OutputMemo.Lines.Text := TSyntaxTreeWriter.ToXML(SyntaxTree, True);
      finally
      SyntaxTree.Free;
      end;
    finally
      StringStream.Free;
    end;

    for I := 0 to Builder.Comments.Count - 1 do
      CommentsBox.Items.Add(Format('[Line: %d, Col: %d] %s',
            [Builder.Comments[I].Line, Builder.Comments[I].Col, Builder.Comments[I].Text]));
      finally
        Builder.Free;
      end
    finally
      if UseStringInterning then
        StringPool.Free;
    end;
    sw.Stop;

  except
    on E: ESyntaxTreeException do
      OutputMemo.Lines.Text := Format('[%d, %d] %s', [E.Line, E.Col, E.Message]) + sLineBreak + sLineBreak +
         TSyntaxTreeWriter.ToXML(E.SyntaxTree, True);
  end;
end;

end.
