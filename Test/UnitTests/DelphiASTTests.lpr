program DelphiASTTests;

{$MODE DELPHI}

uses
  SysUtils,
  DelphiAST.Tests,
  DelphiAST.TestFramework;

begin
  RunAllTests;
  ExitCode := FinishTests;
end.
