unit CgTexture;

{ CgLib: Bitmap image and texture objects.}

interface

uses
  Classes, CgTypes, Graphics{$IFNDEF FPC}, JPEG{$ENDIF}, DArrays;

type
  TCGTextureOptions = (toHTile, toVTile, toMinLinear, toMagLinear);
  TCGTexOptionSet = set of TCGTextureOptions;
  TCGImageHeader = record
    Width: Integer;
    Height: Integer;                 // Dimensions.
    TexOptions: TCGTexOptionSet;     // Texture properties (used only by TCGTexture).
    Filler: array [0..118] of Byte;  // For future versions of the file format.
  end;

  TCGImage = class(TDArray)
  private
    FWidth, FHeight: Integer;
  protected
    procedure SetWidth(w: Integer); virtual;
    procedure SetHeight(h: Integer); virtual;  // Overrided in TCGTexture.
  public
    constructor Create; override;
    function GetPixel(x, y: Integer): TCGColorB;
    procedure SetPixel(x, y: Integer; color: TCGColorB);
    property Pixels[x,y: Integer]: TCGColorB read GetPixel write SetPixel; default;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    procedure LoadFromFile(filename: String);
    procedure LoadFromStream(s: TStream);
    procedure SaveToFile(filename: String);
    procedure SaveToStream(s: TStream);
    procedure LoadAlpha(bmp: TBitmap);
    procedure ConvertBitmap(bmp: TBitmap);
    procedure LoadJPEG(jpg: String);
    function PixelPtr(x, y: Integer): PCGColorB;
    procedure Clear;
  end;

  TCGTexture = class(TCGImage)
  private
    FHTile: Boolean;
    FVTile: Boolean;
    FMinLinear: Boolean;
    FMagLinear: Boolean;
    procedure SetHTileMode(tile: Boolean);
    procedure SetVTileMode(tile: Boolean);
    procedure SetMinFilter(linear: Boolean);
    procedure SetMagFilter(linear: Boolean);
  protected
    procedure SetWidth(w: Integer); override;
    procedure SetHeight(h: Integer); override;
  public
    constructor Create; override;
    procedure Enable;
    procedure Disable;
    procedure LoadFromFile(filename: String);
    procedure LoadFromStream(s: TStream);
    procedure SaveToFile(filename: String);
    procedure SaveToStream(s: TStream);
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property HTile: Boolean read FHTile write SetHTileMode;         { Tile horizontally? }
    property VTile: Boolean read FVTile write SetVTileMode;         { Tile vertically? }
    property MinLinear: Boolean read FMinLinear write SetMinFilter; { Linear filtering on }
    property MagLinear: Boolean read FMagLinear write SetMagFilter; {  min/magnification? }
  end;

  TCGTextureObject = class
  public
    Image: TCGTexture;
    TexObject: Cardinal;
    constructor Create;
    destructor Destroy; override;
    procedure Enable;
    procedure Disable;
    procedure Upload;
  end;

  TCGTexLibHeader = record
    Count: Integer;
    Filler: array [0..123] of Byte;
  end;
  TCGTextureLib = class(TDArray)
  public
    constructor Create; override;
    function GetTexture(i: Integer): TCGTexture;
    procedure SetTexture(i: Integer; t: TCGTexture);
    procedure LoadFromFile(filename: String);
    procedure SaveToFile(filename: String);
    procedure LoadFromStream(s: TStream);
    procedure SaveToStream(s: TStream);
    function CopyTexture(i: Integer): TCGTexture;
    property Textures[i: Integer]: TCGTexture read GetTexture write SetTexture; default;
  end;

  TJPEG = class(TJPEGImage)  // This class is a helper to load JPEGs as textures.
  public
    procedure DrawTo(c: TCanvas; Rect: TRect);
  end;

function cgIsPowerOf2(n: Integer): Boolean;

implementation

uses
  SysUtils, cgGL, CgUtils;

function cgIsPowerOf2(n: Integer): Boolean;
var
  i: Integer;
begin

  // Test if n is a power of 2.
  Result := FALSE;
  i := 0;
  while i <= (n div 2) do
  begin
    if cgIntPower(2, i) = n then
    begin
      Result := TRUE;
      Exit;
    end;
    INC(i);
  end;

end;

procedure TJPEG.DrawTo(c: TCanvas; Rect: TRect);
begin

  { It really is that easy. Draw() is a protected method, so we need a public
    wrapper for it. }
  Draw(c, Rect);

end;

{******************************************************************************}
{ TCGIMAGE IMPLEMENTATION                                                      }
{******************************************************************************}

constructor TCGImage.Create;
begin

  // Inherit Create from TDArray.
  inherited Create;
  FItemSize := SizeOf(TCGColorB);

end;

