unit DelphiAST.Tests;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

procedure RunAllTests;

implementation

uses
  Classes, SysUtils, DelphiAST, DelphiAST.Classes, DelphiAST.Consts,
  DelphiAST.Writer, DelphiAST.TestFramework, DelphiAST.TestSupport
  {$IFNDEF FPC}, DelphiAST.Serialize.Binary{$ENDIF};

var
  SnippetPath: string;
  CurrentSnippet: string;

procedure TestCurrentSnippet;
var
  Root: TSyntaxNode;
begin
  Root := ParseFile(CurrentSnippet, SnippetPath);
  try
    AssertNotNil(Root, 'Parser returned no syntax tree');
    AssertNotNil(FindDescendant(Root, ntUnit), 'Snippet has no unit node');
  finally
    Root.Free;
  end;
end;

procedure RunSnippetTests;
var
  Search: TSearchRec;
  Code: Integer;
begin
  SnippetPath := ResolveSnippetPath;
  Code := FindFirst(IncludeTrailingPathDelimiter(SnippetPath) + '*.pas', faAnyFile, Search);
  if Code <> 0 then
    raise Exception.Create('No Pascal snippets found in ' + SnippetPath);
  try
    repeat
      if (Search.Attr and faDirectory) = 0 then
      begin
        CurrentSnippet := IncludeTrailingPathDelimiter(SnippetPath) + Search.Name;
        RunTest('Snippet.' + Search.Name, TestCurrentSnippet);
      end;
      Code := FindNext(Search);
    until Code <> 0;
  finally
    FindClose(Search);
  end;
end;

procedure TestUnitStructure;
var
  Root, UnitNode, IntfNode, ImplNode: TSyntaxNode;
begin
  Root := ParseSource('unit Example;' + sLineBreak +
    'interface uses SysUtils; implementation end.');
  try
    UnitNode := FindDescendant(Root, ntUnit);
    AssertNotNil(UnitNode);
    AssertEquals('Example', UnitNode.Attribute[anName], 'Unit name.');
    IntfNode := FindDescendant(UnitNode, ntInterface);
    ImplNode := FindDescendant(UnitNode, ntImplementation);
    AssertNotNil(IntfNode, 'Missing interface');
    AssertNotNil(ImplNode, 'Missing implementation');
    AssertNotNil(FindDescendant(IntfNode, ntUses), 'Missing uses clause');
  finally
    Root.Free;
  end;
end;

procedure TestMethodAndParameters;
var
  Root, MethodNode: TSyntaxNode;
begin
  Root := ParseSource('unit Example; interface ' +
    'function Sum(A, B: Integer): Integer; implementation ' +
    'function Sum(A, B: Integer): Integer; begin Result := A + B; end; end.');
  try
    MethodNode := FindDescendant(Root, ntMethod);
    AssertNotNil(MethodNode);
    AssertEquals('Sum', FindDescendant(MethodNode, ntName).Attribute[anName],
      'Method name.');
    AssertEquals(2, CountDescendants(MethodNode, ntParameter), 'Parameter count.');
    AssertNotNil(FindDescendant(MethodNode, ntReturnType), 'Missing return type');
    AssertNotNil(FindDescendant(Root, ntAssign), 'Missing assignment');
    AssertNotNil(FindDescendant(Root, ntAdd), 'Missing addition expression');
  finally
    Root.Free;
  end;
end;

procedure TestControlFlow;
var
  Root: TSyntaxNode;
begin
  Root := ParseSource('unit Example; interface implementation procedure Run; ' +
    'var I: Integer; begin for I := 1 to 3 do if I > 1 then while I > 0 do ' +
    'I := I - 1; end; end.');
  try
    AssertNotNil(FindDescendant(Root, ntFor), 'Missing for statement');
    AssertNotNil(FindDescendant(Root, ntIf), 'Missing if statement');
    AssertNotNil(FindDescendant(Root, ntWhile), 'Missing while statement');
  finally
    Root.Free;
  end;
end;

procedure TestExceptionHandling;
var
  Root: TSyntaxNode;
begin
  Root := ParseSource('unit Example; interface implementation procedure Run; ' +
    'begin try DoWork; except on E: Exception do Handle(E); end; end; end.');
  try
    AssertNotNil(FindDescendant(Root, ntTry), 'Missing try statement');
    AssertNotNil(FindDescendant(Root, ntExcept), 'Missing except block');
    AssertNotNil(FindDescendant(Root, ntExceptionHandler), 'Missing exception handler');
  finally
    Root.Free;
  end;
end;

procedure TestGenericRecordAndProperty;
var
  Root: TSyntaxNode;
begin
  Root := ParseSource('unit Example; interface type ' +
    'TBox<T: class> = class private FValue: T; public property Value: T read FValue; end; ' +
    'TPair = record Left, Right: Integer; end; implementation end.');
  try
    AssertNotNil(FindDescendant(Root, ntTypeParams), 'Missing generic parameters');
    AssertNotNil(FindDescendant(Root, ntClassConstraint), 'Missing class constraint');
    AssertNotNil(FindDescendant(Root, ntProperty), 'Missing property');
    AssertTrue(CountDescendants(Root, ntTypeDecl) >= 2, 'Missing type declarations');
  finally
    Root.Free;
  end;
