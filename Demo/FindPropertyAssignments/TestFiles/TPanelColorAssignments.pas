// used to test FindPropertyAssignments
unit TPanelColorAssignments;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm31 = class(TForm)
		Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form31: TForm31;

implementation

{$R *.dfm}

procedure TForm31.Button1Click(Sender: TObject);
begin
	for var i := 0 to Pred(ControlCount) do
	begin
		if Controls[i] is TPanel then
		begin
			if TPanel(Controls[i]).Color = clBtnFace then
			  TPanel(Controls[i]).Color := clGreen;
		end;
  end;
end;

procedure TForm31.FormCreate(Sender: TObject);
begin
	with Panel2 do
		color := clBlue;
end;

procedure TForm31.FormShow(Sender: TObject);
begin
  Panel1.Color := clRed;
end;

end.