function TCGImage.GetPixel(x, y: Integer): TCGColorB;
begin

  // Get a pixel. The index is computed with y * Width + x.
  GetItem(y * Width + x, Result);

end;

procedure TCGImage.SetPixel(x, y: Integer; color: TCGColorB);
begin

  // Set a pixel.
  SetItem(y * Width + x, color);

end;

procedure TCGImage.SetWidth(w: Integer);
var
  i: Integer;
  src, dst: Pointer;
begin

  // Resize the array to accomodate width * height pixels.
  // THIS NEEDS WORK!!! Lines of data need to be moved to a new location.
  Count := FWidth * FHeight;
  for i := FHeight - 1 downto 0 do
  begin
    // Move each scanline to the appropriate location.
    src := PixelPtr(0, i);
    dst := Pointer(i * w * FItemSize);
    Move(src^, dst^, FWidth * FItemSize);
  end;
  FWidth := w;

end;

procedure TCGImage.SetHeight(h: Integer);
begin

  { Same as before, but set height.
    There's no need to move the original data here, because the newly allocated
    memory is appended at the end (="bottom") of the texture. }
  FHeight := h;
  Count := FWidth * FHeight;

end;

procedure TCGImage.LoadFromFile(filename: String);
var
  f: File;
  hdr: TCGImageHeader;
begin

  // Load an image from file.
  AssignFile(f, filename);
  try
    Reset(f, 1);
    BlockRead(f, hdr, SizeOf(hdr));
    Width := hdr.Width;
    Height := hdr.Height;
    // Read pixel data.
    BlockRead(f, Data^, Count * ItemSize);
  finally
    CloseFile(f);
  end;

end;

procedure TCGImage.LoadFromStream(s: TStream);
var
  hdr: TCGImageHeader;
begin

  // Load an image from a stream.
  s.Read(hdr, SizeOf(hdr));
  Width := hdr.Width;
  Height := hdr.Height;
  // Read pixel data.
  s.Read(Data^, Count * ItemSize);

end;

procedure TCGImage.SaveToFile(filename: String);
var
  f: File;
  hdr: TCGImageHeader;
begin

  // Save bitmap data to custom format for faster loading.
  AssignFile(f, filename);
  try
    Rewrite(f, 1);
    FillChar(hdr, SizeOf(hdr), 0);
    hdr.Width := FWidth;
    hdr.Height := FHeight;
    BlockWrite(f, hdr, SizeOf(hdr));
    // Now write pixel data.
    BlockWrite(f, Data^, Count * ItemSize);
  finally
    CloseFile(f);
  end;

end;

procedure TCGImage.SaveToStream(s: TStream);
var
  hdr: TCGImageHeader;
begin

  // Save bitmap data to stream.
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Width := FWidth;
  hdr.Height := FHeight;
  s.Write(hdr, SizeOf(hdr));
  // Now write pixel data.
  s.Write(Data^, Count * ItemSize);

end;

procedure TCGImage.LoadAlpha(bmp: TBitmap);
var
  x, y: Integer;
  c: TCGColorB;
