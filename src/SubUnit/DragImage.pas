unit DragImage;
{$codepage utf8}

interface
uses
{$IFDEF MSWINDOWS}
  Windows, SysUtils, Classes, Controls, Forms, Messages,  ToolWin,
  ExtCtrls, ComCtrls, Dialogs, Gauges, StdCtrls, Clipbrd, Buttons,
  Graphics, JPEG, GIFimage, PNGimage, Printers;
{$ELSE}
  Classes, SysUtils, Forms, Dialogs;
{$ENDIF}
type
{$IFDEF MSWINDOWS}
  TfrmDrag = class(TForm)
    pnlProp: TPanel;
    SaveImg: TSaveDialog;
    butSave: TBitBtn;
    IMG: TImage;
    Label3: TLabel;
    edtW: TEdit;
    Label4: TLabel;
    edtH: TEdit;
    butPrint: TBitBtn;
    butClip: TBitBtn;
    cmbFormat: TComboBox;
    labFormat: TLabel;
    labColor: TLabel;
    cmbGIF: TComboBox;
    cheTrans: TCheckBox;
    barQualid: TUpDown;
    txtQualid: TEdit;
    cmbBMP: TComboBox;
    PrintDialog1: TPrintDialog;
    procedure setWindows(bHole:boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure butSaveClick(Sender: TObject);
    procedure edtWKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtLast1KeyPress(Sender: TObject; var Key: Char);
    procedure cmbGIFChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure setEnable( bb, Sport,View :boolean);
    procedure butClipClick(Sender: TObject);
    procedure txtQualidChange(Sender: TObject);
    procedure cmbFormatChange(Sender: TObject);
    procedure barQualidClick(Sender: TObject; Button: TUDBtnType);
    procedure butPrintClick(Sender: TObject);
  private
    ImgW,ImgH, ImgL,ImgT :integer;
    varQ :integer; //JPG格式的图像质量
    cc:integer; //GIF图像的透明色索引
    tempFile,tempDir,tempFormat :string;
    bGIF, bHole :boolean;
    ClipBoard :TClipBoard;
    procedure WMENTERSIZEMOVE(var Message: TMessage);  message WM_ENTERSIZEMOVE;
    procedure WMEXITSIZEMOVE( var Message: TMessage);  message WM_EXITSIZEMOVE;
  public
    procedure setLanguage(bb:integer);
    procedure CopyImg(bFresh, bAnimat :boolean);
    procedure Convert( out bmp:TBitmap; format:integer);
  end;
{$ELSE}
  TfrmDrag = class(TForm)
  public
    procedure setLanguage(bb:integer);
    procedure setWindows(bHole:boolean);
    procedure setEnable(bb,Sport,View:boolean);
    procedure CopyImg(bFresh, bAnimat:boolean);
  end;
{$ENDIF}
  PtsType = array [0..9, 0..1] of Integer; //
var
  frmDrag: TfrmDrag;
  temp:string;
  TitleH :integer; //窗口标题栏高度
implementation

{$IFDEF MSWINDOWS}
uses inRm3Dunit;
{$R *.dfm}

Procedure FileCopy( Const SourceFilename, TargetFilename: String );
  Var S, T: TFileStream;
Begin
  S := TFileStream.Create( SourceFilename, fmOpenRead );
  try T :=TFileStream.Create( TargetFilename, fmOpenWrite or fmCreate );
    try T.CopyFrom(S, S.Size ) ;
    finally T.Free;
    end;
  finally S.Free;
  end;
End;

procedure TfrmDrag.butSaveClick(Sender: TObject);
  var i:integer;  st:string;
begin
  SaveImg.DefaultExt := GraphicExtension(TGraphicClass(IMG.Picture.Graphic.ClassType));
  if cmbFormat.ItemIndex=3 then
    SaveImg.Filter :='PNG Image (*.png)|*.png'
  else
    SaveImg.Filter := GraphicFilter(TGraphicClass(IMG.Picture.Graphic.ClassType));
  if trim(SgfName)>'' then begin
    i:=pos( '.',SgfName);
    if(i>0)then SaveImg.FileName:=copy( SgfName,1,i-1);
    end;
  st:=''; If SaveImg.Execute then st:=SaveImg.FileName;
  if trim(st)>'' then FileCopy( tempFile, st);
end;

procedure TfrmDrag.butClipClick(Sender: TObject);
begin
  Clipboard.Assign(IMG.Picture);
end;

procedure TfrmDrag.Convert( out BMP:TBitmap; format:integer);
  var JPG :TJpegImage;    GIF	:TGIFImage;   PNG :TPNGObject;
      FileSize :integer;// f: file of integer;
      SearchRec: TSearchRec;
begin
  tempFile:= tempDir+'TempImage.'+tempFormat;
  case format of
    0:begin  //GIF
      GIFImageDefaultColorReductionBits := cmbGIF.ItemIndex+3;
      GIF:= TGIFImage.Create;
      GIF.DitherMode := dmFloydSteinberg;
      GIF.ColorReduction := rmQuantize;
      GIF.Assign(IMG.Picture); // Assign the GIF
      if not bAnimat then GIF.SaveToFile(tempFile);   // Save the GIF used get size
      IMG.Picture.Assign(GIF);
      GIF.Free;
      end;
    1:begin //BMP
      case cmbBMP.ItemIndex of
        0:bmp.PixelFormat:=pf1bit;    1:bmp.PixelFormat:=pf4bit;
        2:bmp.PixelFormat:=pf8bit;    3:bmp.PixelFormat:=pf24bit;
        end;
      IMG.picture.bitmap:=bmp;  //放到FORM的IMAGE上
      IMG.Picture.Bitmap.SaveToFile( tempFile);
      end;
    2:begin  //JPG
      JPG:= TJpegImage.create;
      JPG.Assign( bmp);
      JPG.CompressionQuality:=varQ;  //图象质量
      JPG.SaveToFile( tempFile); //保存jpg图象文件
      IMG.Picture.LoadFromFile(tempFile);
      JPG.free;
      end;
    3:begin  //PNG
      PNG:=TPNGObject.Create;
      PNG.Assign( BMP);
      PNG.SaveToFile( tempFile);
      IMG.Canvas.Draw(0, 0, PNG);
      PNG.free;
      end;
    end;
  if(not bAnimat)then begin
    FileSize:=-1;
    try
      if FindFirst(ExpandFileName(tempFile), faAnyFile, SearchRec) = 0 then
        FileSize := SearchRec.Size;
    finally
      SysUtils.FindClose(SearchRec);
    end;
    Caption:='Image File Size: '+ inttostr( FileSize)+ ' bit';
    end;
end;

procedure TfrmDrag.CopyImg(bFresh, bAnimat :boolean);
  var vas :TCanvas;   BMP :TBitmap;  DC :HDC; //桌面句柄
begin
  frmDrag.Color:=Obj[1].LinkName[0];
  IMG.Picture.Graphic := nil;
  if not bAnimat then begin
    setWindows(true); //窗口上挖个洞
    if bFresh then frmMain.Refresh; //刷新主窗口
    end;
  DC:= GetDC( 0);         //获得桌面句柄
  vas:= TCanvas.Create;   //创建画布
  vas.Handle:=DC;         //画布句柄
  BMP:= TBitmap.Create;
  BMP.Width := ImgW;
  BMP.Height:= ImgH;
  BMP.Canvas.CopyRect( Rect( 0,0, ImgW,ImgH), vas,
                       Rect( ImgL,ImgT, ImgL+ImgW,ImgT+ImgH)); //复制图像
  ReleaseDC( 0, DC);
  vas.Free;
  BMP.HandleType:= bmDIB;
  IMG.Transparent:= cheTrans.Checked;
  IMG.Picture.Assign(bmp);
  if bFresh then Convert( bmp, cmbFormat.ItemIndex )
            else IMG.picture.bitmap:=bmp;
  BMP.Free;
  if not bAnimat then setWindows(false);
end;

procedure TfrmDrag.setWindows(bHole:boolean); //bHole=true:在窗口里挖个方孔
var HRegion1: THandle;
    Pts: PtsType;  i :integer;
begin 
  Pts[0,0]:=0;      Pts[0,1]:=0;       Pts[1,0]:=width;  Pts[1,1]:=0;
  Pts[2,0]:=width;  Pts[2,1]:=titleH;
  Pts[8,0]:=width;  Pts[8,1]:=height;  Pts[9,0]:=0;      Pts[9,1]:=height;
  if bHole then begin
    Pts[3,0]:=pnlProp.Width+4;      Pts[3,1]:=titleH;
    Pts[4,0]:=pnlProp.Width+4;      Pts[4,1]:=height-4;
    Pts[5,0]:=width-4;  Pts[5,1]:=height-4;
    Pts[6,0]:=width-4;  Pts[6,1]:=titleH;
    Pts[7,0]:=width;    Pts[7,1]:=titleH;
    end
  else
    for i:= 3 to 7 do Pts[i]:=Pts[2];
  HRegion1 := CreatePolygonRgn (Pts,sizeof (Pts) div 8, alternate);
  SetWindowRgn (Handle, HRegion1, True);
  SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOPMOST); // WS_EX_TOOLWINDOW