end;

procedure TestLiteralsAndUnicode;
var
  Root: TSyntaxNode;
  Xml: string;
begin
  Root := ParseSource('unit Umlaut; interface const Greeting = ''Grüße & <Hallo>''; ' +
    'implementation end.');
  try
    AssertTrue(CountDescendants(Root, ntLiteral) > 0, 'Missing literal');
    Xml := TSyntaxTreeWriter.ToXML(Root, False, True);
    AssertContains('<?xml version="1.0"?>', Xml, 'Missing XML header.');
    AssertContains('&amp;', Xml, 'Ampersand was not encoded.');
    AssertContains('&lt;', Xml, 'Less-than sign was not encoded.');
  finally
    Root.Free;
  end;
end;

procedure TestSourcePositions;
var
  Root, UnitNode: TSyntaxNode;
begin
  Root := ParseSource('unit Positioned;' + sLineBreak + 'interface' + sLineBreak +
    'implementation' + sLineBreak + 'end.');
  try
    UnitNode := FindDescendant(Root, ntUnit);
    AssertTrue(UnitNode.Line > 0, 'Unit line must be positive');
    AssertTrue(UnitNode.Col > 0, 'Unit column must be positive');
    AssertTrue(TCompoundSyntaxNode(FindDescendant(Root, ntInterface)).EndLine >= 2,
      'Interface end position was not recorded');
  finally
    Root.Free;
  end;
end;

procedure TestConstantEndPosition;
var
  Root, ConstsNode, Node, Spanning, Single: TSyntaxNode;
begin
  Root := ParseSource('unit Consts;' + sLineBreak + 'interface' + sLineBreak + 'const' +
    sLineBreak + '  Spanning = ''first part '' +' + sLineBreak + '    ''second part'';' +
    sLineBreak + '  Single = 42;' + sLineBreak + 'implementation' + sLineBreak + 'end.');
  try
    ConstsNode := FindDescendant(Root, ntConstants);
    AssertNotNil(ConstsNode, 'No const section was produced');
    Spanning := nil;
    Single := nil;
    for Node in ConstsNode.ChildNodes do
      if Node.Typ = ntConstant then
        if Node.Line = 4 then
          Spanning := Node
        else if Node.Line = 6 then
          Single := Node;

    AssertNotNil(Spanning, 'No constant starting on line 4');
    AssertTrue(Spanning is TCompoundSyntaxNode,
      'Constant node must be compound so it can carry an end position');
    AssertEquals(5, TCompoundSyntaxNode(Spanning).EndLine,
      'A multi-line constant must reach the last line of its value');

    AssertNotNil(Single, 'No constant starting on line 6');
    AssertEquals(6, TCompoundSyntaxNode(Single).EndLine,
      'A single-line constant must end on its own line, not run on to what follows');
  finally
    Root.Free;
  end;
end;

procedure TestInvalidSyntax;
var
  Root: TSyntaxNode;
  Raised: Boolean;
begin
  Root := nil;
  Raised := False;
  try
    Root := ParseSource('unit Broken; interface implementation begin');
  except
    on ESyntaxTreeException do
      Raised := True;
  end;
  Root.Free;
  AssertTrue(Raised, 'Invalid syntax did not raise ESyntaxTreeException');
end;

{$IFNDEF FPC}
procedure TestBinarySerializationRoundTrip;
var
  OriginalRoot, RestoredRoot: TSyntaxNode;
  Serializer: TBinarySerializer;
  Stream: TMemoryStream;
begin
  OriginalRoot := ParseSource('unit BinaryRoundTrip; interface implementation end.');
  RestoredRoot := nil;
  Serializer := TBinarySerializer.Create;
  Stream := TMemoryStream.Create;
  try
    AssertTrue(Serializer.Write(Stream, OriginalRoot), 'Binary write failed');
    Stream.Position := 0;
    AssertTrue(Serializer.Read(Stream, RestoredRoot), 'Binary read failed');
    AssertEquals(TSyntaxTreeWriter.ToXML(OriginalRoot, False, False),
      TSyntaxTreeWriter.ToXML(RestoredRoot, False, False), 'Round-trip tree.');
  finally
    Stream.Free;
    Serializer.Free;
    RestoredRoot.Free;
    OriginalRoot.Free;
  end;
end;
{$ENDIF}

procedure RunAllTests;
begin
  RunTest('AST.UnitStructure', TestUnitStructure);
  RunTest('AST.MethodAndParameters', TestMethodAndParameters);
  RunTest('AST.ControlFlow', TestControlFlow);
  RunTest('AST.ExceptionHandling', TestExceptionHandling);
  RunTest('AST.GenericRecordAndProperty', TestGenericRecordAndProperty);
  RunTest('Writer.LiteralsUnicodeAndXmlEscaping', TestLiteralsAndUnicode);
  RunTest('AST.SourcePositions', TestSourcePositions);
  RunTest('AST.ConstantEndPosition', TestConstantEndPosition);
  RunTest('Parser.InvalidSyntax', TestInvalidSyntax);
  {$IFNDEF FPC}
  RunTest('Serialization.BinaryRoundTrip', TestBinarySerializationRoundTrip);
  {$ENDIF}
  RunSnippetTests;
end;

end.
