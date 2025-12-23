unit CgScene;

{ CgLib: Scene global stuff. }

interface

uses
  Windows, cgGL, GLu, CgTypes, CgObject, CgLight, CgMaterials, CgTexture, CgUtils,
  CgGeometry, DArrays;

type
  TCGFog = class(TObject)
  private
    FMode: GLenum;
    FDensity: Single;
    FStart: Single;
    FEnd: Single;
    FColor: TCGColorF;
    procedure SetMode(m: GLenum);
    procedure SetDensity(d: Single);
    procedure SetStart(s: Single);
    procedure SetEnd(e: Single);
    procedure SetColor(c: TCGColorF);
  public
    constructor Create;
    procedure Enable;
    procedure Disable;
    property Mode: GLenum read FMode write SetMode;
    property Density: Single read FDensity write SetDensity;
    property FogStart: Single read FStart write SetStart;
    property FogEnd: Single read FEnd write SetEnd;
    property Color: TCGColorF read FColor write SetColor;
  end;

  TCGLightModel = class(TObject)
  private
    FAmbient: TCGColorF;
    FLocalViewer: Boolean;
    FTwoSided: Boolean;
    procedure SetAmbient(c: TCGColorF);
    procedure SetLocalViewer(l: Boolean);
    procedure SetTwoSided(t: Boolean);
  public
    property Ambient: TCGColorF read FAmbient write SetAmbient;
    property LocalViewer: Boolean read FLocalViewer write SetLocalViewer;
    property TwoSided: Boolean read FTwoSided write SetTwoSided;
  end;

  TCGCamera = record
    Pos, Target, Up: TCGVector;
  end;

  TCGViewingVolume = record
    FOV, Aspect, zNear, zFar: Single;
  end;

  TCGObjectArray = class(TDArray)
  public
    constructor Create; override;
    function GetObject(i: Integer): TCGObject;
    procedure SetObject(i: Integer; o: TCGObject);
    function CopyObject(i: Integer): TCGObject;
    property Items[i: Integer]: TCGObject read GetObject write SetObject; default;
  end;

  TCGScene = class(TObject)
  public
    Name: String[32];
    Objects: TCGObjectArray;
    Lights: array [0..7] of TCGLight;
    Materials: TCGMaterialLib;
    Textures: TCGTextureLib;
    Fog: TCGFog;
    LightModel: TCGLightModel;
    Camera: TCGCamera;
    ViewingVolume: TCGViewingVolume;
    constructor Create;
    destructor Destroy; override;
    function NewObject: Integer;
    procedure Render;
    procedure SaveToFile(filename: String);
    procedure LoadFromFile(filename: String);
  end;

  // File support types:
  // Scene file header
  TCGSceneHeader = record
    Version: TCGVersion;              // Major/minor version.
    Name: String[32];                 // Name of this scene.
    Filler: array [0..92] of Byte;
  end;
  // Scene file is chunk based -> chunk header = chunk ID.
  TCGSChunkHeader = Integer;
  // Chunk for fog settings
  TCGSFogChunk = record
    Mode: GLenum;
    Density: Single;
    FogStart: Single;
    FogEnd: Single;
    Color: TCGColorF;
    Enabled: Boolean;
  end;
  // Chunk for lightmodel settings
  TCGSLightModelChunk = record
    Ambient: TCGColorF;
    LocalViewer: Boolean;
    TwoSided: Boolean;
  end;
  // Chunk for a single light's data.
  TCGSLightChunk = record
    Index: GLenum;
    Ambient: TCGColorF;
    Diffuse: TCGColorF;
    Specular: TCGColorF;
    Position: TCGVector;
    SpotDirection: TCGVector;
    SpotExponent: Single;
    SpotCutoff: Single;
    ConstAtt: Single;
    LinearAtt: Single;
    QuadraticAtt: Single;
    Infinite: Boolean;
    Enabled: Boolean;
  end;

procedure cgSetCamera(cam: TCGCamera);
procedure cgSetPerspective(vol: TCGViewingVolume);

implementation

uses
  Classes, SysUtils;

{******************************************************************************}
{ PROCEDURES AND FUNCTIONS                                                     }
{******************************************************************************}

procedure cgSetCamera(cam: TCGCamera);
begin

  // Set the OpenGL viewpoint using gluLookAt().
  with cam do gluLookAt(Pos.x, Pos.y, Pos.z,
                        Target.x, Target.y, Target.z,
                        Up.x, Up.y, Up.z);

