// https://blogs.embarcadero.com/code-snippet-ide-debug-visualizer-plugin-for-generic-and-template-types/
// https://web.archive.org/web/20210417082409/http://edn.embarcadero.com/article/40268

unit SyntaxNodeVisualizer;

interface

procedure Register;

implementation

uses
  Classes, SysUtils, ToolsAPI, DelphiAST.Classes;

type
  TSyntaxNodeVisualizer = class(TInterfacedObject, IOTADebuggerVisualizer,
    IOTADebuggerVisualizer250, IOTADebuggerVisualizerValueReplacer,
    IOTAThreadNotifier, IOTAThreadNotifier160)
  private
    FCompleted: Boolean;
    FDeferredResult: string;
  public
    { IOTADebuggerVisualizer }
    function GetSupportedTypeCount: Integer;
    procedure GetSupportedType(Index: Integer; var TypeName: string;
      var AllDescendants: Boolean); overload;
    function GetVisualizerIdentifier: string;
    function GetVisualizerName: string;
    function GetVisualizerDescription: string;
    { IOTADebuggerVisualizer250 }
    procedure GetSupportedType(Index: Integer; var TypeName: string;
      var AllDescendants: Boolean; var IsGeneric: Boolean); overload;
    { IOTADebuggerVisualizerValueReplacer }
    function GetReplacementValue(const Expression, TypeName,
      EvalResult: string): string;
    { IOTAThreadNotifier }
    procedure EvaluateComplete(const ExprStr: string; const ResultStr: string;
      CanModify: Boolean; ResultAddress: Cardinal; ResultSize: Cardinal;
      ReturnCode: Integer);  overload;
    procedure ModifyComplete(const ExprStr: string; const ResultStr: string;
      ReturnCode: Integer);
    procedure ThreadNotify(Reason: TOTANotifyReason);
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
    { IOTAThreadNotifier160 }
    procedure EvaluateComplete(const ExprStr: string; const ResultStr: string;
      CanModify: Boolean; ResultAddress: TOTAAddress; ResultSize: LongWord;
      ReturnCode: Integer); overload;
  end;


{ TSyntaxNodeVisualizer }

procedure TSyntaxNodeVisualizer.AfterSave;
begin
  // don't care about this notification
end;

procedure TSyntaxNodeVisualizer.BeforeSave;
begin
  // don't care about this notification
end;

procedure TSyntaxNodeVisualizer.Destroyed;
begin
  // don't care about this notification
end;

procedure TSyntaxNodeVisualizer.Modified;
begin
  // don't care about this notification
end;

procedure TSyntaxNodeVisualizer.ModifyComplete(const ExprStr, ResultStr: string;
  ReturnCode: Integer);
begin
  // don't care about this notification
end;

procedure TSyntaxNodeVisualizer.EvaluateComplete(const ExprStr, ResultStr: string;
  CanModify: Boolean; ResultAddress, ResultSize: Cardinal; ReturnCode: Integer);
begin
  EvaluateComplete(ExprStr, ResultStr, CanModify, TOTAAddress(ResultAddress),
    LongWord(ResultSize), ReturnCode);
end;

procedure TSyntaxNodeVisualizer.EvaluateComplete(const ExprStr, ResultStr: string;
  CanModify: Boolean; ResultAddress: TOTAAddress; ResultSize: LongWord;
  ReturnCode: Integer);
begin
  FCompleted := True;
  if ReturnCode = 0 then
    FDeferredResult := ResultStr;
end;

procedure TSyntaxNodeVisualizer.ThreadNotify(Reason: TOTANotifyReason);
begin
  // don't care about this notification
end;

function TSyntaxNodeVisualizer.GetReplacementValue(const Expression, TypeName,
  EvalResult: string): string;
begin
  Result := 'TSyntaxNode:' + '; ' +
    'Expression: ' + Expression + '; ' +
    'Type name: ' + TypeName + '; ' +
    'Evaluation: ' + EvalResult;
end;

function TSyntaxNodeVisualizer.GetSupportedTypeCount: Integer;
begin
  Result := 1;
end;

procedure TSyntaxNodeVisualizer.GetSupportedType(Index: Integer;
  var TypeName: string; var AllDescendants: Boolean);
begin
  AllDescendants := True;
  TypeName := 'TSyntaxNode';
end;

procedure TSyntaxNodeVisualizer.GetSupportedType(Index: Integer;
  var TypeName: string; var AllDescendants: Boolean; var IsGeneric: Boolean);
begin
  AllDescendants := True;
  TypeName := 'TSyntaxNode';
  IsGeneric := False;
end;

function TSyntaxNodeVisualizer.GetVisualizerDescription: string;
begin
  Result := 'TSyntaxNode visualizer';
end;

function TSyntaxNodeVisualizer.GetVisualizerIdentifier: string;
begin
  Result := ClassName;
end;

function TSyntaxNodeVisualizer.GetVisualizerName: string;
begin
  Result := 'Sample TSyntaxNode Visualizer';
end;

var
  GenericVis: IOTADebuggerVisualizer;

procedure Register;
begin
  GenericVis := TSyntaxNodeVisualizer.Create;
  (BorlandIDEServices as IOTADebuggerServices).RegisterDebugVisualizer(GenericVis);
end;

procedure RemoveVisualizer;
var
  DebuggerServices: IOTADebuggerServices;
begin
  if Supports(BorlandIDEServices, IOTADebuggerServices, DebuggerServices) then
  begin
    DebuggerServices.UnregisterDebugVisualizer(GenericVis);
    GenericVis := nil;
  end;
end;

initialization

finalization
  RemoveVisualizer;

end.
