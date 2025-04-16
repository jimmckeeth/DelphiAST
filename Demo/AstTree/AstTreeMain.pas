unit AstTreeMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,

  DelphiAST, DelphiAST.Classes, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  RzPanel, RzSplit;

type
  TForm33 = class(TForm)
    TreeView1: TTreeView;
    StringGrid1: TStringGrid;
    RzSplitter1: TRzSplitter;
    Panel1: TPanel;
    lblCol: TLabel;
    lblLine: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    lblNodeType: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Addition(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form33: TForm33;

implementation

{$R *.dfm}

uses
  DelphiAST.Consts,
  System.Rtti;

procedure TForm33.FormCreate(Sender: TObject);
var
  head: TSyntaxNode;
begin

  var ast := TPasSyntaxTreeBuilder.Create;
  try
    head := ast.run('C:\Users\jim\Documents\Git\FindPropertyAssignments\Tests\TestFiles\TPanelColorAssignments.pas');
  finally
    ast.Free;
  end;

  TreeView1.Items.AddObject(nil, TRttiEnumerationType.GetName(head.Typ).Substring(2), head);

  for var nt := Low(TAttributeName) to High(TAttributeName) do
  begin
    StringGrid1.Cells[0, ord(nt)+1] := TRttiEnumerationType.GetName(nt).Substring(2);
  end;
  stringgrid1.ColWidths[1] := 300;
  stringGrid1.Cells[0,0] := 'Attribute';
  stringGrid1.Cells[1,0] := 'Value';

  TreeView1.FullExpand;
end;

procedure TForm33.TreeView1Addition(Sender: TObject; Node: TTreeNode);
var
  synNode, synChild: TSyntaxNode;
begin
  synNode := TObject(Node.Data) as TSyntaxNode;

  for var i := 0 to pred(Length(synNode.ChildNodes)) do
  begin
    synChild := synNode.ChildNodes[i];

    TreeView1.Items.AddChildObject(node,
      TRttiEnumerationType.GetName(synChild.Typ).Substring(2), synChild);
  end;


end;

procedure TForm33.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  synNode: TSyntaxNode;
begin
  synNode := TObject(Node.Data) as TSyntaxNode;

  lblCol.Caption := synNode.Col.ToString;
  lblLine.Caption := synNode.Line.ToString;

  lblNodeType.Caption := synNode.ClassName;

  if synNode is TValuedSyntaxNode then
    label1.Caption := TValuedSyntaxNode(synNode).Value
  else if synNode is TCompoundSyntaxNode then
    label1.Caption := Format('EndCol: %d EndLine: %d',
      [TCompoundSyntaxNode(synNode).EndCol,
       TCompoundSyntaxNode(synNode).EndLine])
  else if synNode is TCommentNode then
    Label1.Caption := TCommentNode(synNode).Text
  else
    Label1.Caption := '';


  for var nt := Low(TAttributeName) to High(TAttributeName) do
  begin
    if synNode.HasAttribute(nt) then
      StringGrid1.Cells[1, ord(nt)+1] := synNode.GetAttribute(nt)
    else
      StringGrid1.Cells[1, ord(nt)+1] := '';
  end;
end;

end.
