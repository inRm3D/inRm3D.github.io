unit BMP;
interface
uses
  Windows, Classes, SysUtils,  Graphics, GL, JPEG, GIFimage, PNGImage, Math;   // OpenGL,Dialogs,

type TRGBA= Record R,G,B,A :Byte; end;
     TRGB = Record B,G,R :Byte; end;
type
  pRGBArray = ^TRGBArray;
  TRGBArray = array[0..32767] of TRGBTriple;
function GetBitmapFromFile(FileName, format:String):TBitmap;
function getTexture(texID:Cardinal; TexFile: String; BMP1:TBitmap; var pTex :pointer;
            var w0,h0, W,H :integer; format:string): Cardinal;
function myLoadTexture(ID:integer; texID:Cardinal; TexFile :string; BMP:TBitmap;
            var w0,h0:integer; var kW,kH:single; Trans:boolean):Cardinal; //载入纹理并设置透明色的Alpha值
procedure glGenTextures(n: integer; var textures: Cardinal); stdcall; external opengl32;

function ImgToTxt(ID:integer; ImgFile, sFormat :string): AnsiString; //图像转换为文本
function TxtToImg(ID:integer; texID:Cardinal; sData, sFormat :AnsiString;
            var w0,h0:integer; var kW,kH :single; Trans:Boolean): Cardinal;//文本转换为纹理

implementation
//uses inRm3Dunit;
procedure SwapRGB(data : Pointer; Size : Integer);
asm              {--------------------------------------}
  mov ebx, eax   {  Swap bitmap format from BGR to RGB  }
  mov ecx, size  {--------------------------------------}

@@loop :
  mov al,[ebx+0]
  mov ah,[ebx+2]
  mov [ebx+2],al
  mov [ebx+0],ah
  add ebx,3
  dec ecx
  jnz @@loop
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
  BMP: TBitmap;
  JPG: TJpegImage;
  GIF: TGIFImage;
  PNG: TPNGObject;
begin
  BMP:=TBitMap.Create; //BMP:=TBitMap.Create;
  if format='.BMP' then
    BMP.LoadFromFile(FileName);
  if format='.JPG' then begin
    JPG:=TJpegImage.Create;
    JPG.LoadFromFile(FileName);
    BMP.Assign(JPG);
    JPG.free;
    end;
  if format='.GIF' then begin
    GIF:=TGIFImage.Create;
    GIF.LoadFromFile(FileName);
    BMP.Assign(GIF);
    GIF.free;
    end;
  if format='.PNG' then begin
    PNG:=TPNGObject.Create;
    PNG.LoadFromFile(FileName);
    BMP.Assign(PNG);
    PNG.free;
    end;
  result:=BMP;
end;

function getTexture(texID:Cardinal; TexFile: String; BMP1:TBitmap;  var pTex :Pointer;
                var w0,h0, W,H:integer; format:string): Cardinal;
var
  BMP: TBitmap;
  BMInfo : TBitmapInfo;
  MemDC : HDC;
  Tex: Pointer;
begin
  if(texID=0)then glGenTextures(1, texID);
  result:=texID;
  glBindTexture(GL_TEXTURE_2D, Result);

  if TexFile>''then
    BMP:= GetBitmapFromFile(TexFile,format)
  else
    BMP:=BMP1;
  with BMinfo.bmiHeader do begin
    FillChar (BMInfo, SizeOf(BMInfo), 0);
    biSize := sizeof (TBitmapInfoHeader);
    biBitCount := 24;
    biWidth := BMP.Width;
    biHeight := BMP.Height;
    biPlanes := 1;
    biCompression := bi_RGB; //bi_RGB=0
    MemDC := CreateCompatibleDC( 0 );
    w0:=biWidth;   h0:=biHeight;
    setNewSize( w0,h0, W,H); //将图片尺寸圆整到2的整数幂
    GetMem( Tex, W * H *3);
    pTex:=Tex;
    try
      GetDIBits( MemDC, BMP.Handle, 0, H, Tex, BMInfo, DIB_RGB_COLORS);
    finally
      DeleteDC (MemDC);
      end;
  end; // with  BMinfo.bmiHeader
  if TexFile>''then BMP.Free;
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
      pix1:= Pointer(Integer(pRGBA)+ k*4); //目标像素
      if(i<h0)and(j<w0)then begin
        k0:=w0*i+j;
        pix0:= Pointer(Integer(pRGB) + k0*3+i*L); //源像素
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
  var vas :TCanvas; bmp :TBitmap;  w0,h0,w1,h1:integer;
begin
  vas:= TCanvas.Create;   //创建画布
  vas.Handle:=GetDC( 0);  //画布句柄等于桌面句柄

  bmp:= TBitmap.Create;
  bmp.Width:=W;  bmp.Height:= H;
  bmp.Canvas.CopyRect( Rect( 0,0, W,H), vas,  Rect( L,T, L+W, T+H));
  vas.Free;

  bmp.HandleType:= bmDIB;
  result:= myLoadTexture(ID,texID, '', bmp, w0,h0, kW,kH, trans); // BMP
  bmp.Free;
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
