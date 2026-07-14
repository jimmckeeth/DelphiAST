unit DelphiAST.TestSupport;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SysUtils, DelphiAST, DelphiAST.Classes, DelphiAST.Consts,
  SimpleParser.Lexer.Types;

type
  TTestIncludeHandler = class(TInterfacedObject, IIncludeHandler)
  private
    FBasePath: string;
  public
    constructor Create(const BasePath: string);
    function GetIncludeFileContent(const ParentFileName, IncludeName: string;
      out Content: string; out FileName: string): Boolean;
  end;

function ParseSource(const Source: string): TSyntaxNode;
function ParseFile(const FileName, IncludePath: string): TSyntaxNode;
function FindDescendant(Node: TSyntaxNode; Typ: TSyntaxNodeType): TSyntaxNode;
function CountDescendants(Node: TSyntaxNode; Typ: TSyntaxNodeType): Integer;
function ResolveSnippetPath: string;

implementation

constructor TTestIncludeHandler.Create(const BasePath: string);
begin
  inherited Create;
  FBasePath := IncludeTrailingPathDelimiter(ExpandFileName(BasePath));
end;

function TTestIncludeHandler.GetIncludeFileContent(const ParentFileName,
  IncludeName: string; out Content, FileName: string): Boolean;
var
  Source: TStringList;
begin
  FileName := ExpandFileName(FBasePath + IncludeName);
  Result := FileExists(FileName);
  if not Result then
    Exit;
  Source := TStringList.Create;
  try
    Source.LoadFromFile(FileName);
    Content := Source.Text;
  finally
    Source.Free;
  end;
end;

function ParseSource(const Source: string): TSyntaxNode;
var
  Builder: TPasSyntaxTreeBuilder;
  Stream: TStringStream;
begin
  Builder := TPasSyntaxTreeBuilder.Create;
  Stream := TStringStream.Create(Source);
  try
    Stream.Position := 0;
    Builder.InitDefinesDefinedByCompiler;
    Result := Builder.Run(Stream);
  finally
    Stream.Free;
    Builder.Free;
  end;
end;

function ParseFile(const FileName, IncludePath: string): TSyntaxNode;
var
  Builder: TPasSyntaxTreeBuilder;
  Stream: TFileStream;
begin
  Builder := TPasSyntaxTreeBuilder.Create;
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.Position := 0;
    Builder.InitDefinesDefinedByCompiler;
    Builder.IncludeHandler := TTestIncludeHandler.Create(IncludePath);
    Result := Builder.Run(Stream);
  finally
    Stream.Free;
    Builder.Free;
  end;
end;

function FindDescendant(Node: TSyntaxNode; Typ: TSyntaxNodeType): TSyntaxNode;
var
  Child: TSyntaxNode;
begin
  Result := nil;
  if Node = nil then
    Exit;
  if Node.Typ = Typ then
    Exit(Node);
  for Child in Node.ChildNodes do
  begin
    Result := FindDescendant(Child, Typ);
    if Result <> nil then
      Exit;
  end;
end;

function CountDescendants(Node: TSyntaxNode; Typ: TSyntaxNodeType): Integer;
var
  Child: TSyntaxNode;
begin
  Result := 0;
  if Node = nil then
    Exit;
  if Node.Typ = Typ then
    Inc(Result);
  for Child in Node.ChildNodes do
    Inc(Result, CountDescendants(Child, Typ));
end;

function ResolveSnippetPath: string;
const
  Candidates: array[0..3] of string = (
    'Test/Snippets', '../Snippets', '../../Test/Snippets', '../../../Test/Snippets');
var
  I: Integer;
  Candidate: string;
begin
  if (ParamCount > 0) and DirectoryExists(ParamStr(1)) then
    Exit(ExpandFileName(ParamStr(1)));
  for I := Low(Candidates) to High(Candidates) do
  begin
    Candidate := ExpandFileName(Candidates[I]);
    if DirectoryExists(Candidate) then
      Exit(Candidate);
    Candidate := ExpandFileName(ExtractFilePath(ParamStr(0)) + Candidates[I]);
    if DirectoryExists(Candidate) then
      Exit(Candidate);
  end;
  raise Exception.Create('Cannot locate Test/Snippets; pass its path as the first argument');
end;

end.
