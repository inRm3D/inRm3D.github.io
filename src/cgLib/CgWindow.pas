unit CgWindow;

{ CgLib: Window management. }

interface

uses
  Forms, Classes, Windows, cgGL;

type
  TCGForm = class(TForm)
  private
    FDC: HDC;
    FRC: HGLRC;
    FPalette: HPALETTE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitGL(iHandle:THandle);
    procedure MakeCurrent;
    procedure PageFlip;
    procedure CleanUpGL;
    procedure RedoPalette;
    property DC: HDC read FDC;
    property RC: HGLRC read FRC;
    property Palette: HPALETTE read FPalette;
  end;

  TCGDeviceContext = class(TObject)
  private
    FDC: HDC;
    FRC: HGLRC;
    FPalette: HPALETTE;
  public
    constructor Create(DC: HDC);
    destructor Destroy; override;
    procedure InitGL;
    procedure MakeCurrent;
    procedure PageFlip;
    procedure CleanUpGL;
    procedure RedoPalette;
    property DC: HDC read FDC;
    property RC: HGLRC read FRC;
    property Palette: HPALETTE read FPalette;
  end;

procedure cgBufferConfig(dbuffer, index: Boolean);
procedure cgChangeRes(rw, rh, rbpp: Cardinal);

implementation

var
  DoubleBuffer: Boolean = TRUE;
  ColorIndex: Boolean = FALSE;

procedure cgBufferConfig(dbuffer, index: Boolean);
begin

  // Override the display mode flags. Call InitGL _after_ this!
  DoubleBuffer := dbuffer;
  ColorIndex := index;

end;

function ChangeDisplaySettings(lpDevMode: PDeviceModeA; dwFlags: DWORD): Longint; stdcall;
         external user32 name 'ChangeDisplaySettingsA';

procedure cgChangeRes(rw, rh, rbpp: Cardinal);
var
  devMode: TDeviceMode;
  modeExists: LongBool;
  modeSwitch, closeMode, i: Integer;
begin

  // Change the display resolution to rw x rh and rbpp bits.
  // Use cgChangeRes(0, 0, 0) to restore the normal resolution.
  closeMode := 0;
  i := 0;
  repeat
    modeExists := EnumDisplaySettings(nil, i, devMode);
    // if not modeExists then: This mode may not be supported. We'll try anyway, though.
    with devMode do
    begin
      if (dmBitsPerPel = rbpp) and (dmPelsWidth = rw) and (dmPelsHeight = rh) then
      begin
        modeSwitch := ChangeDisplaySettings(@devMode, CDS_FULLSCREEN);
        if modeSwitch = DISP_CHANGE_SUCCESSFUL then Exit;
      end;
    end;
    if closeMode <> 0 then closeMode := i;
    INC(i);
  until not modeExists;

  EnumDisplaySettings(nil, closeMode, devMode);
  with devMode do
  begin
    dmBitsPerPel := rbpp;
    dmPelsWidth := rw;
    dmPelsHeight := rh;
    dmFields := DM_BITSPERPEL or DM_PELSWIDTH or DM_PELSHEIGHT;
  end;
  modeSwitch := ChangeDisplaySettings(@devMode, CDS_FULLSCREEN);
  if modeSwitch = DISP_CHANGE_SUCCESSFUL then Exit;

  devMode.dmFields := DM_BITSPERPEL;
  modeSwitch := ChangeDisplaySettings(@devMode, CDS_FULLSCREEN);
  if modeSwitch = DISP_CHANGE_SUCCESSFUL then
  begin
    devMode.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
    modeSwitch := ChangeDisplaySettings(@devMode, CDS_FULLSCREEN);
    if modeSwitch = DISP_CHANGE_SUCCESSFUL then
    begin
      ChangeDisplaySettings(nil, 0);
      Exit;
    end;
  end;

end;

