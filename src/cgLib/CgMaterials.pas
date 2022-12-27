unit CgMaterials;

{ CgLib: Material types and routines and material library class. }

interface

uses
  Classes, CgTypes, DArrays;

type
  TCGMaterial = record
    Ambient: TCGColorF;
    Diffuse: TCGColorF;
    Specular: TCGColorF;
    Shininess: Single;
    Emission: TCGColorF;
  end;
  PCGMaterial = ^TCGMaterial;

  TCGMatLibHeader = record
    Count: Integer;
    Filler: array [0..123] of Byte;
  end;
  TCGMaterialLib = class(TDArray)
  public
    constructor Create; override;
    function GetMaterial(i: Integer): TCGMaterial;
    procedure SetMaterial(i: Integer; m: TCGMaterial);
    function MaterialPtr(i: Integer): PCGMaterial;
    procedure Apply(m: Integer);
    procedure LoadFromFile(filename: String);
    procedure SaveToFile(filename: String);
    procedure LoadFromStream(s: TStream);
    procedure SaveToStream(s: TStream);
    property Materials[i: Integer]: TCGMaterial read GetMaterial write SetMaterial; default;
  end;

function cgMaterial(mAmbient, mDiffuse, mSpecular: TCGColorF; mShininess: Single;
                    mEmission: TCGColorF): TCGMaterial;
procedure cgApplyMaterial(m: TCGMaterial);
procedure cgChangeMaterial(m: TCGMaterial; amb, diff, spec, shin, emm: Boolean);
function cgDefaultMaterial: TCGMaterial;

implementation

uses
  GL;

function cgMaterial(mAmbient, mDiffuse, mSpecular: TCGColorF; mShininess: Single;
                    mEmission: TCGColorF): TCGMaterial;
begin

  { Create a TCGMaterial record. }
  with Result do
  begin
    Ambient := mAmbient;
    Diffuse := mDiffuse;
    Specular := mSpecular;
    Shininess := mShininess;
    Emission := mEmission;
  end;

end;

procedure cgApplyMaterial(m: TCGMaterial);
begin

  { Apply a material to all following OpenGL commands. Since everyone's always
    saying glMaterial*() is expensive, I guess this routine should be avoided :-) }
  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, @m.Ambient);
  glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, @m.Diffuse);
  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @m.Specular);
  glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, m.Shininess);
  glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, @m.Emission);

end;

procedure cgChangeMaterial(m: TCGMaterial; amb, diff, spec, shin, emm: Boolean);
begin

  { Change the selected material properties. This should be a little less
    expensive than cgSetMaterial. }
  if amb then glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, @m.Ambient);
  if diff then glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, @m.Diffuse);
  if spec then glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @m.Specular);
  if shin then glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, m.Shininess);
  if emm then glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, @m.Emission);

end;

function cgDefaultMaterial: TCGMaterial;
begin

  // Return a default material (used to render faces with no material ID). 
  with Result do
  begin
    Ambient := cgColorF(0.2, 0.2, 0.2, 1);
    Diffuse := cgColorF(0.8, 0.8, 0.8, 1);
    Specular := cgColorF(0, 0, 0, 0);
    Shininess := 0;
    Emission := cgColorF(0, 0, 0, 0); 
  end;

end;

{******************************************************************************}
{ TCGMATERIALLIB IMPLEMENTATION                                                }
{******************************************************************************}

constructor TCGMaterialLib.Create;
begin

  inherited Create;
  FItemSize := SizeOf(TCGMaterial);

end;

function TCGMaterialLib.GetMaterial(i: Integer): TCGMaterial;
begin

  GetItem(i, Result);

end;

procedure TCGMaterialLib.SetMaterial(i: Integer; m: TCGMaterial);
begin

  SetItem(i, m);

end;

function TCGMaterialLib.MaterialPtr(i: Integer): PCGMaterial;
begin

  // Return a pointer to one of the materials.
  Result := Pointer(Integer(Data) + (i * ItemSize));

end;

procedure TCGMaterialLib.Apply(m: Integer);
begin

  cgApplyMaterial(Materials[m]);

end;

procedure TCGMaterialLib.LoadFromFile(filename: String);
var
  f: File;
  i: Integer;
  hdr: TCGMatLibHeader;
begin

  // Load materials from file.
  AssignFile(f, filename);
  try
    Reset(f, 1);
    BlockRead(f, hdr, SizeOf(hdr));
    Count := hdr.Count;
    if Count > 0 then for i := 0 to Count - 1 do
    begin
      BlockRead(f, MaterialPtr(i)^, SizeOf(TCGMaterial));
    end;
  finally
    CloseFile(f);
  end;

end;

procedure TCGMaterialLib.SaveToFile(filename: String);
var
  f: File;
  i: Integer;
  hdr: TCGMatLibHeader;
begin

  // Save materials to file.
  AssignFile(f, filename);
  try
    Rewrite(f, 1);
    FillChar(hdr, SizeOf(hdr), 0);
    hdr.Count := Count;
    BlockWrite(f, hdr, SizeOf(hdr));
    if Count > 0 then for i := 0 to Count - 1 do
    begin
      BlockWrite(f, MaterialPtr(i)^, SizeOf(TCGMaterial));
    end;
  finally
    CloseFile(f);
  end;

end;

procedure TCGMaterialLib.LoadFromStream(s: TStream);
var
  i: Integer;
  hdr: TCGMatLibHeader;
begin

  // Load materials from stream.
  s.Read(hdr, SizeOf(hdr));
  Count := hdr.Count;
  if Count > 0 then for i := 0 to Count - 1 do
  begin
    s.Read(MaterialPtr(i)^, SizeOf(TCGMaterial));
  end;

end;

procedure TCGMaterialLib.SaveToStream(s: TStream);
var
  i: Integer;
  hdr: TCGMatLibHeader;
begin

  // Save materials to stream.
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Count := Count;
  s.Write(hdr, SizeOf(hdr));
  if Count > 0 then for i := 0 to Count - 1 do
  begin
    s.Write(MaterialPtr(i)^, SizeOf(TCGMaterial));
  end;

end;

end.