end;
procedure TfrmDrag.setLanguage(bb:integer);
  function IIFs( a:integer; b,c,d :string) :string;   //返回string
    begin case a of 0:result:=b; 1:result:=c; 2:result:=d; end; end;
begin
    butClip.Hint:=IIFs(bb,'复制','複製','Copy');
    butSave.Hint:=IIFs(bb,'保存','保存','Save');
    butPrint.Hint:=IIFs(bb,'打印','打印','Print');
    cheTrans.caption:=IIFs(bb,'透明','透明','Transparent');
    labFormat.Caption:=IIFs(bb,'格式','格式','Format');
  if cmbFormat.ItemIndex=2
    then labColor.caption:=IIFs(bb,'质量','質量','Qualid')
    else labColor.caption:=IIFs(bb,'色彩','色彩','Color');
end;

procedure TfrmDrag.FormCreate(Sender: TObject);
begin
  cmbFormat.ItemIndex:=0;  // 默认GIF为首选格式
  tempFormat:=cmbFormat.Text;
  varQ:= StrToInt(txtQualid.text);
  tempDir:= ExtractFilePath( Application.ExeName);
  titleH:=Height-ClientHeight-4;  //窗口标题栏高度
  Left:= (screen.Width- IMG.Width ) div 2 -pnlProp.Width-4;
  Top := (screen.Height-frmDrag.Height)div 2;
  ImgW:= Width-pnlProp.Width-8;   edtW.Text:= inttostr(ImgW);
  ImgH:= Height-titleH-4;         edtH.Text:= inttostr(ImgH);
  ImgL:= Left+pnlProp.Width+4;    ImgT:= Top+titleH;
  bHole:=true;  bGIF:=false;
  cmbGIF.Left:=54; cmbGIF.Top:=47; cmbGIF.Visible:=true;
  cmbBMP.Left:=54; cmbBMP.Top:=47; cmbBMP.Visible:=false;
  txtQualid.Visible:=false;        barQualid.Visible:=false;
  ClipBoard:=TClipBoard.Create;
  tempFile:='';
  setLanguage(iLanguage);
