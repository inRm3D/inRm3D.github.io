object frmDrag: TfrmDrag
  Left = 193
  Top = 184
  Width = 395
  Height = 224
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  Color = clWhite
  TransparentColorValue = clBlue
  Constraints.MinHeight = 90
  Constraints.MinWidth = 240
  UseDockManager = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object IMG: TImage
    Left = 108
    Top = 0
    Width = 279
    Height = 193
    Align = alClient
  end
  object pnlProp: TPanel
    Left = 0
    Top = 0
    Width = 108
    Height = 193
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      108
      193)
    object Label3: TLabel
      Left = 4
      Top = 96
      Width = 20
      Height = 13
      AutoSize = False
      Caption = 'W='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 59
      Top = 96
      Width = 17
      Height = 13
      AutoSize = False
      Caption = 'H='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object labFormat: TLabel
      Left = 4
      Top = 28
      Width = 24
      Height = 15
      Caption = #26684#24335
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object labColor: TLabel
      Left = 4
      Top = 49
      Width = 24
      Height = 15
      Caption = #33394#24425
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object butSave: TBitBtn
      Left = 36
      Top = 1
      Width = 34
      Height = 20
      Cursor = crHandPoint
      Hint = #20445#23384
      TabOrder = 0
      OnClick = butSaveClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8A8
        A8A8A8A8A8A8A8A8A8A8C0C0C0A8A8A8A8A8A8A8A8A8FFEEEEFFECECFFE9E9FF
        E6E6FFE9E9FFE9E9FFE9E9FFE9E9FFE9E9FFE9E9FFE9E9A8A8A8DA7967CB674D
        C55F42C05A3BFFF1F1BCBC80E1A472E88A66E86F5AE86F5AE86F5AE86F5AB33F
        1BFBA8A9FFE7E7A8A8A8D57662DDBCB5FFE9E9FFE9E9FFF3F39EE49CCDE08CF3
        B67CFB9A6EFB9A6EFB9A6EFB9A6EBC4C23F8B0B0FFE7E7A8A8A8DA7967E7CECF
        FFE9E9C55F42FFF5F584E5D39DF9ACC5E78FEEBF7FEEBF7FEEBF7FEEBF7FD87A
        4AD1735CFFE7E7A8A8A8DD7D6EEABFBFFFE9E9C55F42FFF5F584E5D39DF9ACC5
        E78FEEBF7FEEBF7FEEBF7FEEBF7FD87A4AD1735CFFE7E7A8A8A8E28275ECC2C2
        FFE9E9FFE9E9FFF7F775CCE781F7EC97FAB9BCED93BCED93BCED93BCED93E5C6
        82CD7C4EFFE7E7A8A8A8E7877BEDC1C2EFACACECA6A6FFF9F96BA3E771D5FB7D
        F4F491F9C591F9C591F9C591F9C5B2F197CFC083FFE7E7A8A8A8EB8A81EEC4C5
        F1B1B1EFABABFFFBFB6177E765A1FC6FCEFC7AEDF97AEDF97AEDF97AEDF98CF9
        D1A4E196FFEAEAA8A8A8EE8E88EFC8C8BEBBBDB5B5B8FFFCFC5959DA576AE85E
        8EE867B7E867B7E867B7E867B7E871D5E780D6BFFFECECA8A8A8F2928CF1CACB
        C2BFC2F5F5F5FFFEFEFFFCFCFFFAFAFFF8F8FFF6F6FFF6F6FFF6F6FFF6F6FFF4
        F4FFF1F1FFEFEFC0C0C0F69692F3CDCDC6C3C6F5F5F6F6F6F7F2F2F3EDEDEEE8
        E8E9E2E2E2DDDDDDDBDBDC959596DB8583BC5634A8A8A8C0C0C0F89794AC4F25
        C9C6C9F5F5F6F7F7F8F5F5F6F2F2F2EDEDEDE7E7E7E1E1E2DFDFE099999AAD49
        23C05A3BA8A8A8C0C0C0FB9B9AF4D1D2CCC9CCF6F6F7F8F8F9F8F8F9F6F6F7F3
        F3F3EDEDEEE9E9E9E6E6E69D9D9EE18F8EC55F42A8A8A8C0C0C0FD9D9DFD9796
        FA9491F7918DF38D87EF8982EB857BE78175E27C6EDD7767D9735FD46E58CE68
        50CA6449C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
      Margin = 8
    end
    object edtW: TEdit
      Left = 23
      Top = 93
      Width = 29
      Height = 18
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '234'
      OnKeyDown = edtWKeyDown
      OnKeyPress = edtLast1KeyPress
    end
    object edtH: TEdit
      Left = 75
      Top = 93
      Width = 29
      Height = 18
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '123'
      OnKeyDown = edtWKeyDown
      OnKeyPress = edtLast1KeyPress
    end
    object butPrint: TBitBtn
      Left = 71
      Top = 1
      Width = 34
      Height = 20
      Cursor = crHandPoint
      Hint = #25171#21360
      TabOrder = 3
      OnClick = butPrintClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5B007F5B007F5B007F5B007F5B007F
        5B007F5B007F5B007F5B007F5B007F5B00FFFFFFFFFFFFFFFFFFFFFFFF7F5B00
        E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A47F5B00D9A7
        7D7F5B00FFFFFFFFFFFF7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F
        5B007F5B007F5B007F5B007F5B007F5B00D9A77D7F5B00FFFFFF7F5B00E3C1A4
        E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4FFFF99FFFF99FFFF99E3C1A4E3C1A47F5B
        007F5B007F5B00FFFFFF7F5B00E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4D9
        A77DD9A77DD9A77DE3C1A4E3C1A47F5B00D9A77D7F5B00FFFFFF7F5B007F5B00
        7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B
        00E3C1A4D9A77D7F5B007F5B00E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3
        C1A4E3C1A4E3C1A4D9A77DE3C1A47F5B007F5B00E3C1A47F5B00FFFFFF7F5B00
        7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B00D9A77DE3C1
        A47F5B007F5B007F5B00FFFFFFFFFFFF7F5B00FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF7F5B00D9A77DE3C1A4D9A77D7F5B00FFFFFFFFFFFF
        FFFFFF7F5B00FFFFFF7F5B007F5B007F5B007F5B007F5B00FFFFFF7F5B007F5B
        007F5B007F5B00FFFFFFFFFFFFFFFFFFFFFFFF7F5B00FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5B00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF7F5B00FFFFFF7F5B007F5B007F5B007F5B007F5B00FFFFFF7F5B
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5B00FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5B00FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFF7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B
        007F5B00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Margin = 6
    end
    object butClip: TBitBtn
      Tag = 1
      Left = 1
      Top = 1
      Width = 34
      Height = 20
      Cursor = crHandPoint
      Hint = #22797#21046
      TabOrder = 4
      OnClick = butClipClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0D5D5D468513A60504060483070504070605070
        5040604830604830604830604830604830989AA0C0C0C0C0C0C0C0C0C0C0A8A0
        F0F0F0E0D8D0E0D0C0E0C8C0D0C0B0D0C0B0E0B8A0D0B0A0D0B0A0D0A890D0A0
        90604830C0C0C0C0C0C0C0C0C0C0A8A0FFF0F0F0F0F0F0E8E0E0C8B0D0C0B0D0
        C0B0E0D0D0F0D0C0E0D0C0E0C8B0D0A890604830C0C0C0C0C0C0C0C0C0C0A8A0
        FFF0F0F0F0F0F0F0F0E0D0C0D0C0B0D0C0B0D0C0B0F0D0C0F0D0C0E0C8B0D0A8
        90604830C0C0C0C0C0C0C0C0C0C0B0A0FFF8F0F0F0F0F0F0F0F0E8E0E0D0C0D0
        C0B0D0C0B0D0C0C0F0D8D0E0C8C0D0B0A0604830C0C0C0C0C0C0C0C0C0C0B0A0
        FFF8F0F0F0F0F0F0F0F0F0F0F0E8E0E0D0C0D0C0B0D0C0B0F0D8D0F0D8D0D0B8
        A0605040C0C0C0C0C0C0C0C0C0D0B0A0FFF8FFFFF8F0F0F0F0F0F0F0F0F0E0E0
        D8E0E0D0C0D0C0B0D0C0B0F0E0D0E0C8B0705840C0C0C0C0C0C0C0C0C0D0B8A0
        FFFFFFFFF8FFFFF8F0FFF8F0FFF0F0F0F0E0F0E0E0E0D0C0E0D0C0F0E8E0E0D0
        C0807060C0C0C0C0C0C0C0C0C0D0B8A0FFFFFFFFF8FFFFF8F0FFF8F0FFF0F0F0
        F0E0F0E0E0E0D0C0E0D0C0F0E8E0E0D0C0807060C0C0C0C0C0C0C0C0C0D0B8B0
        FFFFFFFFFFFFFFF8FFFFF8F0FFF8F0F0F0F0F0E0E0F0E8E0E0D0C0F0E8E0E0D0
        C0A09080C0C0C0C0C0C0C0C0C0D0C0B0FFFFFFFFFFFF80A0B060889060889060
        789060788070809090A0B0F0E8E0E0D8D0B09890C0C0C0C0C0C0C0C0C0D0C0B0
        FFFFFFFFFFFF80A8B090D8E090E8F080D8F060C8E05098B0708090F0E8E0E0D8
        D0A09890C0C0C0C0C0C0C0C0C0D1C2B3FFFFFFFFFFFFF0F8FF80A8B0A0A8A094
        857680C8D0507080F0F0F0F0E0E0F0E0E0807060C0C0C0C0C0C0C0C0C0E1E0DD
        D1C2B3D0C0B0D0C0B070A8B0A0E8F0A0E8F090D0E0406870C0A8A0C0A8A0C0A8
        90C5CBCCC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D5DBDA80B0C080
        A0B07090A0CBD0D1C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
      Margin = 8
    end
    object cmbFormat: TComboBox
      Left = 54
      Top = 24
      Width = 48
      Height = 21
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 3
      ParentFont = False
      TabOrder = 5
      Text = 'PNG'
      OnChange = cmbFormatChange
      Items.Strings = (
        'GIF'
        'BMP'
        'JPG'
        'PNG')
    end
    object cmbGIF: TComboBox
      Left = 1
      Top = 131
      Width = 48
      Height = 21
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Style = csDropDownList
      Anchors = [akTop, akRight]
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 2
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = ' 32'
      OnChange = cmbGIFChange
      Items.Strings = (
        '  8'
        ' 16'
        ' 32'
        ' 64'
        '128'
        '256')
    end
    object cheTrans: TCheckBox
      Left = 2
      Top = 72
      Width = 98
      Height = 15
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = #36879#26126
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 7
      OnClick = FormShow
    end
    object txtQualid: TEdit
      Left = 54
      Top = 47
      Width = 32
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '80'
      OnChange = txtQualidChange
    end
    object cmbBMP: TComboBox
      Left = 53
      Top = 131
      Width = 48
      Height = 21
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      Style = csDropDownList
      Anchors = [akTop, akRight]
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ItemIndex = 3
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Text = '24 bit'
      OnChange = cmbGIFChange
      Items.Strings = (
        ' 1 bit'
        ' 4 bit'
        ' 8 bit'
        '24 bit')
    end
  end
  object barQualid: TUpDown
    Left = 84
    Top = 47
    Width = 17
    Height = 21
    Min = 60
    Increment = 5
    Position = 80
    TabOrder = 1
    OnClick = barQualidClick
  end
  object SaveImg: TSaveDialog
    Options = [ofOverwritePrompt, ofCreatePrompt, ofNoNetworkButton, ofEnableSizing, ofForceShowHidden]
    OptionsEx = [ofExNoPlacesBar]
    Left = 117
    Top = 7
  end
  object PrintDialog1: TPrintDialog
    Left = 156
    Top = 8
  end
end
