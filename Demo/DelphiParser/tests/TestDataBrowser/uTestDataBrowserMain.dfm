object Form32: TForm32
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'Form32'
  ClientHeight = 664
  ClientWidth = 940
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 25
  object RzDBGrid1: TRzDBGrid
    Left = 10
    Top = 10
    Width = 387
    Height = 644
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -18
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'DataFileName'
        Width = 157
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ParseStatus'
        Width = 101
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Runtime'
        Title.Caption = 'ms'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MemoryUsed'
        Title.Caption = 'kb'
        Width = 50
        Visible = True
      end>
  end
  object RzDBMemo1: TRzDBMemo
    Left = 407
    Top = 10
    Width = 523
    Height = 435
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    DataField = 'AstXml'
    DataSource = DataSource1
    TabOrder = 1
  end
  object RzDBMemo2: TRzDBMemo
    Left = 407
    Top = 455
    Width = 523
    Height = 131
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    DataField = 'Comments'
    DataSource = DataSource1
    TabOrder = 2
  end
  object RzDBMemo3: TRzDBMemo
    Left = 407
    Top = 596
    Width = 523
    Height = 58
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    DataField = 'Errors'
    DataSource = DataSource1
    TabOrder = 3
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
        DataType = ftLargeint
      end
      item
        Name = 'MemoryUsed'
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
    Left = 204
    Top = 264
  end
  object DataSource1: TDataSource
    DataSet = MemParseData
    Left = 492
    Top = 372
  end
end
