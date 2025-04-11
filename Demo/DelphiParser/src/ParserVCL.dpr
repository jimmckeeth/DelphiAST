program ParserVCL;

{$Include utils\defines.inc}

uses
  {$IFDEF FastMM4}
  FastMM4,
  uStringUsageLogging in 'utils\uStringUsageLogging.pas',
  {$ENDIF}
  Forms,
  uMainForm in 'forms\uMainForm.pas' {MainForm},
  uIncludeHandler in 'core\uIncludeHandler.pas',
  uParserCore in 'core\uParserCore.pas',
  uMemoryUtils in 'utils\uMemoryUtils.pas',
  uParserUtils in 'utils\uParserUtils.pas';

{$R *.res}

begin
  System.ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