end;

procedure TfrmDrag.FormShow(Sender: TObject);
begin
  CopyImg(true,false);
end;

procedure TfrmDrag.FormResize(Sender: TObject);
begin
  if bAnimat then exit;
  ImgW:= Width-pnlProp.Width-8;   edtW.Text:= inttostr(ImgW);
  ImgH:= Height-titleH-4;         edtH.Text:= inttostr(ImgH);
  ImgL:= Left+pnlProp.Width+4;    ImgT:= Top+titleH;
  setWindows(true);//
end;

procedure TfrmDrag.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key=27 then Close;
end;

procedure TfrmDrag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FileExists(tempFile) then
    DeleteFile(tempFile); //删除临时文件
  frmMain.Enabled:=true;
end;
//=========== 打印 =============
procedure TfrmDrag.WMEnterSizeMove(var Message: TMessage);
begin
  if bGIF then caption:='动画GIF格式' else caption:=' 选择图像...';
  setWindows(true);
end;

procedure TfrmDrag.WMExitSizeMove(var Message: TMessage);
begin
  ImgL:= Left+pnlProp.Width+4;   ImgT:= Top+titleH;
  if not bGIF then CopyImg(true,false);
end;
//========== JPG 图像的压缩质量 ==============
procedure TfrmDrag.txtQualidChange(Sender: TObject);
begin
  varQ:=StrToInt(txtQualid.Text);
  CopyImg(true,false);