procedure cgInitDC(DC: HDC; Palette: HPalette);
var
  hHeap: Integer;
  nColors, i: Integer;
  lpPalette: PLogPalette;
  byRedMask, byGreenMask, byBlueMask: Byte;
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin

  // Initialise the form's DC for OpenGL, and setup a palette.
  FillChar(pfd, SizeOf(pfd), 0);
  with pfd do
  begin
    nSize        := SizeOf(TPixelFormatDescriptor);           // Size of this structure
    nVersion     := 1;                                        // Version number
    dwFlags      := PFD_DRAW_TO_WINDOW or                     //指定像素格式的属性为可以绘制在屏幕上
                    PFD_SUPPORT_OPENGL OR                       //支持OpenGL函数
                    PFD_DOUBLEBUFFER;                          // Flags
    if DoubleBuffer then
      dwFlags := dwFlags or PFD_DOUBLEBUFFER;                 // Double buffering?
    if ColorIndex then iPixelType := PFD_TYPE_COLORINDEX      // Color index pixel values
    else iPixelType := PFD_TYPE_RGBA;                         // RGBA pixel values
    cColorBits   := 24;                                       // 24-bit color
    cDepthBits   := 24;                                       // 24-bit depth buffer
    cStencilBits := 8;                                        // Stencil buffer, too.
    iLayerType   := PFD_MAIN_PLANE;                           // Layer type
  end;

  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  SetPixelFormat(DC, nPixelFormat, @pfd);

  DescribePixelFormat(DC, nPixelFormat, SizeOf(TPixelFormatDescriptor), pfd);

  if ((pfd.dwFlags and PFD_NEED_PALETTE) <> 0) then
  begin
    nColors   := 1 shl pfd.cColorBits;
    hHeap     := GetProcessHeap;
    lpPalette := HeapAlloc(hHeap, 0, sizeof(TLogPalette) + (nColors * sizeof(TPaletteEntry)));

    lpPalette^.palVersion := $300;
    lpPalette^.palNumEntries := nColors;

    byRedMask   := (1 shl pfd.cRedBits) - 1;
    byGreenMask := (1 shl pfd.cGreenBits) - 1;
    byBlueMask  := (1 shl pfd.cBlueBits) - 1;

    for i := 0 to nColors - 1 do
    begin
      lpPalette^.palPalEntry[i].peRed   := (((i shr pfd.cRedShift)   and byRedMask)   * 255) DIV byRedMask;
      lpPalette^.palPalEntry[i].peGreen := (((i shr pfd.cGreenShift) and byGreenMask) * 255) DIV byGreenMask;
      lpPalette^.palPalEntry[i].peBlue  := (((i shr pfd.cBlueShift)  and byBlueMask)  * 255) DIV byBlueMask;
      lpPalette^.palPalEntry[i].peFlags := 0;
    end;

    Palette := CreatePalette(lpPalette^);
    HeapFree(hHeap, 0, lpPalette);

    if Palette <> 0 then
    begin
      SelectPalette(DC, Palette, FALSE);
      RealizePalette(DC);
    end;
  end;
  // Restore default flags for the next window or DC.
  DoubleBuffer := TRUE;
  ColorIndex := FALSE;

end;

{******************************************************************************}
{ TCGFORM                                                                      }
{******************************************************************************}

constructor TCGForm.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

end;

procedure TCGForm.InitGL(iHandle:THandle);
begin

  // Initialise OpenGL. Get a DC and create an RC.
  FDC := GetDC(iHandle);
  cgInitDC(FDC, FPalette);
  FRC := wglCreateContext(FDC);
  MakeCurrent;

end;

procedure TCGForm.MakeCurrent;
begin

  // Make this form the active OpenGL rendering context.
  if (FDC <> 0) and (FRC <> 0) then wglMakeCurrent(FDC, FRC);

end;

procedure TCGForm.PageFlip;
begin

  // Do a page flip.
  SwapBuffers(FDC);

end;

procedure TCGForm.CleanUpGL;
begin

  // Clean up OpenGL resources. Called automatically by form destructor.
  if FRC <> 0 then
  begin
    wglMakeCurrent(0, 0);
    wglDeleteContext(FRC);
  end;
  if FPalette <> 0 then DeleteObject(FPalette);
  ReleaseDC(Handle, FDC);

end;

destructor TCGForm.Destroy;
begin

  // Automagically clean up.
  CleanUpGL;
  inherited Destroy;

end;

procedure TCGForm.RedoPalette;
begin

  { Re-realize the form's palette, in case something bad happens with it (like
    a system palette change. }
  UnrealizeObject(FPalette);
  SelectPalette(FDC, FPalette, FALSE);
  RealizePalette(FDC);

end;

{******************************************************************************}
{ TCGDEVICECONTEXT                                                             }
{******************************************************************************}

constructor TCGDeviceContext.Create(DC: HDC);
begin

  // Assign a DC to this object. You need to call InitGL after this.
  inherited Create;
  FDC := DC;

end;

procedure TCGDeviceContext.InitGL;
begin

  // Initialize the DC for OpenGL.
  cgInitDC(FDC, FPalette);
  FRC := wglCreateContext(FDC);
  MakeCurrent;

end;

procedure TCGDeviceContext.MakeCurrent;
begin

  // Make DC the current OpenGL rendering context.
  if (FDC <> 0) and (FRC <> 0) then wglMakeCurrent(FDC, FRC);

end;

procedure TCGDeviceContext.PageFlip;
begin

  // Page flip.
  SwapBuffers(FDC);

end;

procedure TCGDeviceContext.CleanUpGL;
begin

  // Clean up OpenGL rendering context's related resources.
  if FRC <> 0 then
  begin
    wglMakeCurrent(0, 0);
    wglDeleteContext(FRC);
  end;
  if FPalette <> 0 then DeleteObject(FPalette);
  DeleteDC(FDC);

end;

destructor TCGDeviceContext.Destroy;
begin

  // Automatically clean up.
  CleanUpGL;
  inherited Destroy;

end;

procedure TCGDeviceContext.RedoPalette;
begin

  // You remember this one, don't you?
  UnrealizeObject(FPalette);
  SelectPalette(FDC, FPalette, FALSE);
  RealizePalette(FDC);

end;

end.
