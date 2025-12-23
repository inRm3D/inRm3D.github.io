unit Jpg2Bmp;

interface

uses
  Graphics, Types{$IFNDEF FPC}, JPEG{$ENDIF};

type
  TJPEG = class(TJPEGImage)
  public
    procedure DrawTo(c: TCanvas; Rect: TRect);
  end;

implementation

{ TJPEG }

procedure TJPEG.DrawTo(c: TCanvas; Rect: TRect);
begin

  { It really is that easy. Draw() is a protected method, so we need a public
    wrapper for it. }
  Draw(c, Rect);

end;

end.