end;
//================ 窗口尺寸 =================
procedure TfrmDrag.edtWKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  var w,h :integer;
begin
  if Key=13 then begin
    w:= strToInt(edtW.Text);  if w<40 then w:=40;
    if w>frmMain.Width-140 then w:=frmMain.Width-140;
    h:= strToInt(edtH.Text);  if h<26 then h:=26;
    if h>frmMain.Height then h:=frmMain.Height;
    ImgW:=w; edtW.Text:=IntToStr(w);
    ImgH:=h; edtH.Text:=IntToStr(h);
    width:=w+pnlProp.Width+8; height:=h+titleH+4;
    CopyImg(true,false);
    end;
end;

procedure TfrmDrag.setEnable( bb, Sport,View :boolean);
begin
  cheTrans.Enabled:=bb;
  cmbGIF.Enabled:=bb;
  butPrint.Enabled:=bb;
end;

procedure TfrmDrag.edtLast1KeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in [#48..#57,#8])then key:=#0;
end;

procedure TfrmDrag.cmbGIFChange(Sender: TObject);
begin
  if not bGIF then CopyImg(true,false);
end;

procedure TfrmDrag.FormDestroy(Sender: TObject);
begin
  ClipBoard.Free;
end;

procedure TfrmDrag.cmbFormatChange(Sender: TObject);
begin
  if FileExists(tempFile) then
    DeleteFile(tempFile); //删除临时文件
  tempFormat:='.'+cmbFormat.Text;
  txtQualid.Visible:=(cmbFormat.ItemIndex=2);
  barQualid.Visible:= txtQualid.Visible;
  cmbGIF.Visible:=(cmbFormat.ItemIndex=0);
  cmbBMP.Visible:=(cmbFormat.ItemIndex=1);
  cheTrans.Enabled:=(cmbFormat.ItemIndex=0);
  CopyImg(true,false);
end;

procedure TfrmDrag.barQualidClick(Sender: TObject; Button: TUDBtnType);
begin
  txtQualid.Text:= IntToStr(barQualid.Position);
  CopyImg(true,false);
end;

procedure TfrmDrag.butPrintClick(Sender: TObject);
var
  ScaleX, ScaleY: Integer;
  R: TRect;
begin
  if PrintDialog1.Execute then begin
  Printer.BeginDoc;  // **
  with Printer do
  try
    ScaleX := GetDeviceCaps(Handle, logPixelsX) div PixelsPerInch;
    ScaleY := GetDeviceCaps(Handle, logPixelsY) div PixelsPerInch;
    R := Rect(0, 0, IMG.Picture.Width * ScaleX, IMG.Picture.Height * ScaleY);
    Canvas.StretchDraw(R, IMG.Picture.Graphic);  // **
  finally
    EndDoc;  // **
  end;
    end;
end;

{$ELSE}

procedure TfrmDrag.setLanguage(bb:integer);
begin
end;

procedure TfrmDrag.setWindows(bHole:boolean);
begin
end;

procedure TfrmDrag.setEnable(bb,Sport,View:boolean);
begin
end;

procedure TfrmDrag.CopyImg(bFresh, bAnimat:boolean);
begin
  MessageDlg('Image capture is not available on this platform.', mtInformation, [mbOK], 0);
end;

{$ENDIF}

end.
