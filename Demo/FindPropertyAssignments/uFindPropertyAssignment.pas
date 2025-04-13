unit uFindPropertyAssignment;

interface

uses
  DelphiAST,
  DelphiAST.Classes,
  DelphiAST.Consts,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TFindPropertyAssignment = class
  public type
    TResult = record
      LineNumber: UInt64;
      FullName: string;
      Value: string;
      constructor Create(ALineNumber: UInt64; AFullName, AValue: String);
    end;
    TResults = TArray<TResult>;
  private
    FValid: Boolean;
    FContextStack: TStack<string>;
    FCurrentFileName: string;
    FTargetClassName: string;
    FTargetPropertyName: string;
    FResults: TList<TResult>;

    procedure ProcessNode(Node: TSyntaxNode);
    procedure HandleWithStatement(Node: TSyntaxNode);
    procedure HandleAssignment(Node: TSyntaxNode);
    procedure ProcessChildNodes(Node: TSyntaxNode);
    procedure PopWithContext(Node: TSyntaxNode);

    function GetFullNameWithContext(const BaseName: string; Node: TSyntaxNode): string;
    //function TryGetWithContext(Node: TSyntaxNode; var Context: string): Boolean;
    procedure Parse;
    procedure SetCurrentFileName(const Value: string);
    procedure SetTargetClassName(const Value: string);
    procedure SetTargetPropertyName(const Value: string);
    function GetResults: TResults;
    function GetFullName(Node: TSyntaxNode): string;
  public
    property TargetClassName: string read FTargetClassName write SetTargetClassName;
    property TargetPropertyName: string read FTargetPropertyName write SetTargetPropertyName;
    property CurrentFileName: string read FCurrentFileName write SetCurrentFileName;
    property Results: TResults read GetResults;
    constructor Create; overload;
    constructor Create(const ATargetClassName, ATargetPropertyName: string); overload;
    destructor Destroy; override;
  end;

implementation

function TFindPropertyAssignment.GetFullName(Node: TSyntaxNode): string;
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
            (TypeNode.GetAttribute(anName) = FTargetClassName) then
          begin
            // Look for indexed access like Controls[i]
            IndexNode := Node.ChildNodes[1].FindNode(ntIndexed);
            if not Assigned(IndexNode) then
              Result := FTargetClassName+'(' + GetFullName(Node.ChildNodes[1]) + ')'
//            else
//              {TODO -cTesting : This branch is unused and is untested. }
//              Result := FTargetClassName+'(' + GetFullName(Node.ChildNodes[1]) + '[i])'
          end;
        end;
      end;

//    ntIndexed:
//      begin {TODO -cTesting : This branch is unused and is untested. }
//        // Handle array access like Controls[i]
//        if Node.HasChildren then
//          Result := GetFullName(Node.ChildNodes[0]) + '[i]';
//      end;
  end;

{TODO -cTesting : This branch is unused and is untested. }
  // Look for parent type cast when we have just the property
//  if SameText(Result, FTargetPropertyName) then
//  begin
//    ParentNode := Node.ParentNode;
//    while Assigned(ParentNode) do
//    begin
//      if ParentNode.Typ = ntCall then
//      begin
//        TypeNode := ParentNode.ChildNodes[0];
//        if (TypeNode.Typ = ntIdentifier) and
//          (TypeNode.GetAttribute(anName) = FTargetClassName) then
//        begin
//          Result := FTargetClassName + '().' + FTargetPropertyName;
//          Break;
//        end;
//      end;
//      ParentNode := ParentNode.ParentNode;
//    end;
//  end;
end;

{ TPanelColorFinder }

constructor TFindPropertyAssignment.Create;
begin
  inherited;
  FResults := TList<TResult>.Create;
  FValid := False;
  FContextStack := TStack<string>.Create;
  FTargetClassName := 'TPanel'; // Default class name
  FTargetPropertyName := 'Color'; // Default property name
end;

constructor TFindPropertyAssignment.Create(const ATargetClassName, ATargetPropertyName: string);
begin
  Create;
  FTargetClassName := ATargetClassName;
  FTargetPropertyName := ATargetPropertyName;
end;

destructor TFindPropertyAssignment.Destroy;
begin
  FContextStack.Free;
  FResults.Free;
  inherited;
end;