end;

procedure cgSetPerspective(vol: TCGViewingVolume);
begin

  // Set the OpenGL viewing volume.
  with vol do gluPerspective(FOV, Aspect, zNear, zFar);

end;

{******************************************************************************}
{ TCGFOG                                                                       }
{******************************************************************************}

constructor TCGFog.Create;
begin

  // Create TCGFog with OpenGL's default parameters.
  inherited Create;
  Mode := GL_EXP;
  Density := 1;
  FogStart := 0;
  FogEnd := 1;
  // I'm not really sure if this is the default fog color?
  Color := cgColorF(1, 1, 1, 1);

end;

procedure TCGFog.Enable;
begin

  // Enable fogging.
  glEnable(GL_FOG);

end;

procedure TCGFog.Disable;
begin

  // Disable fogging.
  glDisable(GL_FOG);

end;

procedure TCGFog.SetMode(m: GLenum);
begin

  // Change fog mode.
  FMode := m;
  glFogi(GL_FOG_MODE, m);

end;

procedure TCGFog.SetDensity(d: Single);
begin

  // Change fog density.
  FDensity := d;
  glFogf(GL_FOG_DENSITY, d);

end;

procedure TCGFog.SetStart(s: Single);
begin

  // Change distance to fog start.
  FStart := s;
  glFogf(GL_FOG_START, s);

end;

procedure TCGFog.SetEnd(e: Single);
begin

  // Change distance to fog end.
  FEnd := e;
  glFogf(GL_FOG_END, e);

end;

procedure TCGFog.SetColor(c: TCGColorF);
begin

  // Change fog color.
  FColor := c;
  glFogfv(GL_FOG_COLOR, @FColor);

end;

{******************************************************************************}
{ TCGLIGHTMODEL                                                                }
{******************************************************************************}

procedure TCGLightModel.SetAmbient(c: TCGColorF);
begin

  // Set scene's global ambient light.
  FAmbient := c;
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, @FAmbient);

end;

procedure TCGLightModel.SetLocalViewer(l: Boolean);
begin

  // Toggle use of a local or infinite viewpoint.
  FLocalViewer := l;
  glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER, Integer(l));

end;

procedure TCGLightModel.SetTwoSided(t: Boolean);
begin

  // Toggle two-sided lighting calculations.
  FTwoSided := t;
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, Integer(t));

end;

{******************************************************************************}
{ TCGOBJECTARRAY                                                               }
{******************************************************************************}

constructor TCGObjectArray.Create;
begin

  inherited Create;
  FItemSize := SizeOf(TCGObject);

end;

function TCGObjectArray.GetObject(i: Integer): TCGObject;
begin

  GetItem(i, Result);

end;

procedure TCGObjectArray.SetObject(i: Integer; o: TCGObject);
begin

  SetItem(i, o);

end;

function TCGObjectArray.CopyObject(i: Integer): TCGObject;
begin

  { Return a copy of one of the objects. Retreiving one of the objects directly
    returns the pointer to the object, which can be a problem in some situations. }
  Result := TCGObject.Create;
  with Result do
  begin
    Name := Items[i].Name;
    Origin := Items[i].Origin;
    LocalTransform := Items[i].LocalTransform;
    Vertices.Count := Items[i].Vertices.Count;
    CopyMemory(Vertices.Data, Items[i].Vertices.Data, Vertices.Count * SizeOf(TCGVertex));
    Faces.Count := Items[i].Faces.Count;
    CopyMemory(Faces.Data, Items[i].Faces.Data, Faces.Count * SizeOf(TCGFace));
  end;

end;

{******************************************************************************}
{ TCGSCENE                                                                     }
{******************************************************************************}

constructor TCGScene.Create;
var
  i: Integer;
begin

  inherited Create;
  Objects := TCGObjectArray.Create;
  for i := 0 to 7 do Lights[i] := TCGLight.Create(GL_LIGHT0 + i);
  Materials := TCGMaterialLib.Create;
  Textures := TCGTextureLib.Create;
  Fog := TCGFog.Create;
  LightModel := TCGLightModel.Create;
  FillChar(ViewingVolume, SizeOf(ViewingVolume), 0);

end;

destructor TCGScene.Destroy;
var
  i: Integer;
