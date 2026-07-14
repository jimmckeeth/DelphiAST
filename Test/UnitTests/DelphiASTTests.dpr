program DelphiASTTests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DelphiAST.Tests in 'DelphiAST.Tests.pas',
  DelphiAST.TestFramework in 'DelphiAST.TestFramework.pas',
  DelphiAST.TestSupport in 'DelphiAST.TestSupport.pas';

begin
  RunAllTests;
  ExitCode := FinishTests;
end.
