unit TgaImage;

// Tga format support
// by Qingrui Li (the3i@sohu.com)

interface

uses Types, SysUtils, Classes, Graphics;

type
  TTgaImage = class(TBitmap)
  public
    procedure LoadFromStream(s: TStream); override;
    procedure SaveToStream(s: TStream); override;
  end;

implementation

type
  TTgaHeader = packed record   // Header type for TGA images
    IDLength     : Byte;
    ColorMapType : Byte;
    ImageType    : Byte;
    ColorMapSpec : Array[0..4] of Byte;
    OrigX  : Word;
    OrigY  : Word;
    Width  : Word;
    Height : Word;
    BPP    : Byte;
    ImageInfo : Byte;
  end;

{ TTgaImage }

procedure TTgaImage.LoadFromStream(s: TStream);
var
  header: TTgaHeader;
  W, H: Integer;
  ImageSize: integer;
begin
  s.ReadBuffer(Header, sizeof(Header));
  if (Header.ImageType = 2) { TGA_RGB } // Only support uncompressed images
      and (Header.ColorMapType = 0) // Don't support colormapped files
      and (Header.BPP >= 24) // 24bit or 32bit image
  then begin
    s.Seek(header.IDLength, soFromCurrent);
    // Get the width, height, and color depth
    if header.BPP = 24 then PixelFormat := pf24bit
    else PixelFormat := pf32bit;
    W := Header.Width;
    H := Header.Height;
    Width := W;
    Height := H;
    ImageSize := W * H * (header.BPP div 8);
    s.ReadBuffer(PByte(Scanline[H-1])^, imageSize);
  end
  else
    raise EInvalidGraphic.Create('only true color tga is supported');
end;

procedure TTgaImage.SaveToStream(s: TStream);
var
  header: TTgaHeader;
  ImageSize: integer;
begin
  FillChar(header, sizeof(header), 0);
  header.ImageType := 2;
  header.ImageInfo := $20; // bottom-up
  if PixelFormat = pf32bit then header.BPP := 32
  else begin
    PixelFormat := pf24bit;
    header.BPP := 24;
  end;
  header.Width := Width;
  header.Height := Height;
  ImageSize := Width * Height * (header.BPP div 8);
  s.WriteBuffer(header, sizeof(header));
  s.WriteBuffer(PByte(Scanline[height-1])^, ImageSize);
end;

initialization
  TPicture.RegisterFileFormat('tga', 'Targa Graphics', TTgaImage);
finalization
  TPicture.UnregisterGraphicClass(TTgaImage);
end.