begin

  Objects.Free;
  for i := 0 to 7 do Lights[i].Free;
  Materials.Free;
  Textures.Free;
  Fog.Free;
  LightModel.Free;
  inherited Destroy;

end;

function TCGScene.NewObject: Integer;
var
  i: Integer;
begin

  { You can use this instead of manually calling a new object's constructor. This
    way, the object is automatically linked to the scene's material and texture
    libraries. Note: the return value is the index of the object created, so you
    could create an object and immediately start working on it by calling
      with myScene.Objects[myScene.NewObject] do
      begin
        ...
      end;
    This might be practical in scenes that create a lot of objects at runtime. }
  i := Objects.Count;
  Objects[i] := TCGObject.Create;
  with Objects[i] do
  begin
    MatLib := Materials;
    TexLib := Textures;
  end;
  Result := i;

end;

procedure TCGScene.Render;
var
  i: Integer;
begin

  { This may become slightly more complex in the future, as I intend to add
    several rendering modes, maybe on a per-object basis, even. }
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  // Don't set viewing volume if it isn't valid.
  with ViewingVolume do
  begin
    if (FOV > cgPrecision) and (Aspect > cgPrecision) and (zNear < zFar) and
       (zNear > 0) then cgSetPerspective(ViewingVolume);
  end;
  // Test the camera before setting it.
  with Camera do
  begin
    if (not cgVecComp(Up, cgOrigin)) and (not cgVecComp(Pos, Target)) then
      cgSetCamera(Camera);
  end;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  for i := 0 to Objects.Count - 1 do Objects[i].Render;
  glFinish;

end;

{******************************************************************************}
{ TCGSCENE FILE SUPPORT                                                        }
{******************************************************************************}

const
  CG_CHUNK_LIGHTMODEL  = 0;
  CG_CHUNK_FOG         = 1;
  CG_CHUNK_LIGHT       = 2;
  CG_CHUNK_OBJECT      = 3;
  CG_CHUNK_MATLIB      = 4;
  CG_CHUNK_TEXLIB      = 5;
  CG_CHUNK_CAMERA      = 6;
  CG_CHUNK_VIEWING_VOL = 7;
  // Etc.

procedure TCGScene.SaveToFile(filename: String);
var
  s: TFileStream;
  hdr: TCGSceneHeader;
  chdr: TCGSChunkHeader;
  clmodel: TCGSLightModelChunk;
  cfog: TCGSFogChunk;
  clight: TCGSLightChunk;
  i: Integer;
begin

  s := TFileStream.Create(filename, fmCreate or fmShareDenyWrite);

  // HEADER:
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Version := CG_CURRENT_VERSION;
  hdr.Name := Name;
  s.Write(hdr, SizeOf(hdr));

  // LIGHTMODEL:
  chdr := CG_CHUNK_LIGHTMODEL;
  s.Write(chdr, SizeOf(chdr));
  FillChar(clmodel, SizeOf(clmodel), 0);
  with clmodel do
  begin
    Ambient := LightModel.Ambient;
    LocalViewer := LightModel.LocalViewer;
    TwoSided := LightModel.TwoSided;
  end;
  s.Write(clmodel, SizeOf(clmodel));

  // FOG:
  chdr := CG_CHUNK_FOG;
  s.Write(chdr, SizeOf(chdr));
  FillChar(cfog, SizeOf(cfog), 0);
  with cfog do
  begin
    Mode := Fog.Mode;
    Density := Fog.Density;
    FogStart := Fog.FogStart;
    FogEnd := Fog.FogEnd;
    Color := Fog.Color;
    Enabled := glIsEnabled(GL_FOG) = GL_TRUE;
  end;
  s.Write(cfog, SizeOf(cfog));

  // LIGHTS:
  chdr := CG_CHUNK_LIGHT;
  s.Write(chdr, SizeOf(chdr));
  for i := 0 to 7 do
  begin
    FillChar(clight, SizeOf(clight), 0);
    with clight do
    begin
      Index := i;
      Ambient := Lights[i].Ambient;
      Diffuse := Lights[i].Diffuse;
      Specular := Lights[i].Specular;
      Position := Lights[i].Position;
      SpotDirection := Lights[i].SpotDirection;
      SpotExponent := Lights[i].SpotExponent;
      SpotCutoff := Lights[i].SpotCutOff;
      ConstAtt := Lights[i].ConstAtt;
      LinearAtt := Lights[i].LinearAtt;
      QuadraticAtt := Lights[i].QuadraticAtt;
      Infinite := Lights[i].Infinite;
      Enabled := glIsEnabled(GL_LIGHT0 + i) = GL_TRUE;
    end;
    s.Write(clight, SizeOf(clight));
  end;

  // MATERIAL LIBRARY:
  chdr := CG_CHUNK_MATLIB;
  s.Write(chdr, SizeOf(chdr));
  Materials.SaveToStream(s);

  // TEXTURE LIBRARY:
  chdr := CG_CHUNK_TEXLIB;
  s.Write(chdr, SizeOf(chdr));
  Textures.SaveToStream(s);

  // CAMERA:
  chdr := CG_CHUNK_CAMERA;
  s.Write(chdr, SizeOf(chdr));
  s.Write(Camera, SizeOf(Camera));

  // VIEWING VOLUME:
  chdr := CG_CHUNK_CAMERA;
  s.Write(chdr, SizeOf(chdr));
  s.Write(ViewingVolume, SizeOf(Camera));

  // OBJECTS:
  chdr := CG_CHUNK_OBJECT;
  s.Write(chdr, SizeOf(chdr));
  s.Write(Objects.Count, SizeOf(Integer));
  for i := 0 to Objects.Count - 1 do Objects[i].SaveToStream(s);

  s.Free;

