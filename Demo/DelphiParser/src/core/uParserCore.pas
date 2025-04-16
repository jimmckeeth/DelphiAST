unit uParserCore;

interface

uses
  Classes, SysUtils, StringPool, DelphiAST, DelphiAST.Classes,
  DelphiAST.Writer, SimpleParser.Lexer.Types, IOUtils, Diagnostics;

{$INCLUDE ..\utils\Defines.inc}

type
  TParserCore = class
  private
    FXMLOutput: string;
    FComments: TStrings;
    FErrors: string;
    FParseTime: Int64;
    FUseStringInterning: Boolean;
    FFilePath: string;
{$IFDEF FastMM4}
    FMemoryUsage: Cardinal;
    function GetMemoryUsed: Cardinal;
{$ENDIF}
  public
    constructor Create; overload;
    constructor Create(const AFileName: string; const AUseStringIntern: Boolean = True); overload;
    destructor Destroy; override;

    function Parse(const AFileName: string): Boolean;

    property XMLOutput: string read FXMLOutput;
    property Comments: TStrings read FComments;
    property Errors: string read FErrors;
{$IFDEF FastMM4}
    property MemoryUsage: Cardinal read FMemoryUsage;
{$ENDIF}
    property ParseTime: Int64 read FParseTime;
    property UseStringInterning: Boolean read FUseStringInterning write FUseStringInterning;
    property FilePath: string read FFilePath;
  end;

implementation

uses
  {$IFDEF FastMM4}
  FastMM4,
  {$ENDIF}
  DelphiAST.SimpleParserEx, uIncludeHandler;

{ TParserCore }

constructor TParserCore.Create;
begin
  inherited;
  FComments := TStringList.Create;
  FErrors := '';
  FUseStringInterning := True;
end;

constructor TParserCore.Create(const AFileName: string; const AUseStringIntern: Boolean);
begin
  create;
  FUseStringInterning := AUseStringIntern;
  Parse(AFileName);
end;

destructor TParserCore.Destroy;
begin
  FComments.Free;
  inherited;
end;

{$IFDEF FastMM4}
  function TParserCore.GetMemoryUsed: Cardinal;
  {$IFNDEF FPC}
  var
    st: TMemoryManagerState;
    sb: TSmallBlockTypeState;
  begin
    GetMemoryManagerState(st);
    Result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
    for sb in st.SmallBlockTypeStates do
      Result := Result + sb.UseableBlockSize * sb.AllocatedBlockCount;
  end;
  {$ELSE}
  begin
    Result := GetFPCHeapStatus.CurrHeapUsed;
  end;
  {$ENDIF}
{$ENDIF}

function TParserCore.Parse(const AFileName: string): Boolean;
var
  SyntaxTree: TSyntaxNode;
{$IFDEF FastMM4}
  memused: Cardinal;
{$endif}
  sw: TStopwatch;
  StringPool: TStringPool;
  OnHandleString: TStringEvent;
  Builder: TPasSyntaxTreeBuilder;
  StringStream: TStringStream;
  comment: TCommentNode;
begin
  FFilePath := AFileName;
  FComments.Clear;
  FXMLOutput := '';

  if FUseStringInterning then
  begin
    StringPool := TStringPool.Create;
    OnHandleString := StringPool.StringIntern;
  end
  else
  begin
    StringPool := nil;
    OnHandleString := nil;
  end;
{$IFDEF FastMM4}
  memused := GetMemoryUsed;
{$ENDIF}
  sw := TStopwatch.StartNew;
  try
    Builder := TPasSyntaxTreeBuilder.Create;
    try
      StringStream := TStringStream.Create;
      try
        StringStream.LoadFromFile(AFileName);
        Builder.IncludeHandler := TIncludeHandler.Create(ExtractFilePath(AFileName));
        Builder.OnHandleString := OnHandleString;
        StringStream.Position := 0;
        try
          SyntaxTree := Builder.Run(StringStream);
          try
            FXMLOutput := TSyntaxTreeWriter.ToXML(SyntaxTree, True);
          finally
            SyntaxTree.Free;
          end;
          Result := True;
        except
          on E: ESyntaxTreeException do
          begin
            Result := False;

            FErrors := Format('[%d, %d] %s', [E.Line, E.Col, E.Message]);
            FXMLOutput := TSyntaxTreeWriter.ToXML(E.SyntaxTree, True);
            for comment in Builder.Comments do
              FComments.Add(Format('[Line: %d, Col: %d] %s',
                [comment.Line, comment.Col, comment.Text]));
          end;
        end;
      finally
        StringStream.Free;
      end;

      for comment in Builder.Comments do
        FComments.Add(Format('[Line: %d, Col: %d] %s',
          [comment.Line, comment.Col, comment.Text]));

    finally
      Builder.Free;
    end;
  finally
    if FUseStringInterning then
      StringPool.Free;
  end;

  sw.Stop;
  FParseTime := sw.ElapsedMilliseconds;
{$IFDEF FastMM4}
  FMemoryUsage := (GetMemoryUsed - memused) div 1024;
{$endif}
end;

end.
