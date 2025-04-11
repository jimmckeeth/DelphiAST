program FindPanelColors;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  DelphiAST, DelphiAST.Classes, DelphiAST.Consts;

type
  TPanelColorFinder = class
  private
    FContextStack: TStack<string>;
    FCurrentFileName: string;

    procedure ProcessNode(Node: TSyntaxNode);
    procedure HandleWithStatement(Node: TSyntaxNode);
    procedure HandleAssignment(Node: TSyntaxNode);
    procedure ProcessChildNodes(Node: TSyntaxNode);
    procedure PopWithContext(Node: TSyntaxNode);

    function GetFullNameWithContext(const BaseName: string; Node: TSyntaxNode):
      string;
    function TryGetWithContext(Node: TSyntaxNode; var Context: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure FindInFile(const FileName: string);
  end;

function GetFullName(Node: TSyntaxNode): string;
var
  j: Integer;
  ParentNode, TypeNode, IndexNode: TSyntaxNode;
begin
  Result := '';
  if Node = nil then
    Exit;

  case Node.Typ of
    ntLHS:
      if Node.HasChildren then
        Result := GetFullName(Node.ChildNodes[0]);

    ntIdentifier:
      Result := Node.GetAttribute(anName);

    ntDot:
      begin
        for j := 0 to High(Node.ChildNodes) do
        begin
          if Result <> '' then
            Result := Result + '.';
          Result := Result + GetFullName(Node.ChildNodes[j]);
        end;
      end;

    ntCall:
      begin
        // Handle type casts
        if Node.HasChildren and (Length(Node.ChildNodes) >= 2) then
        begin
          TypeNode := Node.ChildNodes[0];
          if (TypeNode.Typ = ntIdentifier) and
            (TypeNode.GetAttribute(anName) = 'TPanel') then
          begin
            // Look for indexed access like Controls[i]
            IndexNode := Node.ChildNodes[1].FindNode(ntIndexed);
            if Assigned(IndexNode) then
              Result := 'TPanel(' + GetFullName(Node.ChildNodes[1]) + '[i])'
            else
              Result := 'TPanel(' + GetFullName(Node.ChildNodes[1]) + ')';
          end;
        end;
      end;

    ntIndexed:
      begin
        // Handle array access like Controls[i]
        if Node.HasChildren then
          Result := GetFullName(Node.ChildNodes[0]) + '[i]';
      end;
  end;

  // Look for parent type cast when we have just 'Color'
  if SameText(Result, 'Color') then
  begin
    ParentNode := Node.ParentNode;
    while Assigned(ParentNode) do
    begin
      if ParentNode.Typ = ntCall then
      begin
        TypeNode := ParentNode.ChildNodes[0];
        if (TypeNode.Typ = ntIdentifier) and
          (TypeNode.GetAttribute(anName) = 'TPanel') then
        begin
          Result := 'TPanel(Controls[i]).Color';
          Break;
        end;
      end;
      ParentNode := ParentNode.ParentNode;
    end;
  end;
end;

{ TPanelColorFinder }

constructor TPanelColorFinder.Create;
begin
  inherited;
  FContextStack := TStack<string>.Create;
end;

destructor TPanelColorFinder.Destroy;
begin
  FContextStack.Free;
  inherited;
end;

function TPanelColorFinder.TryGetWithContext(Node: TSyntaxNode; var Context:
  string): Boolean;
var
  TypeCheck: TSyntaxNode;
  Expression: TSyntaxNode;
begin
  Result := False;
  TypeCheck := Node;

  // Walk up the tree looking for with statement
  while Assigned(TypeCheck) do
  begin
    if TypeCheck.Typ = ntWith then
    begin
      Expression := TypeCheck.FindNode([ntExpressions]);
      if Assigned(Expression) and Expression.HasChildren then
      begin
        Context := GetFullName(Expression.ChildNodes[0]);
        Result := True;
        Break;
      end;
    end;
    TypeCheck := TypeCheck.ParentNode;
  end;
end;

function TPanelColorFinder.GetFullNameWithContext(const BaseName: string; Node:
  TSyntaxNode): string;
begin
  Result := BaseName;

  // Always check for context if we have a color identifier
  if SameText(Result, 'color') then
  begin
    // First check stack for with context
    if FContextStack.Count > 0 then
      Result := FContextStack.Peek + '.' + Result
        // Then try to find context in parent nodes
    else
    begin
      var Context: string;
      if TryGetWithContext(Node, Context) then
        Result := Context + '.' + Result;
    end;
  end;
end;

procedure TPanelColorFinder.HandleWithStatement(Node: TSyntaxNode);
var
  Expression: TSyntaxNode;
  Context: string;
begin
  Expression := Node.FindNode([ntExpressions]);
  if Assigned(Expression) and Expression.HasChildren then
  begin
    // Get the full name of the context object
    Context := GetFullName(Expression.ChildNodes[0].ChildNodes[0]);
    if Context <> '' then
    begin
      // Push the context onto the stack
      FContextStack.Push(Context);
    end;
  end;
end;

procedure TPanelColorFinder.HandleAssignment(Node: TSyntaxNode);
var
  LHS: TSyntaxNode;
  FullName: string;
begin
  Writeln(Format('Assignment found in %s at line %d:', [FCurrentFileName,
    Node.Line]));

  LHS := Node.FindNode([ntLHS]);
  if Assigned(LHS) then
  begin
    // First check if this is a simple color identifier
    if LHS.HasChildren and (LHS.ChildNodes[0].Typ = ntIdentifier) and
      SameText(LHS.ChildNodes[0].GetAttribute(anName), 'color') then
    begin
      // Get name with context first
      FullName := GetFullNameWithContext('color', Node);
    end
    else
    begin
      // Get the full name otherwise
      FullName := GetFullName(LHS);
    end;

    Writeln('  Assigned To: ', FullName);
  end;
end;

procedure TPanelColorFinder.ProcessChildNodes(Node: TSyntaxNode);
var
  i: Integer;
begin
  for i := 0 to High(Node.ChildNodes) do
    ProcessNode(Node.ChildNodes[i]);
end;

procedure TPanelColorFinder.PopWithContext(Node: TSyntaxNode);
begin
  if (Node.Typ = ntWith) and (FContextStack.Count > 0) then
    FContextStack.Pop;
end;

procedure TPanelColorFinder.ProcessNode(Node: TSyntaxNode);
begin
  if Node.Typ = ntWith then
  begin
    HandleWithStatement(Node);
    ProcessChildNodes(Node);
    PopWithContext(Node);
  end
  else
  begin
    if Node.Typ = ntAssign then
      HandleAssignment(Node);
    ProcessChildNodes(Node);
  end;
end;

procedure TPanelColorFinder.FindInFile(const FileName: string);
var
  SyntaxTree: TSyntaxNode;
begin
  FCurrentFileName := FileName;
  SyntaxTree := TPasSyntaxTreeBuilder.Run(FileName, False);
  try
    ProcessNode(SyntaxTree);
  finally
    SyntaxTree.Free;
  end;
end;

var
  Finder: TPanelColorFinder;
  Path: string;
begin
  try
    Finder := TPanelColorFinder.Create;
    try
      if ParamStr(1) = '' then
      begin
        Writeln('Please provide path to Delphi source file');
        Exit;
      end;

      Path := ParamStr(1);
      if not FileExists(Path) then
      begin
        Writeln('File not found: ', Path);
        Exit;
      end;

      Finder.FindInFile(Path);
    finally
      Finder.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

