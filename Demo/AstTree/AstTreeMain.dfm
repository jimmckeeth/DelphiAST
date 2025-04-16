object Form33: TForm33
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Form33'
  ClientHeight = 735
  ClientWidth = 943
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 25
  object RzSplitter1: TRzSplitter
    Left = 0
    Top = 0
    Width = 943
    Height = 735
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Position = 455
    Percent = 48
    SplitterWidth = 6
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 84
    ExplicitTop = 144
    ExplicitWidth = 865
    ExplicitHeight = 565
    BarSize = (
      455
      0
      461
      735)
    UpperLeftControls = (
      TreeView1)
    LowerRightControls = (
      StringGrid1
      Panel1)
    object TreeView1: TTreeView
      Left = 0
      Top = 0
      Width = 455
      Height = 735
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      Indent = 29
      ReadOnly = True
      TabOrder = 0
      OnAddition = TreeView1Addition
      OnChange = TreeView1Change
      ExplicitLeft = -225
      ExplicitTop = 131
      ExplicitWidth = 363
      ExplicitHeight = 715
    end
    object StringGrid1: TStringGrid
      Left = 0
      Top = 169
      Width = 482
      Height = 566
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      ColCount = 2
      DefaultColWidth = 120
      RowCount = 15
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowDefAlign]
      TabOrder = 0
      ExplicitLeft = -182
      ExplicitTop = 185
      ExplicitWidth = 458
      ExplicitHeight = 373
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 482
      Height = 169
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = ' '
      TabOrder = 1
      object lblCol: TLabel
        Left = 45
        Top = 10
        Width = 45
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'lblCol'
      end
      object lblLine: TLabel
        Left = 45
        Top = 36
        Width = 50
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'lblLine'
      end
      object Label4: TLabel
        Left = 4
        Top = 10
        Width = 30
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Col:'
      end
      object Label5: TLabel
        Left = 4
        Top = 36
        Width = 35
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Line:'
      end
      object Label3: TLabel
        Left = 4
        Top = 83
        Width = 90
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Node Type:'
      end
      object lblNodeType: TLabel
        Left = 104
        Top = 83
        Width = 104
        Height = 25
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'TSyntaxNode'
      end
      object Label1: TLabel
        Left = 4
        Top = 118
        Width = 77
        Height = 38
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Caption = 'Label1'
      end
    end
  end
end
