object fmain: Tfmain
  Left = 0
  Top = 0
  Caption = 'fmain'
  ClientHeight = 562
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SynMemo1: TSynMemo
    Left = 16
    Top = 47
    Width = 209
    Height = 98
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Lines.Strings = (
      'SynMemo1')
    FontSmoothing = fsmNone
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'teste'
    TabOrder = 1
    OnClick = Button1Click
  end
  object dxLayoutControl1: TdxLayoutControl
    Left = 392
    Top = 56
    Width = 441
    Height = 384
    TabOrder = 2
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutControl1Item1: TdxLayoutItem
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.Text = 'New Item'
      Index = 0
    end
  end
  object btnBuildLayout: TButton
    Left = 392
    Top = 25
    Width = 97
    Height = 25
    Caption = 'btnBuildLayout'
    TabOrder = 3
    OnClick = btnBuildLayoutClick
  end
  object Button2: TButton
    Left = 512
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Aurelius'
    TabOrder = 5
    OnClick = Button3Click
  end
  object FDPhysOracleDriverLink1: TFDPhysOracleDriverLink
    Left = 304
    Top = 344
  end
end
