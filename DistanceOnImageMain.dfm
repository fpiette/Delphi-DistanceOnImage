object DistanceOnImageForm: TDistanceOnImageForm
  Left = 0
  Top = 0
  Caption = 'Distance On Image'
  ClientHeight = 442
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnResize = FormResize
  DesignSize = (
    621
    442)
  TextHeight = 15
  object DstImage: TImage
    Left = 4
    Top = 39
    Width = 613
    Height = 280
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnClick = DstImageClick
  end
  object Click1ValueLabel: TLabel
    Left = 260
    Top = 12
    Width = 60
    Height = 15
    Caption = 'Click1Value'
  end
  object Click2ValueLabel: TLabel
    Left = 397
    Top = 12
    Width = 60
    Height = 15
    Caption = 'Click2Value'
  end
  object Click1Label: TLabel
    Left = 220
    Top = 12
    Width = 35
    Height = 15
    Caption = 'Click1:'
  end
  object Click2Label: TLabel
    Left = 356
    Top = 12
    Width = 35
    Height = 15
    Caption = 'Click2:'
  end
  object DistLabel: TLabel
    Left = 500
    Top = 12
    Width = 48
    Height = 15
    Caption = 'Distance:'
  end
  object DistValueLabel: TLabel
    Left = 560
    Top = 12
    Width = 48
    Height = 15
    Caption = 'DistValue'
  end
  object LoadImage1Button: TButton
    Left = 24
    Top = 8
    Width = 90
    Height = 25
    Caption = 'Load Image 1'
    TabOrder = 0
    OnClick = LoadImage1ButtonClick
  end
  object LoadImage2Button: TButton
    Left = 120
    Top = 8
    Width = 90
    Height = 25
    Caption = 'Load Image 2'
    TabOrder = 1
    OnClick = LoadImage2ButtonClick
  end
  object DisplayMemo: TMemo
    Left = 4
    Top = 327
    Width = 613
    Height = 114
    Anchors = [akLeft, akRight, akBottom]
    Lines.Strings = (
      'DisplayMemo')
    TabOrder = 2
    ExplicitTop = 326
    ExplicitWidth = 609
  end
end
