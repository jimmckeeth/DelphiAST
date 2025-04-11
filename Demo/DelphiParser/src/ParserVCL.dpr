program ParserVCL;

uses
  FastMM4,
  Forms,
  uMainForm in 'forms\uMainForm.pas' {MainForm},
  uIncludeHandler in 'core\uIncludeHandler.pas',
  uParserCore in 'core\uParserCore.pas',
  uMemoryUtils in 'utils\uMemoryUtils.pas',
  uParserUtils in 'utils\uParserUtils.pas',
  uStringUsageLogging in 'utils\uStringUsageLogging.pas';

{$R *.res}

begin
  System.ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
