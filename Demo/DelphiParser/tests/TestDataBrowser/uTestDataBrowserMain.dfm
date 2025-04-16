object Form32: TForm32
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'AST Browser'
  ClientHeight = 743
  ClientWidth = 1415
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
    Width = 1415
    Height = 743
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Position = 490
    Percent = 35
    UpperLeft.Color = 15987699
    LowerRight.Color = 15987699
    SplitterWidth = 6
    Align = alClient
    Color = 15987699
    TabOrder = 0
    ExplicitWidth = 1241
    ExplicitHeight = 664
    BarSize = (
      490
      0
      496
      743)
    UpperLeftControls = (
      RzDBGrid1)
    LowerRightControls = (
      RzSplitter2)
    object RzDBGrid1: TRzDBGrid
      Left = 0
      Top = 0
      Width = 490
      Height = 743
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentFont = False
      PopupMenu = PopupMenu1
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -18
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = [fsBold]
      FrameVisible = True
      AltRowShading = True
      Columns = <
        item
          Expanded = False
          FieldName = 'Friendly'
          Title.Caption = 'Set'
          Width = 88
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DataFileName'
          Title.Caption = 'Filename'
          Width = 239
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'ParseStatus'
          Title.Caption = 'Status'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SourceLineCnt'
          Title.Alignment = taCenter
          Title.Caption = 'Source'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AstLineCouint'
          Title.Alignment = taCenter
          Title.Caption = 'AST'
          Width = 60
          Visible = True
        end>
    end
    object RzSplitter2: TRzSplitter
      Left = 0
      Top = 0
      Width = 919
      Height = 743
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Position = 431
      Percent = 47
      UsePercent = True
      RealTimeDrag = True
      UpperLeft.Color = 15987699
      LowerRight.Color = 15987699
      SplitterWidth = 6
      Align = alClient
      Color = 15987699
      TabOrder = 0
      ExplicitWidth = 731
      ExplicitHeight = 664
      BarSize = (
        431
        0
        437
        743)
      UpperLeftControls = (
        DBSynEdit1
        RzDBMemo2)
      LowerRightControls = (
        RzDBMemo3
        SynEdit1)
      object DBSynEdit1: TDBSynEdit
        Left = 0
        Top = 0
        Width = 431
        Height = 619
        Cursor = crIBeam
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        DataField = 'AstXml'
        DataSource = DataSource1
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Hack'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        OnClick = DBSynEdit1Click
        OnKeyPress = DBSynEdit1KeyPress
        BookMarkOptions.LeftMargin = 3
        BookMarkOptions.Xoffset = 18
        ExtraLineSpacing = 3
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -24
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Font.Quality = fqClearTypeNatural
        Gutter.ShowLineNumbers = True
        Gutter.Visible = False
        Gutter.Bands = <
          item
            Kind = gbkMarks
            Width = 13
          end
          item
            Kind = gbkLineNumbers
          end
          item
            Kind = gbkFold
          end
          item
            Kind = gbkTrackChanges
          end
          item
            Kind = gbkMargin
            Width = 3
          end>
        Highlighter = SynXMLSyn1
        ReadOnly = True
        RightEdge = 0
        SelectedColor.Alpha = 0.400000005960464500
        ExplicitLeft = -4
        ExplicitTop = -10
        ExplicitHeight = 830
      end
      object RzDBMemo2: TRzDBMemo
        Left = 0
        Top = 619
        Width = 431
        Height = 124
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        DataField = 'Comments'
        DataSource = DataSource1
        TabOrder = 1
        ExplicitTop = 540
        ExplicitWidth = 342
      end
      object RzDBMemo3: TRzDBMemo
        Left = 0
        Top = 619
        Width = 482
        Height = 124
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        DataField = 'Errors'
        DataSource = DataSource1
        TabOrder = 0
        ExplicitTop = 540
        ExplicitWidth = 383
      end
      object SynEdit1: TDBSynEdit
        Left = 0
        Top = 0
        Width = 482
        Height = 619
        Cursor = crIBeam
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        DataField = 'Source'
        DataSource = DataSource1
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Hack'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        BookMarkOptions.LeftMargin = 3
        BookMarkOptions.Xoffset = 18
        ExtraLineSpacing = 3
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -14
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Font.Quality = fqClearTypeNatural
        Gutter.ShowLineNumbers = True
        Gutter.Bands = <
          item
            Kind = gbkMarks
            Width = 13
          end
          item
            Kind = gbkLineNumbers
          end
          item
            Kind = gbkFold
          end
          item
            Kind = gbkTrackChanges
          end
          item
            Kind = gbkMargin
            Width = 3
          end>
        Highlighter = SynPasSyn1
        ReadOnly = True
        RightEdge = 0
        SelectedColor.Alpha = 0.400000005960464500
        ExplicitLeft = 4
        ExplicitTop = -10
        ExplicitWidth = 383
        ExplicitHeight = 540
      end
    end
  end
  object MemParseData: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'DataFileName'
        Attributes = [faRequired]
        DataType = ftWideString
        Size = 1024
      end
      item
        Name = 'ParseStatus'
        DataType = ftBoolean
      end
      item
        Name = 'Source'
        DataType = ftWideMemo
      end
      item
        Name = 'AstXml'
        DataType = ftWideMemo
      end
      item
        Name = 'Comments'
        DataType = ftWideMemo
      end
      item
        Name = 'Errors'
        DataType = ftWideMemo
      end
      item
        Name = 'ParseTime'
        Attributes = [faRequired]
        DataType = ftLargeint
      end
      item
        Name = 'MemoryUsed'
        DataType = ftLongWord
      end
      item
        Name = 'Path'
        DataType = ftWideString
        Size = 1024
      end
      item
        Name = 'Friendly'
        DataType = ftWideString
        Size = 1024
      end
      item
        Name = 'SourceLineCnt'
        DataType = ftLongWord
      end
      item
        Name = 'AstLineCouint'
        DataType = ftLongWord
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 228
    Top = 288
  end
  object DataSource1: TDataSource
    DataSet = MemParseData
    Left = 228
    Top = 408
  end
  object SynXMLSyn1: TSynXMLSyn
    WantBracesParsed = False
    Left = 696
    Top = 342
  end
  object SynPasSyn1: TSynPasSyn
    Left = 1164
    Top = 336
  end
  object PopupMenu1: TPopupMenu
    Left = 180
    Top = 132
    object PopupMenu11: TMenuItem
      Caption = 'save'
      OnClick = PopupMenu11Click
    end
  end
end
