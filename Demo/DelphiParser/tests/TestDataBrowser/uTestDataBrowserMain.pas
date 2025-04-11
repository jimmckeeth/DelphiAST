unit uTestDataBrowserMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uParserCore,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, RzDBGrid, Vcl.DBCtrls, RzDBEdit;

type
  TForm32 = class(TForm)
  MemParseData: TFDMemTable;
  DataSource1: TDataSource;
  RzDBGrid1: TRzDBGrid;
  RzDBMemo1: TRzDBMemo;
  RzDBMemo2: TRzDBMemo;
  RzDBMemo3: TRzDBMemo;
  procedure FormCreate(Sender: TObject);
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
  CTestDataPath = '..\..\..\data';

procedure TForm32.FormCreate(Sender: TObject);
begin
  for var FileName in TDirectory.GetFiles(CTestDataPath, '*.*') do
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
        parser.MemoryUsage]);
    finally
      parser.Free;
  end;

  end;

end;

end.
