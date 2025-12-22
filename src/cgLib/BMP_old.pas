unit BMP;
interface
uses
  Windows, SysUtils,  Graphics, GL, JPEG, GIFimage;   // OpenGL,Dialogs,
                                                                           
type TRGBA= Record R,G,B,A :Byte; end;
     TRGB = Record B,G,R :Byte; end;
function getTexture(TexFile: String;  var pTex :pointer;
                var w0,h0, w,h:integer; format:string): Cardinal;
function myLoadTexture( TexFile :string; var kw,kh:single; Transparent:bool):Cardinal; //载入纹理并设置透明色的Alpha值
procedure glGenTextures(n: integer; var textures: Cardinal); stdcall; external opengl32;

implementation
//uses Geometer;
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
procedure SetNewSize(w,h: Integer; var newW,newH: integer);
  const d:array[0..11]of integer=(2,4,8,16,32,64,128,256,512,1024,2048,4096);
  var i:integer;
begin
  i:=0;
  repeat inc(i); until(w>d[i-1])and(w<=d[i])or(i>11);
  newW:=d[i];
  i:=0;
  repeat inc(i); until(h>d[i-1])and(h<=d[i])or(i>11);
  newH:=d[i];
end;

function getTexture(TexFile: String;  var pTex :Pointer;
                var w0,h0, w,h:integer; format:string): Cardinal;
var
  BMP: TBitmap;
  JPG: TJpegImage;
  GIF: TGIFImage;
  BMInfo : TBitmapInfo;
  i,j,k: integer;
  MemDC : HDC;
  Tex: Pointer;
begin
  glGenTextures(1, Result);
  glBindTexture(GL_TEXTURE_2D, Result);

  BMP:=TBitMap.Create;
  if format='.BMP' then
    BMP.LoadFromFile(TexFile);
  if format='.JPG' then begin
    JPG:=TJpegImage.Create;
    JPG.LoadFromFile(TexFile);
    BMP.Assign(JPG);
    JPG.free;
    end;
  if format='.GIF' then begin
    GIF:=TGIFImage.Create;
    GIF.LoadFromFile(TexFile);
    BMP.Assign(GIF);
    GIF.free;
    end;
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
    setNewSize( w0, h0, w,h);
    GetMem( Tex, w * h *3);
    pTex:=Tex;
    try
      GetDIBits( MemDC, BMP.Handle, 0, h, Tex, BMInfo, DIB_RGB_COLORS);
    finally
      DeleteDC (MemDC);
      end;
  end; // with  BMinfo.bmiHeader
  BMP.Free;
end;
       //载入纹理并设置透明色的Alpha值
function myLoadTexture( TexFile :string; var kw,kh:single; Transparent:bool):Cardinal;
  var i,j,k0,k,l, w0,h0, w,h :integer;
      sn :string;
      pix0, pix1 :^TRGBA;
      pos :^TRGB;
      pRGB, pRGBA :pointer; //源纹理和目标纹理的指针
      test :TRGBA;
begin
  sn:= ExtractFileExt(TexFile);
  for i:= 1 to 4 do sn[i]:= upCase(sn[i]);
  if(sn<>'.BMP')and(sn<>'.JPG')and(sn<>'.GIF')
    or not FileExists(TexFile) then begin
    result:=0;
    exit;
    end;  
  result:= getTexture( TexFile, pRGB, w0,h0, w,h, sn );
  if result=0 then exit;
  kw:=w0/w;   kh:=h0/h;
  if not transparent then begin     //不透明纹理
    SwapRGB( pRGB, W*H);   //交换红色和蓝色颜色分量
    glTexImage2D(GL_TEXTURE_2D, 0, 3, W, H,
                                0, GL_RGB, GL_UNSIGNED_BYTE, pRGB);
    end
  else begin //透明纹理 为每个像素添加Alpha分量
    GetMem( pRGBA, W*H* 4);  //分配目标纹理的内存
    pix0:= pRGB; //读取图片左下角的颜色 注意：纹理的格式是RGB，而BMP图象格式是BGR。
    test.R:=pix0.b;   test.G:=pix0.G;   test.B:=pix0.r; //
    if w=w0 then l:=0 else l:=(w0-trunc(w/2)) mod 4; //当图片宽度不是2的整数幂时,每行之间用数目不等0区分
    for i:= 0 to h0-1 do
      for j:= 0 to w0-1 do begin
        k0:=i*w0+j; k:=i*w+j;
        pix0:= Pointer(Integer(pRGB) + k0*3+i*l); //源像素
        pix1:= Pointer(Integer(pRGBA)+ k*4); //目标像素
        pix1.R:=pix0.b;  pix1.G:=pix0.G;  pix1.B:=pix0.r;
        if(pix1.R=test.R)and(pix1.g=test.g)and(pix1.b=test.b)
          then Pix1.A:=0 else Pix1.A:=255;
        end;
    glTexImage2D(GL_TEXTURE_2D, 0, 4, W, H,
                                0, GL_RGBA, GL_UNSIGNED_BYTE, pRGBA);
    freemem(pRGBA);
    end;
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  freemem(pRGB);
end;

end.
