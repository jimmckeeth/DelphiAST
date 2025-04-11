program TestDataBrowser;

uses
  FastMM4,
  Vcl.Forms,
  uTestDataBrowserMain in 'uTestDataBrowserMain.pas' {Form32};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm32, Form32);
  Application.Run;
end.
