unit BMP;
{$codepage utf8}
interface
uses
  Classes, SysUtils, Graphics, Types, cgGL, cgMath;   // OpenGL,Dialogs,

type TRGBA= Record R,G,B,A :Byte; end;
     TRGB = Record B,G,R :Byte; end;
type
  pRGBArray = ^TRGBArray;
  TRGBArray = array[0..32767] of TRGB;
function GetBitmapFromFile(FileName, format:String):TBitmap;
function getTexture(texID:Cardinal; TexFile: String; BMP1:TBitmap; var pTex :pointer;
            var w0,h0, W,H :integer; format:string): Cardinal;
function myLoadTexture(ID:integer; texID:Cardinal; TexFile :string; BMP:TBitmap;
            var w0,h0:integer; var kW,kH:single; Trans:boolean):Cardinal; //载入纹理并设置透明色的Alpha值

function ImgToTxt(ID:integer; ImgFile, sFormat :string): AnsiString; //图像转换为文本
function TxtToImg(ID:integer; texID:Cardinal; sData, sFormat :AnsiString;
            var w0,h0:integer; var kW,kH :single; Trans:Boolean): Cardinal;//文本转换为纹理

implementation
//uses inRm3Dunit;
procedure SwapRGB(data : Pointer; Size : Integer);
var
  Pixels: ^TRGB;
  I: Integer;
  Temp: Byte;
begin
  Pixels := data;
  for I := 0 to Size - 1 do
  begin
    Temp := Pixels^.R;
    Pixels^.R := Pixels^.B;
    Pixels^.B := Temp;
    Inc(Pixels);
  end;
end;
//将图片尺寸圆整到2的整数幂
procedure SetNewSize(W,H :Integer; var newW,newH: integer);
  const d:array[0..12]of integer=(2,4,8,16,32,64,128,256,512,1024,2048,4096,8192);
  var i:integer;
begin
  i:=0;
  repeat inc(i); until(d[i-1]>W)or(i>11);
  newW:=d[i-1];
  i:=0;
  repeat inc(i); until(d[i-1]>H)or(i>11);
  newH:=d[i-1];
end;

function GetBitmapFromFile(FileName, format:String):TBitmap;
var
  Pic: TPicture;
begin
  Pic := TPicture.Create;
  try
    Pic.LoadFromFile(FileName);
    Result := TBitmap.Create;
    Result.Assign(Pic.Graphic);
  finally
    Pic.Free;
  end;
end;

function getTexture(texID:Cardinal; TexFile: String; BMP1:TBitmap;  var pTex :Pointer;
                var w0,h0, W,H:integer; format:string): Cardinal;
var
  SourceBmp, WorkingBmp: TBitmap;
  Tex: Pointer;
  y: Integer;
  SrcLine, DstLine: PByte;
begin
  if(texID=0)then glGenTextures(1, @texID);
  result:=texID;
  glBindTexture(GL_TEXTURE_2D, Result);

  if TexFile>''then
    SourceBmp:= GetBitmapFromFile(TexFile,format)
  else
    SourceBmp:=BMP1;
  SourceBmp.PixelFormat := pf24bit;
  w0:=SourceBmp.Width;
  h0:=SourceBmp.Height;
  setNewSize( w0,h0, W,H); //将图片尺寸圆整到2的整数幂
  WorkingBmp := SourceBmp;
  if (W <> w0) or (H <> h0) then
  begin
    WorkingBmp := TBitmap.Create;
    WorkingBmp.PixelFormat := pf24bit;
    WorkingBmp.SetSize(W, H);
    WorkingBmp.Canvas.Brush.Color := clBlack;
    WorkingBmp.Canvas.FillRect(Rect(0,0,W,H));
    WorkingBmp.Canvas.Draw(0, H - h0, SourceBmp);
  end;
  GetMem(Tex, W * H *3);
  pTex:=Tex;
  for y := 0 to H - 1 do
  begin
    DstLine := PByte(Tex) + y * W * 3;
    SrcLine := WorkingBmp.ScanLine[(WorkingBmp.Height - 1) - y];
    Move(SrcLine^, DstLine^, W * 3);
  end;
  if TexFile>''then SourceBmp.Free;
  if WorkingBmp <> SourceBmp then WorkingBmp.Free;
end;

procedure mySetAlpha(out RGB, RGBA:TBitmap; w0,h0,W,H:integer; Trans:boolean);
  var i,j,k0,k,L :integer;
begin

end;
       //载入纹理并设置透明色的Alpha值
function myLoadTexture(ID:integer; texID:Cardinal; TexFile :string; BMP:TBitmap;
              var w0,h0:integer; var kW,kH:single; Trans:boolean):Cardinal;
  var i,j,k0,k,L,W,H :integer; bTrans:byte;
      format :string;
      pix0, pix1 :^TRGBA;
      pRGB, pRGBA :pointer; //源纹理和目标纹理的指针
      test :TRGBA;
