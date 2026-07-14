unit DelphiAST.TestFramework;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  ETestFailure = class(Exception);
  TTestProcedure = procedure;

procedure AssertTrue(Condition: Boolean; const Message: string = '');
procedure AssertFalse(Condition: Boolean; const Message: string = '');
procedure AssertNotNil(Value: Pointer; const Message: string = '');
procedure AssertEquals(Expected, Actual: Integer; const Message: string = ''); overload;
procedure AssertEquals(const Expected, Actual: string; const Message: string = ''); overload;
procedure AssertContains(const ExpectedPart, Actual: string; const Message: string = '');
procedure RunTest(const Name: string; Test: TTestProcedure);
function FinishTests: Integer;

implementation

var
  TestsRun: Integer;
  TestsPassed: Integer;
  TestsFailed: Integer;

procedure Fail(const Message: string);
begin
  raise ETestFailure.Create(Message);
end;

procedure AssertTrue(Condition: Boolean; const Message: string);
begin
  if not Condition then
    if Message = '' then
      Fail('Expected True')
    else
      Fail(Message);
end;

procedure AssertFalse(Condition: Boolean; const Message: string);
begin
  if Condition then
    if Message = '' then
      Fail('Expected False')
    else
      Fail(Message);
end;

procedure AssertNotNil(Value: Pointer; const Message: string);
begin
  if Value = nil then
    if Message = '' then
      Fail('Expected a non-nil value')
    else
      Fail(Message);
end;

procedure AssertEquals(Expected, Actual: Integer; const Message: string);
begin
  if Expected <> Actual then
    Fail(Format('%s Expected %d but got %d', [Message, Expected, Actual]));
end;

procedure AssertEquals(const Expected, Actual: string; const Message: string);
begin
  if Expected <> Actual then
    Fail(Format('%s Expected "%s" but got "%s"', [Message, Expected, Actual]));
end;

procedure AssertContains(const ExpectedPart, Actual: string; const Message: string);
begin
  if Pos(ExpectedPart, Actual) = 0 then
    Fail(Format('%s Expected to find "%s"', [Message, ExpectedPart]));
end;

procedure RunTest(const Name: string; Test: TTestProcedure);
begin
  Inc(TestsRun);
  WriteLn('[RUN ] ', Name);
  Flush(Output);
  try
    Test;
    Inc(TestsPassed);
    WriteLn('[PASS] ', Name);
  except
    on E: Exception do
    begin
      Inc(TestsFailed);
      WriteLn('[FAIL] ', Name);
      WriteLn('       ', E.ClassName, ': ', E.Message);
      {$IFDEF FPC}DumpExceptionBackTrace(Output);{$ENDIF}
    end;
  end;
end;

function FinishTests: Integer;
begin
  WriteLn;
  WriteLn(Format('%d tests: %d passed, %d failed',
    [TestsRun, TestsPassed, TestsFailed]));
  if TestsFailed = 0 then
    Result := 0
  else
    Result := 1;
end;

end.