{TODO -cTesting : This function is unused and is untested. }
//function TFindPropertyAssignment.TryGetWithContext(Node: TSyntaxNode; var Context:
//  string): Boolean;
//var
//  TypeCheck: TSyntaxNode;
//  Expression: TSyntaxNode;
//begin
//  Result := False;
//  TypeCheck := Node;
//
//  // Walk up the tree looking for with statement
//  while Assigned(TypeCheck) do
//  begin
//    if TypeCheck.Typ = ntWith then
//    begin
//      Expression := TypeCheck.FindNode([ntExpressions]);
//      if Assigned(Expression) and Expression.HasChildren then
//      begin
//        Context := GetFullName(Expression.ChildNodes[0]);
//        Result := True;
//        Break;
//      end;
//    end;
//    TypeCheck := TypeCheck.ParentNode;
//  end;
//end;

function TFindPropertyAssignment.GetFullNameWithContext(const BaseName: string; Node:
  TSyntaxNode): string;
begin
  Result := BaseName;

  // Always check for context if we have the target property name
  if SameText(Result, FTargetPropertyName) then
  begin
    // First check stack for with context
    if FContextStack.Count > 0 then
      Result := FContextStack.Peek + '.' + Result
//    else
//    begin {TODO -cTesting : This branch is unused and is untested. }
//      var Context: string;
//      if TryGetWithContext(Node, Context) then
//        Result := Context + '.' + Result;
//    end;
  end;
end;

function TFindPropertyAssignment.GetResults: TResults;
begin
  if not FValid then Parse;
  Result := FResults.ToArray;
end;

procedure TFindPropertyAssignment.HandleWithStatement(Node: TSyntaxNode);
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

procedure TFindPropertyAssignment.HandleAssignment(Node: TSyntaxNode);
var
  LHS, RHS: TSyntaxNode;
  FullName, Value: string;
begin
  LHS := Node.FindNode([ntLHS]);
  RHS := Node.FindNode([ntRHS]);
  if Assigned(LHS) and Assigned(RHS) then
  begin
    // Get the value from RHS - drill down to the IDENTIFIER node
    Value := '';
    if RHS.HasChildren then
    begin
      var ExprNode := RHS.ChildNodes[0];  // Get EXPRESSION node
      if ExprNode.HasChildren then
      begin
        var IdNode := ExprNode.ChildNodes[0];  // Get IDENTIFIER node
        if IdNode.Typ = ntIdentifier then
          Value := IdNode.GetAttribute(anName);
      end;
    end;

    // First check if this is a simple identifier matching the target property
    if LHS.HasChildren and (LHS.ChildNodes[0].Typ = ntIdentifier) and
      SameText(LHS.ChildNodes[0].GetAttribute(anName), FTargetPropertyName) then
    begin
      // Get name with context first
      FullName := GetFullNameWithContext(FTargetPropertyName, Node);
    end
    else
    begin
      // Get the full name otherwise
      FullName := GetFullName(LHS);
    end;
    FResults.Add(TResult.Create(Node.Line, FullName, Value));
  end;
end;

procedure TFindPropertyAssignment.ProcessChildNodes(Node: TSyntaxNode);
var
  i: Integer;
begin
  for i := 0 to High(Node.ChildNodes) do
    ProcessNode(Node.ChildNodes[i]);
end;

procedure TFindPropertyAssignment.PopWithContext(Node: TSyntaxNode);
begin
  if (Node.Typ = ntWith) and (FContextStack.Count > 0) then
    FContextStack.Pop;
end;

procedure TFindPropertyAssignment.ProcessNode(Node: TSyntaxNode);
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

procedure TFindPropertyAssignment.SetCurrentFileName(const Value: string);
begin
  FValid := False;
  FCurrentFileName := Value;
end;

procedure TFindPropertyAssignment.SetTargetClassName(const Value: string);
begin
  FValid := False;
  FTargetClassName := Value;
end;

procedure TFindPropertyAssignment.SetTargetPropertyName(const Value: string);
begin
  FValid := False;
  FTargetPropertyName := Value;
end;

procedure TFindPropertyAssignment.Parse;
var
  SyntaxTree: TSyntaxNode;
begin
  SyntaxTree := TPasSyntaxTreeBuilder.Run(FCurrentFileName, False);
  try
    ProcessNode(SyntaxTree);
  finally
    SyntaxTree.Free;
  end;
  FValid := True;
end;

{ TFindPropertyAssignment.TResult }

constructor TFindPropertyAssignment.TResult.Create(ALineNumber: UInt64;
  AFullName, AValue: String);
begin
  LineNumber := ALineNumber;
  FullName := AFullName;
  Value := AValue;
end;

end.