begin

  { Load alpha values from a TBitmap. If the original image also came from a
    .BMP file, it didn't have an alpha channel yet. }
  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      c := cgTColorToCGColorB(bmp.Canvas.Pixels[x,FHeight - 1 - y], 0);
      PixelPtr(x,y)^.A := (c.R + c.G + c.B) div 3;
    end;
  end;

end;

procedure TCGImage.ConvertBitmap(bmp: TBitmap);
var
  x, y: Integer;
begin

  // Resize the array to match the bitmap.
  SetWidth(bmp.Width);
  SetHeight(bmp.Height);
  // Loop and convert pixels.
  for y := 0 to FHeight - 1 do
  begin
    for x := 0 to FWidth - 1 do
    begin
      SetPixel(x, FHeight - 1 - y, cgTColorToCGColorB(bmp.Canvas.Pixels[x,y], 255));
    end;
  end;

end;

procedure TCGImage.LoadJPEG(jpg: String);
var
  jpeg: TJPEG;
  bmp: TBitmap;
begin

  // Load an image from a JPEG file.
  jpeg := TJPEG.Create;
  jpeg.LoadFromFile(jpg);
  bmp := TBitmap.Create;
  bmp.Width := jpeg.Width;
  bmp.Height := jpeg.Height;
  jpeg.DrawTo(bmp.Canvas, Rect(0, 0, bmp.Width, bmp.Height));
  ConvertBitmap(bmp);
  bmp.Free;
  jpeg.Free;

end;

function TCGImage.PixelPtr(x, y: Integer): PCGColorB;
begin

  // Return a pointer to a given pixel.
  Result := Pointer(Integer(Data) + ((y * FWidth) + x) * ItemSize);

end;

procedure TCGImage.Clear;
begin

  // Clear the whole image to black.
  ZeroMemory(Data, FWidth * FHeight * FItemSize);

end;

{******************************************************************************}
{ TCGTEXTURE IMPLEMENTATION                                                    }
{******************************************************************************}

constructor TCGTexture.Create;
begin

  inherited Create;
  // Set default properties: }
  HTile := TRUE;
  VTile := TRUE;          // Tiling is on.
  MinLinear := FALSE;
  MagLinear := FALSE;     // Linear interpolation is off.
  // Assume texture mapping function is GL_MODULATE.
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

end;

procedure TCGTexture.SetWidth(w: Integer);
begin

  { Resize the texture to the next power of two. The image will be severely distorted
    by this... }
  if cgIsPowerOf2(w) then inherited SetWidth(w)
  else begin
    repeat
      INC(w);
    until cgIsPowerOf2(w);
    inherited SetWidth(w);
  end;

end;

procedure TCGTexture.SetHeight(h: Integer);
begin

  if cgIsPowerOf2(h) then inherited SetHeight(h)
  else begin
    repeat
      INC(h);
    until cgIsPowerOf2(h);
    inherited SetHeight(h);
  end;

end;

procedure TCGTexture.SetHTileMode(tile: Boolean);
begin

  // Toggle horizontal tiling on/off.
  if tile then glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
  else glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
  FHTile := tile;

end;

procedure TCGTexture.SetVTileMode(tile: Boolean);
begin

  // Toggle vertical tiling on/off.
  if tile then glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
  else glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
  FVTile := tile;

end;

procedure TCGTexture.SetMinFilter(linear: Boolean);
begin

  // Toggle between nearest neighbour and linear interpolation for texture minification.
  if linear then glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  else glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  FMinLinear := linear;

end;

procedure TCGTexture.SetMagFilter(linear: Boolean);
begin

  // Toggle between nearest neighbour and linear interpolation for texture magnification.
  if linear then glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  else glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  FMagLinear := linear;

end;

procedure TCGTexture.Enable;
begin

  // Enable texture mapping with this image.
  // Apply the texture parameters for THIS texture, not the previous one.
  SetHTileMode(FHTile);
  SetVTileMode(FVTile);
  SetMinFilter(FMinLinear);
  SetMagFilter(FMagLinear);
  // Feed the bitmap data into OpenGL.
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, Width, Height, 0, GL_RGBA,
               GL_UNSIGNED_BYTE, Data);
  glEnable(GL_TEXTURE_2D);

end;

procedure TCGTexture.Disable;
begin

  // Disable texture mapping.
  glDisable(GL_TEXTURE_2D);

end;

procedure TCGTexture.LoadFromFile(filename: String);
var
  f: File;
  hdr: TCGImageHeader;
  i: Integer;
begin

  // Load a texture from file.
  AssignFile(f, filename);
  try
    Reset(f, 1);
    BlockRead(f, hdr, SizeOf(hdr));
    Width := hdr.Width;
    Height := hdr.Height;
    HTile := toHTile in hdr.TexOptions;
    VTile := toVTile in hdr.TexOptions;
    MinLinear := toMinLinear in hdr.TexOptions;
    MagLinear := toMagLinear in hdr.TexOptions;
    // Clear the image before (re)loading it.
    FillChar(Data^, Width * Height, 0);
    // Read pixel data row by row to avoid reading beyond EoF.
    // At this point, hdr's Width and Height might not match the texture's properties!
    for i := 0 to hdr.Height - 1 do BlockRead(f, PixelPtr(0,i)^, hdr.Width * ItemSize);
  finally
    CloseFile(f);
  end;

end;

procedure TCGTexture.LoadFromStream(s: TStream);
var
  hdr: TCGImageHeader;
  i: Integer;
begin

  // Load a texture from a stream.
  s.Read(hdr, SizeOf(hdr));
  Width := hdr.Width;
  Height := hdr.Height;
  HTile := toHTile in hdr.TexOptions;
  VTile := toVTile in hdr.TexOptions;
  MinLinear := toMinLinear in hdr.TexOptions;
  MagLinear := toMagLinear in hdr.TexOptions;
  // Clear the image before (re)loading it.
  FillChar(Data^, Width * Height, 0);
  // Read pixel data row by row to avoid reading beyond EoF.
  for i := 0 to hdr.Height - 1 do s.Read(PixelPtr(0,i)^, hdr.Width * ItemSize);

end;

procedure TCGTexture.SaveToFile(filename: String);
var
  f: File;
  hdr: TCGImageHeader;
