program AstTree;

uses
  Vcl.Forms,
  AstTreeMain in 'AstTreeMain.pas' {Form33};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm33, Form33);
  Application.Run;
end.
