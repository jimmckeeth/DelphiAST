unit uMainForm;

{$include ..\utils\defines.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ComCtrls, ExtCtrls, uParserCore, uIncludeHandler;

type
  TMainForm = class(TForm)
    OutputMemo: TMemo;
    MainMenu: TMainMenu;
    OpenDelphiUnit1: TMenuItem;
    OpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
    CheckBox1: TCheckBox;
    CommentsBox: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Label1: TLabel;
    Label2: TLabel;
    procedure OpenDelphiUnit1Click(Sender: TObject);
  private
    FParser: TParserCore;
    procedure UpdateStatusBarText(const StatusText: string);
    procedure Parse(const FileName: string; UseStringInterning: Boolean);
  public
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

uses
  StringPool,
  {$IFDEF FastMM4}
  {$IFNDEF FPC}
    uStringUsageLogging,
  {$ENDIF}
  uMemoryUtils,
  {$ENDIF}
  DelphiAST, DelphiAST.Writer, DelphiAST.Classes,
  SimpleParser.Lexer.Types, IOUtils, Diagnostics,
  DelphiAST.SimpleParserEx;

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.Parse(const FileName: string; UseStringInterning: Boolean);
begin
  OutputMemo.Clear;
  CommentsBox.Clear;

  if not Assigned(FParser) then
    FParser := TParserCore.Create;
    
  FParser.UseStringInterning := UseStringInterning;
  
  if FParser.Parse(FileName) then
  begin
    OutputMemo.Lines.Text := FParser.XMLOutput;
    CommentsBox.Items.Assign(FParser.Comments);
    {$IFDEF FastMM4}
    UpdateStatusBarText(Format('Parsed file in %d ms using %d K memory',
      [FParser.ParseTime, FParser.MemoryUsage]));
    {$ELSE}
    UpdateStatusBarText(Format('Parsed file in %d ms',
      [FParser.ParseTime]));
    {$ENDIF}
  end;
end;

procedure TMainForm.OpenDelphiUnit1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
    Parse(OpenDialog.FileName, CheckBox1.Checked);
end;

procedure TMainForm.UpdateStatusBarText(const StatusText: string);
begin
  StatusBar.SimpleText:= StatusText;
end;

destructor TMainForm.Destroy;
begin
  FParser.Free;
  inherited;
end;

end.
