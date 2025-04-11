object Form32: TForm32
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Form32'
  ClientHeight = 664
  ClientWidth = 1241
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
    Width = 1241
    Height = 664
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Position = 504
    Percent = 41
    SplitterWidth = 6
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 10
    ExplicitTop = 10
    ExplicitWidth = 663
    ExplicitHeight = 627
    BarSize = (
      504
      0
      510
      664)
    UpperLeftControls = (
      RzDBGrid1)
    LowerRightControls = (
      RzSplitter2)
    object RzDBGrid1: TRzDBGrid
      Left = 0
      Top = 0
      Width = 504
      Height = 664
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
      ParentFont = False
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
          FieldName = 'ParseTime'
          Title.Alignment = taCenter
          Title.Caption = 'ms'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MemoryUsed'
          Title.Alignment = taCenter
          Title.Caption = 'kb'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Friendly'
          Title.Caption = 'Set'
          Width = 88
          Visible = True
        end>
    end
    object RzSplitter2: TRzSplitter
      Left = 0
      Top = 0
      Width = 731
      Height = 664
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Position = 339
      Percent = 47
      SplitterWidth = 6
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 4
      ExplicitWidth = 797
      BarSize = (
        339
        0
        345
        664)
      UpperLeftControls = (
        DBSynEdit1
        RzDBMemo2)
      LowerRightControls = (
        RzDBMemo3
        SynEdit1)
      object DBSynEdit1: TDBSynEdit
        Left = 0
        Top = 0
        Width = 339
        Height = 540
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
        SelectionMode = smLine
        ExplicitLeft = -150
        ExplicitTop = -75
        ExplicitWidth = 300
        ExplicitHeight = 225
      end
      object RzDBMemo2: TRzDBMemo
        Left = 0
        Top = 540
        Width = 339
        Height = 124
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        DataField = 'Comments'
        DataSource = DataSource1
        TabOrder = 1
      end
      object RzDBMemo3: TRzDBMemo
        Left = 0
        Top = 540
        Width = 386
        Height = 124
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alBottom
        DataField = 'Errors'
        DataSource = DataSource1
        TabOrder = 0
        ExplicitWidth = 452
      end
      object SynEdit1: TSynEdit
        Left = 0
        Top = 0
        Width = 386
        Height = 540
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Hack'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 1
        UseCodeFolding = False
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
        Lines.Strings = (
          'SynEdit1')
        ReadOnly = True
        RightEdge = 0
        SelectedColor.Alpha = 0.400000005960464500
        SelectionMode = smLine
        ExplicitLeft = 84
        ExplicitTop = 261
        ExplicitWidth = 300
        ExplicitHeight = 225
      end
    end
  end
  object MemParseData: TFDMemTable
    Active = True
    AfterScroll = MemParseDataAfterScroll
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
    Left = 672
    Top = 276
  end
  object SynPasSyn1: TSynPasSyn
    Left = 972
    Top = 264
  end
end
