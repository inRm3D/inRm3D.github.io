unit CgUtils;

{ CgLib: Debugging utilities. }

interface

{$J-}

uses
  Windows, SysUtils;

type
  // Standard type for version numbers (xx.xx format).
  TCGVersion = array [0..1] of Byte;

type
  ECGException = class(Exception)
    constructor CreateDef;  // Create exception with default message.
  end;

const
  // This is CgLib's current version number (major/minor):
  CG_CURRENT_VERSION: TCGVersion = (1, 10);

type
  PComp = ^Comp;

function cgIntPower(base: Single; exp: Integer): Single;
function cgArcCos(x: Single): Single;
function cgIsVersion(major, minor: Byte): Boolean;
function cgTime: Comp;
function cgTimeSince(start: Comp): Single;
procedure cgStartTiming;
function cgTimeElapsed: Single;
procedure cgIdle(delay: Single);

function QueryPerformanceCounter(lpPerformanceCount: PComp): Boolean; stdcall; external 'KERNEL32.DLL';
function QueryPerformanceFrequency(lpFrequency: PComp): Boolean; stdcall; external 'KERNEL32.DLL';

implementation

uses
  Forms;

{******************************************************************************}
{ CGLIB MATHEMATICS FUNCTIONS                                                  }
{******************************************************************************}

function cgIntPower(base: Single; exp: Integer): Single;
var
  i: Integer;
begin

  if exp = 0 then Result := 1
  else begin
    if exp < 0 then Result := 1 / cgIntPower(base, Abs(exp))
    else begin
      Result := 1;
      for i := 1 to exp do Result := Result * base;
    end;
  end;

end;

function ArcTan2(Y, X: Extended): Extended;
asm

  FLD Y
  FLD X
  FPATAN
  FWAIT

end;

function cgArcCos(x: Single): Single;
begin

  Result := ArcTan2(Sqrt(1 - x*x), x);

end;

{******************************************************************************}
{ CGLIB EXCEPTION CLASSES                                                      }
{******************************************************************************}

constructor ECGException.CreateDef;
begin

  inherited Create('CgLib error!');

end;

{******************************************************************************}
{ MISCELLANEOUS ROUTINES                                                       }
{******************************************************************************}

function cgIsVersion(major, minor: Byte): Boolean;
begin

  Result := (CG_CURRENT_VERSION[0] > major) or ((CG_CURRENT_VERSION[0] = major)
             and (CG_CURRENT_VERSION[1] >= minor));

end;

{******************************************************************************}
{ PERFORMANCE TESTING ROUTINES                                                 }
{******************************************************************************}

var
  StartTime: Comp;
  freq: Comp;

function cgTime: Comp;
begin

  // Return the current performance counter value.
  QueryPerformanceCounter(@Result);

end;

function cgTimeSince(start: Comp): Single;
var
  x: Comp;
begin

  // Return the time elapsed since start (get start with cgTime()).
  QueryPerformanceCounter(@x);
  Result := (x - start) * 1000 / freq;

end;

procedure cgStartTiming;
begin

  // Call this to start measuring elapsed time.
  StartTime := cgTime;

end;

function cgTimeElapsed: Single;
begin

  // Call this to measure the time elapsed since the last StartTiming call.
  Result := cgTimeSince(StartTime);

end;

procedure cgIdle(delay: Single);
begin

  // Do nothing for a specified time.
  cgStartTiming;
  while cgTimeElapsed < delay do
  begin
    // Don't just block everything, though!
    Application.ProcessMessages;
  end;

end;

initialization

  QueryPerformanceFrequency(@freq);

end.
