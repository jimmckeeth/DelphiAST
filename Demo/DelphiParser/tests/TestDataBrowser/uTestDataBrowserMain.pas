unit uTestDataBrowserMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uParserCore,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, RzDBGrid, Vcl.DBCtrls, RzDBEdit, SynEdit, SynDBEdit,
  Vcl.ExtCtrls, RzPanel, RzSplit, SynEditCodeFolding, SynHighlighterPas,
  SynEditHighlighter, SynHighlighterXML, Vcl.Menus;

type
  TForm32 = class(TForm)
  MemParseData: TFDMemTable;
  DataSource1: TDataSource;
  RzDBGrid1: TRzDBGrid;
  RzDBMemo2: TRzDBMemo;
  RzDBMemo3: TRzDBMemo;
    DBSynEdit1: TDBSynEdit;
    SynEdit1: TDBSynEdit;
    SynXMLSyn1: TSynXMLSyn;
    RzSplitter1: TRzSplitter;
    RzSplitter2: TRzSplitter;
    SynPasSyn1: TSynPasSyn;
    PopupMenu1: TPopupMenu;
    PopupMenu11: TMenuItem;
  procedure FormCreate(Sender: TObject);
    procedure DBSynEdit1Click(Sender: TObject);
    procedure DBSynEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure PopupMenu11Click(Sender: TObject);
  private
    procedure ParseFile(Path, FileName: String);
  { Private declarations }
  public
  { Public declarations }
  end;

var
  Form32: TForm32;

implementation

{$R *.dfm}

uses
  IOUtils;

const
  CTestDataPath: array of string = [
    '..\..\..\..\..\..\..\FindPropertyAssignments\Tests\TestFiles',
    '..\..\..\data',
    '..\..\..\..\..\..\source',
    '..\..\..\..\..\..\source\SimpleParser',
    '..\..\..\..\..\..\test\snippets'];
  CTestDataMasks: array of string = [
    '*.pas', '*.inc', '*.dpr'];

procedure TForm32.DBSynEdit1Click(Sender: TObject);
begin
  Caption := DBSynEdit1.Lines[DBSynEdit1.CaretY-1];
end;

procedure TForm32.DBSynEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  Caption := DBSynEdit1.Lines[DBSynEdit1.CaretY-1];
end;

procedure TForm32.ParseFile(Path, FileName: String);
begin
  var parser := TParserCore.create();
  try
    var lines :=  TFile.ReadAllLines(FileName);
    parser.UseStringInterning := True;
    var status := parser.Parse(FileName);
    var xmlLineCount := parser.XMLOutput.CountChar(#10) + 1;
    MemParseData.AppendRecord([
      TPath.GetFileName(fileName),
      status,
      String.Join(sLineBreak, lines),
      parser.XMLOutput,
      parser.Comments,
      parser.Errors,
      parser.ParseTime,
      parser.MemoryUsage,
      path,
      TPath.GetFileName(path),
      Length(Lines), 
      xmlLineCount]);
  finally
    parser.Free;
  end;
end;

procedure TForm32.PopupMenu11Click(Sender: TObject);
begin
 var sourceFile := TPath.Combine(MemParseData.FieldByName('path').AsWideString, MemParseData.FieldByName('DataFileName').AsWideString);
 var astfile := TPath.ChangeExtension(sourcefile, '.ast');
 TFile.WriteAllText(astFile, MemParseData.FieldByName('AstXML').AsWideString);

end;

procedure TForm32.FormCreate(Sender: TObject);
begin
  for var path in CTestDataPath do
  begin
    for var mask in CTestDataMasks do
    begin
      for var FileName in TDirectory.GetFiles(path, mask) do
        ParseFile(path, FileName);
    end;
  end;
  MemParseData.First;
end;

end.
