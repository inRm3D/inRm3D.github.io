unit CgTypes;

{ CgLib: Basic data types and structures. }

interface

uses
  Graphics;    // Just for TColor.

type
  TCGVector = record
    x, y, z, w, r: Single;  // Store w for OpenGL compatibility, but keep it 1.
  end;
  PCGVector = ^TCGVector;

  TCGMatrix = array [0..3, 0..3] of Single;  // The homogenous coordinates are ignored!
  PCGMatrix = ^TCGMatrix;

  TCGColorF = record
    R, G, B, A: Single;          // RGBA floating point quadruple.
  end;
  PCGColorF = ^TCGColorF;

  TCGColorB = record
    R, G, B, A: Byte;            // RGBA byte quadruple.
  end;
  PCGColorB = ^TCGColorB;

  TCGVertex = record             // Vertex for 3D object construction.
    p: TCGVector;                // Vertex coordinates.
    Color: TCGColorB;            // Vertex color. Use bytes for file size efficiency.
    u, v: Single;                // Texture coordinates.
  end;
  PCGVertex = ^TCGVertex;

  TCGPlane = record
    A, B, C, D: Single;          // Plane equation (Ax + By + Cz + D = 0).
  end;
  PCGPlane = ^TCGPlane;

  TCGFace = record               // Triangular 3D object face.
    A, B, C: Integer;            // Indices of this face's vertices.
    Texture: Integer;            // Index to texture library.
    Material: Integer;           // Index to material library.
  end;                           // (Array with vertices is implemented in 3D object)
  PCGFace = ^TCGFace;

function cgVector(vx, vy, vz: Single): TCGVector;
function cgVectorToVertex(vect: TCGVector; vcolor: TCGColorB; vu, vv: Single): TCGVertex;

function cgColorF(cR, cG, cB, cA: Single): TCGColorF;
function cgTColorToCGColorF(c: TColor; alpha: Single): TCGColorF;
function cgColorFToTColor(c: TCGColorF): TColor;

function cgColorB(cR, cG, cB, cA: Byte): TCGColorB;
function cgTColorToCGColorB(c: TColor; alpha: Byte): TCGColorB;
function cgColorBToTColor(c: TCGColorB): TColor;

function cgColorBtoColorF(c: TCGColorB): TCGColorF;
function cgColorFtoColorB(c: TCGColorF): TCGColorB;

function cgVertex(vx, vy, vz: Single; vcolor: TCGColorB; vu, vv: Single): TCGVertex;
function cgPlane(pA, pB, pC, pD: Single): TCGPlane;
function cgFace(fA, fB, fC, fMat, fTex: Integer): TCGFace;

implementation

{******************************************************************************}
{ TCGVECTOR HANDLING ROUTINES                                                  }
{******************************************************************************}

function cgVector(vx, vy, vz: Single): TCGVector;
begin { Create a TCGVector at [vx, vy, vz]. }
  with Result do begin
    x := vx;
    y := vy;
    z := vz;  //
    w := 0;
  end;
end;

function cgVectorToVertex(vect: TCGVector; vcolor: TCGColorB; vu, vv: Single): TCGVertex;
begin

  { Create a TCGVertex based on a vector v. }
  with Result do
  begin
    p := vect;
    color := vcolor;
    u := vu;
    v := vv;
  end;

end;

{******************************************************************************}
{ TCGCOLORF HANDLING ROUTINES                                                  }
{******************************************************************************}

function cgColorF(cR, cG, cB, cA: Single): TCGColorF;
begin

  { Create a TCGColor. Clamp values to [0..1]. }
  with Result do
  begin
    R := cR; if R > 1 then R := 1 else if R < 0 then R := 0;
    G := cG; if G > 1 then G := 1 else if G < 0 then G := 0;
    B := cB; if B > 1 then B := 1 else if B < 0 then B := 0;
    A := cA; if A > 1 then A := 1 else if A < 0 then A := 0;
  end;

end;

function cgTColorToCGColorF(c: TColor; alpha: Single): TCGColorF;
begin

  { Convert TColor to TCGColor. TColor doesn't have alpha, so pass it separately. }
  with Result do
  begin
    R := (c mod $100) / 255;
    G :=((c div $100) mod $100) / 255;
    B := (c div $10000) / 255;
    A := alpha;
  end;

end;

function cgColorFToTColor(c: TCGColorF): TColor;
begin

  { Convert TCGColor to standard TColor. Alpha is lost. }
  Result := Round(c.R * 255) + Round(c.G * 65280) + Round(c.B * 16711680);

end;

{******************************************************************************}
{ TCGCOLORB HANDLING ROUTINES                                                  }
{******************************************************************************}

function cgColorB(cR, cG, cB, cA: Byte): TCGColorB;
begin

  { Create a TCGColor. }
  with Result do
  begin
    R := cR;
    G := cG;
    B := cB;
    A := cA;
  end;

end;

function cgTColorToCGColorB(c: TColor; alpha: Byte): TCGColorB;
begin

  { Convert TColor to TCGColor. TColor doesn't have alpha, so pass it separately. }
  with Result do
  begin
    R := (c mod $100);
    G := ((c div $100) mod $100);
    B := (c div $10000);
    A := alpha;
  end;

end;

function cgColorBToTColor(c: TCGColorB): TColor;
begin

  { Convert TCGColor to standard TColor. Alpha is lost. }
  Result := c.R + (c.G * $100) + (c.B * $10000);

end;

{******************************************************************************}
{ TCGCOLOR CONVERSION ROUTINES                                                 }
{******************************************************************************}

function cgColorBtoColorF(c: TCGColorB): TCGColorF;
begin

  { Convert byte quad to float quad. }
  with Result do
  begin
    R := c.R / 255;
    B := c.B / 255;
    G := c.G / 255;
    A := c.A / 255;
  end;

end;

function cgColorFtoColorB(c: TCGColorF): TCGColorB;
begin

  { Convert float quad to byte quad. }
  with Result do
  begin
    R := Round(c.R * 255);
    B := Round(c.B * 255);
    G := Round(c.G * 255);
    A := Round(c.A * 255);
  end;

end;

{******************************************************************************}
{ TCGVERTEX HANDLING ROUTINES                                                  }
{******************************************************************************}

function cgVertex(vx, vy, vz: Single; vcolor: TCGColorB; vu, vv: Single): TCGVertex;
begin

  { Create a TCGVertex. }
  with Result do
  begin
    p := cgVector(vx, vy, vz);
    color := vcolor;
    u := vu;
    v := vv;
  end;

end;

{******************************************************************************}
{ TCGPLANE HANDLING ROUTINES                                                   }
{******************************************************************************}

function cgPlane(pA, pB, pC, pD: Single): TCGPlane;
begin

  { Create a TCGPlane. }
  with Result do
  begin
    A := pA;
    B := pB;
    C := pC;
    D := pD;
  end;

end;

{******************************************************************************}
{ TCGFACE HANDLING ROUTINES                                                    }
{******************************************************************************}

function cgFace(fA, fB, fC, fMat, fTex: Integer): TCGFace;
begin

  { Create a TCGFace. }
  with Result do
  begin
    A := fA;
    B := fB;
    C := fC;
    Material := fMat;
    Texture := fTex;
  end;

end;

end.