end;

procedure TCGScene.LoadFromFile(filename: String);
var
  s: TFileStream;
  hdr: TCGSceneHeader;
  chdr: TCGSChunkHeader;
  clmodel: TCGSLightModelChunk;
  cfog: TCGSFogChunk;
  clight: TCGSLightChunk;
  i: Integer;
begin

  s := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);

  // HEADER:
  s.Read(hdr, SizeOf(hdr));
  if not cgIsVersion(hdr.Version[0], hdr.Version[1]) then
    raise ECGException.CreateFmt('Scene file version invalid: %d.%d',
                              [hdr.Version[0], hdr.Version[1]]);
  Name := hdr.Name;

  while s.Position < s.Size do
  begin
    // Read chunk header.
    s.Read(chdr, SizeOf(chdr));
    case chdr of
      CG_CHUNK_LIGHTMODEL: begin
          s.Read(clmodel, SizeOf(clmodel));
          with LightModel do
          begin
            Ambient := clmodel.Ambient;
            LocalViewer := clmodel.LocalViewer;
            TwoSided := clmodel.TwoSided;
          end;
        end;
      CG_CHUNK_FOG: begin
          s.Read(cfog, SizeOf(cfog));
          with Fog do
          begin
            Mode := cfog.Mode;
            Density := cfog.Density;
            FogStart := cfog.FogStart;
            FogEnd := cfog.FogEnd;
            Color := cfog.Color;
            if cfog.Enabled then Enable else Disable;
          end;
        end;
      CG_CHUNK_LIGHT: begin
          for i := 0 to 7 do
          begin
            s.Read(clight, SizeOf(clight));
            with Lights[clight.Index] do
            begin
              Ambient := clight.Ambient;
              Diffuse := clight.Diffuse;
              Specular := clight.Specular;
              Position := clight.Position;
              SpotDirection := clight.SpotDirection;
              SpotExponent := clight.SpotExponent;
              SpotCutoff := clight.SpotCutOff;
              ConstAtt := clight.ConstAtt;
              LinearAtt := clight.LinearAtt;
              QuadraticAtt := clight.QuadraticAtt;
              Infinite := clight.Infinite;
              if clight.Enabled then Enable else Disable;
            end;
          end;
        end;
      CG_CHUNK_CAMERA: begin
          s.Read(Camera, SizeOf(Camera));
        end;
      CG_CHUNK_VIEWING_VOL: begin
          s.Read(ViewingVolume, SizeOf(ViewingVolume));
        end;
      CG_CHUNK_OBJECT: begin
          s.Read(i, SizeOf(i));
          Objects.Count := i;
          for i := 0 to Objects.Count - 1 do Objects[i].LoadFromStream(s);
        end;
      CG_CHUNK_MATLIB: Materials.LoadFromStream(s);
      CG_CHUNK_TEXLIB: Textures.LoadFromStream(s);
    end;
  end;

  s.Free;

end;

end.
