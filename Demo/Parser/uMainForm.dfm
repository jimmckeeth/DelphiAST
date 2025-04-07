object MainForm: TMainForm
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'DelphiAST Parser Demo'
  ClientHeight = 654
  ClientWidth = 999
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  PixelsPerInch = 144
  TextHeight = 21
  object Splitter1: TSplitter
    Left = 0
    Top = 437
    Width = 999
    Height = 4
    Cursor = crVSplit
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    MinSize = 45
  end
  object OutputMemo: TMemo
    Left = 0
    Top = 62
    Width = 999
    Height = 375
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 626
    Width = 999
    Height = 28
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Panels = <
      item
        Width = 75
      end>
  end
  object CheckBox1: TCheckBox
    AlignWithMargins = True
    Left = 5
    Top = 596
    Width = 989
    Height = 25
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    Caption = 
      'Use string interning for less memory consumption (has a minor im' +
      'pact on speed)'
    TabOrder = 2
  end
  object CommentsBox: TListBox
    Left = 0
    Top = 503
    Width = 999
    Height = 88
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    ItemHeight = 21
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 999
    Height = 62
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object Label1: TLabel
      Left = 24
      Top = 21
      Width = 94
      Height = 21
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Syntax Tree:'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 441
    Width = 999
    Height = 62
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object Label2: TLabel
      Left = 24
      Top = 21
      Width = 135
      Height = 21
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'List of Comments:'
    end
  end
  object MainMenu: TMainMenu
    Left = 224
    Top = 96
    object OpenDelphiUnit1: TMenuItem
      Caption = 'Open Delphi Unit...'
      OnClick = OpenDelphiUnit1Click
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Delphi Unit|*.pas|Delphi Package|*.dpk|Delphi Project|*.dpr'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 344
    Top = 96
  end
end