begin

  // Save texture data to custom format for faster loading.
  AssignFile(f, filename);
  try
    Rewrite(f, 1);
    FillChar(hdr, SizeOf(hdr), 0);
    hdr.Width := FWidth;
    hdr.Height := FHeight;
    hdr.TexOptions := [];
    if HTile then hdr.TexOptions := hdr.TexOptions + [toHTile];
    if VTile then hdr.TexOptions := hdr.TexOptions + [toVTile];
    if MinLinear then hdr.TexOptions := hdr.TexOptions + [toMinLinear];
    if MagLinear then hdr.TexOptions := hdr.TexOptions + [toMagLinear];
    BlockWrite(f, hdr, SizeOf(hdr));
    // Now write pixel data.
    BlockWrite(f, Data^, Count * ItemSize);
  finally
    CloseFile(f);
  end;

end;

procedure TCGTexture.SaveToStream(s: TStream);
var
  hdr: TCGImageHeader;
begin

  // Save texture data to stream.
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Width := FWidth;
  hdr.Height := FHeight;
  hdr.TexOptions := [];
  if HTile then hdr.TexOptions := hdr.TexOptions + [toHTile];
  if VTile then hdr.TexOptions := hdr.TexOptions + [toVTile];
  if MinLinear then hdr.TexOptions := hdr.TexOptions + [toMinLinear];
  if MagLinear then hdr.TexOptions := hdr.TexOptions + [toMagLinear];
  s.Write(hdr, SizeOf(hdr));
  // Now write pixel data.
  s.Write(Data^, Count * ItemSize);

end;

{******************************************************************************}
{ TCGTEXTURELIB IMPLEMENTATION                                                }
{******************************************************************************}

constructor TCGTextureLib.Create;
begin

  inherited Create;
  FItemSize := SizeOf(TCGTexture);

end;

function TCGTextureLib.GetTexture(i: Integer): TCGTexture;
begin

  GetItem(i, Result);

end;

procedure TCGTextureLib.SetTexture(i: Integer; t: TCGTexture);
begin

  SetItem(i, t);

end;

procedure TCGTextureLib.LoadFromFile(filename: String);
var
  s: TFileStream;
  hdr: TCGTexLibHeader;
  i: Integer;
begin

  // Load textures from a library using a stream.
  s := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
  s.Read(hdr, SizeOf(hdr));
  Count := hdr.Count;
  for i := 0 to Count - 1 do
  begin
    Textures[i] := TCGTexture.Create;
    Textures[i].LoadFromStream(s);
  end;
  s.Free;

end;

procedure TCGTextureLib.SaveToFile(filename: String);
var
  s: TFileStream;
  hdr: TCGTexLibHeader;
  i: Integer;
begin

  // Save textures to a library using a stream.
  s := TFileStream.Create(filename, fmCreate or fmShareDenyWrite);
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Count := Count;
  s.Write(hdr, SizeOf(hdr));
  for i := 0 to Count - 1 do Textures[i].SaveToStream(s);
  s.Free;

end;

procedure TCGTextureLib.LoadFromStream(s: TStream);
var
  hdr: TCGTexLibHeader;
  i: Integer;
begin

  // Load textures from a stream.
  s.Read(hdr, SizeOf(hdr));
  Count := hdr.Count;
  for i := 0 to Count - 1 do
  begin
    Textures[i] := TCGTexture.Create;
    Textures[i].LoadFromStream(s);
  end;

end;

procedure TCGTextureLib.SaveToStream(s: TStream);
var
  hdr: TCGTexLibHeader;
  i: Integer;
begin

  // Save textures to a library using a stream.
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Count := Count;
  s.Write(hdr, SizeOf(hdr));
  for i := 0 to Count - 1 do Textures[i].SaveToStream(s);

end;

function TCGTextureLib.CopyTexture(i: Integer): TCGTexture;
begin

  { Return a copy of one of the textures. }
  Result := TCGTexture.Create;
  with Result do
  begin
    HTile := Textures[i].HTile;
    VTile := Textures[i].VTile;
    MinLinear := Textures[i].MinLinear;
    MagLinear := Textures[i].MagLinear;
    Count := Textures[i].Count;
    FWidth := Textures[i].Width;
    FHeight := Textures[i].Height;
    Move(Textures[i].Data^, Data^, Count * FItemSize);
  end;

end;

{ TCGTextureObject }

constructor TCGTextureObject.Create;
begin

  inherited Create;
  glGenTextures(1, @TexObject);
  glBindTexture(GL_TEXTURE_2D, TexObject);
  Image := TCGTexture.Create;

end;

destructor TCGTextureObject.Destroy;
begin

  glDeleteTextures(1, @TexObject);
  inherited Destroy;

end;

procedure TCGTextureObject.Disable;
begin

  glBindTexture(GL_TEXTURE_2D, 0);

end;

procedure TCGTextureObject.Enable;
begin

  glBindTexture(GL_TEXTURE_2D, TexObject);

end;

procedure TCGTextureObject.Upload;
begin

  Image.HTile := TRUE;
  Image.VTile := TRUE;
  Image.Enable;
  Disable;

end;

end.
