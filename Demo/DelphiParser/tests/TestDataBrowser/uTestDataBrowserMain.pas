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
  SynEditHighlighter, SynHighlighterXML;

type
  TForm32 = class(TForm)
  MemParseData: TFDMemTable;
  DataSource1: TDataSource;
  RzDBGrid1: TRzDBGrid;
  RzDBMemo2: TRzDBMemo;
  RzDBMemo3: TRzDBMemo;
    DBSynEdit1: TDBSynEdit;
    SynEdit1: TSynEdit;
    SynXMLSyn1: TSynXMLSyn;
    SynPasSyn1: TSynPasSyn;
    RzSplitter1: TRzSplitter;
    RzSplitter2: TRzSplitter;
  procedure FormCreate(Sender: TObject);
    procedure MemParseDataAfterScroll(DataSet: TDataSet);
    procedure DBSynEdit1Click(Sender: TObject);
    procedure DBSynEdit1KeyPress(Sender: TObject; var Key: Char);
  private
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
    '..\..\..\data',
    '..\..\..\..\..\..\source',
    '..\..\..\..\..\..\source\SimpleParser',
    '..\..\..\..\..\..\test\snippets'];

procedure TForm32.DBSynEdit1Click(Sender: TObject);
begin
  Caption := DBSynEdit1.Lines[DBSynEdit1.CaretY-1];
end;

procedure TForm32.DBSynEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  Caption := DBSynEdit1.Lines[DBSynEdit1.CaretY-1];
end;

procedure TForm32.FormCreate(Sender: TObject);
begin
  for var path in CTestDataPath do
  begin

    for var FileName in TDirectory.GetFiles(path, '*.*') do
    begin
      var parser := TParserCore.create();
      try
        parser.UseStringInterning := True;
        var status := parser.Parse(FileName);
        MemParseData.AppendRecord([
          TPath.GetFileName(fileName),
          status,
          parser.XMLOutput,
          parser.Comments,
          parser.Errors,
          parser.ParseTime,
          parser.MemoryUsage,
          path,
          TPath.GetFileName(path)]);
      finally
        parser.Free;
      end;

    end;
  end;

end;

procedure TForm32.MemParseDataAfterScroll(DataSet: TDataSet);
begin
  SynEdit1.Lines.LoadFromFile(
    TPath.Combine(
      MemParseData.Fields[7].AsString,
      MemParseData.Fields[0].AsString));
end;

end.