begin
  if(TexFile>'')and(BMP=nil)then begin
    format:= ExtractFileExt(TexFile);
    for i:= 2 to 4 do format[i]:= upCase(format[i]);
    if not((format='.BMP')or(format='.JPG')or(format='.GIF')or(format='.PNG'))
      or not FileExists(TexFile) then begin //
      result:=0;
      exit;
      end;
    end;
  glDeleteTextures(1,@texID); //释放纹理内存
  W:=0; H:=0;
  result:= getTexture(texID, TexFile, BMP, pRGB, w0,h0, W,H, format );
  if result=0 then exit;
  kW:=w0/W;   kH:=h0/H; //源图片与目标图片之长宽比

  if trans then bTrans:=0 else bTrans:=255; //透明纹理 为每个像素添加Alpha分量
  GetMem( pRGBA, W*H* 4);  //分配目标纹理的内存
  pix0:= pRGB; //读取图片左下角的颜色 注意：纹理的格式是RGB，而BMP图象格式是BGR。
  test.R:=pix0.B;   test.G:=pix0.G;   test.B:=pix0.R; //
  L:=0; if W>w0 then L:=(w0-trunc(W/2)) mod 4; //当图片宽度不是2的整数幂时,每行之间用数目不等的0区分
  for i:= 0 to H-1 do //
    for j:= 0 to W-1 do begin //
      k:=W*i+j;
      pix1:= Pointer(PtrUInt(pRGBA) + PtrUInt(k)*SizeOf(TRGBA)); //目标像素
      if(i<h0)and(j<w0)then begin
        k0:=w0*i+j;
        pix0:= Pointer(PtrUInt(pRGB) + PtrUInt(k0)*3 + PtrUInt(i)*L); //源像素
        pix1.R:=pix0.B;  pix1.G:=pix0.G;  pix1.B:=pix0.R;
        if(pix1.R=test.R)and(pix1.G=test.G)and(pix1.B=test.B)
          then Pix1.A:=bTrans else Pix1.A:=255;
        end
      else begin
        pix1.R:=255;  pix1.G:=255;  pix1.B:=255; Pix1.A:=0;
        end;
      end;
  glTexImage2D(GL_TEXTURE_2D, 0, 4, W, H,
                              0, GL_RGBA, GL_UNSIGNED_BYTE, pRGBA);
  FreeMem(pRGBA);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  FreeMem(pRGB);
end;
//========= 将屏幕图象转换为纹理 ===========
function getTextureFromCRT(ID:integer; texID:Cardinal; pTex:pointer; w,h,l,t:integer;
            var kW,kH:single; trans:boolean):Cardinal;
begin
  Result := 0;
end;
//============= 图像转换为文本 ==============
function ImgToTxt(ID:integer; ImgFile, sFormat :string): AnsiString;
  var
    FileStream     : TFileStream;
    StringStream   : TStringStream;
    i, iSize       : integer;
    sData, DataStr : AnsiString;
    st: string[2];
//    G :TextFile;
begin
  try
    FileStream := TFileStream.Create(ImgFile, fmOpenRead);
    iSize := FileStream.Size;

    StringStream := TStringStream.Create(EmptyStr);
    StringStream.CopyFrom(FileStream, iSize);
    sData := StringStream.DataString;
    iSize:=Length(sData);

    setLength( DataStr, iSize*2);//  DataStr:= EmptyStr;  //
    for i := 1 to iSize do begin
//    DataStr:= DataStr + IntToHex(Ord(FileData[i]), 2);
      st:=IntToHex(Ord(sData[i]), 2);
      DataStr[i*2-1] := st[1];
      DataStr[i*2  ] := st[2];
      end;
    Result :=DataStr;
{
    AssignFile( G, 'MyText.txt'); //获取文件句柄
    ReWrite( G);          //打开文本文件
      WriteLn( G, ExtractFileExt(ImgFile));//扩展名
      WriteLn( G, DataStr);
    closeFile( G); }
  finally
    FreeAndNil(FileStream);
    FreeAndNil(StringStream);
  end;
end;
//================= 文本转换为纹理 ====================
function TxtToImg(ID:integer; texID:Cardinal; sData, sFormat :AnsiString;
              var w0,h0:Integer; var kW,kH :single;
              Trans:Boolean): Cardinal;//文本转换为纹理
  var
    buf       : array of Byte;
    ByteFile  : file of byte;
    i, iSize  : Integer;
    DataStr   : AnsiString;
    tmpFileName: string;
    BMP       : TBitmap;
begin
  iSize := Length(sData) div 2;
  SetLength(buf, iSize);
  for i := 1 to iSize do
    buf[i - 1] := StrToInt('$' + copy(sData, (i - 1) * 2 + 1, 2));
  tmpFileName := ExtractFilePath(ParamStr(0))+'tmp'+sFormat;

  AssignFile(ByteFile, tmpFileName); //创建临时文件
  Rewrite(ByteFile);
  for i := 0 to iSize - 1 do Write(ByteFile, buf[i]);
  CloseFile(ByteFile);
// exit;
    BMP:= GetBitmapFromFile(tmpFileName,sFormat);
  result:= myLoadTexture(ID,texID, '', BMP, w0,h0, kW,kH, trans); // BMP
  BMP.Free;
  DeleteFile(tmpFileName); //删除临时文件
end;

end.
