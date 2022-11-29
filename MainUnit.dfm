object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'OpenGL particles'
  ClientHeight = 826
  ClientWidth = 1397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object HintLabel: TLabel
    Left = 576
    Top = 304
    Width = 79
    Height = 13
    Caption = 'Press Esc to exit'
  end
  object Button1: TButton
    Left = 544
    Top = 344
    Width = 153
    Height = 73
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
end
