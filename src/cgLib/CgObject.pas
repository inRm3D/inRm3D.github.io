unit CgObject;

{ Remark: there are some problems when using TCGObject with OpenGL's lighting.
  I'm pretty sure it has something to do with the normal vectors. It should work
  if you explicitly recalculate the normals for every frame, though. }

interface

uses
  Classes, DArrays, CgTypes, CgMaterials, CgTexture;

type
  TCGVertexArray = class(TDArray)
  public
    constructor Create; override;
    function GetVertex(i: Integer): TCGVertex;
    procedure SetVertex(i: Integer; vertex: TCGVertex);
    property Items[i: Integer]: TCGVertex read GetVertex write SetVertex; default;
    function VertexPtr(i: Integer): PCGVertex;
  end;

  TCGObject = class;  // Forward declaration to allow for the following event type:
  TCGAddFaceEvent = procedure(o: TCGObject; f: TCGFace; i: Integer);
  
  TCGFaceArray = class(TDArray)
  protected
    OnAddFace: TCGAddFaceEvent;
    Parent: TCGObject;
  public
    constructor Create; override;
    function GetFace(i: Integer): TCGFace;
    procedure SetFace(i: Integer; Face: TCGFace);
    property Items[i: Integer]: TCGFace read GetFace write SetFace; default;
    function FacePtr(i: Integer): PCGFace;
  end;

  TCGVectorArray = class(TDArray)
  public
    constructor Create; override;
    function GetVector(i: Integer): TCGVector;
    procedure SetVector(i: Integer; Vector: TCGVector);
    property Items[i: Integer]: TCGVector read GetVector write SetVector; default;
    function VectorPtr(i: Integer): PCGVector;
  end;

  TCGObject = class(TObject)
  private
    FDisplayList: Cardinal;
  public
    Name: String[32];             // Name of object.
    Vertices: TCGVertexArray;
    Faces: TCGFaceArray;
    Normals: TCGVectorArray;      // Face normals.
    Origin: TCGVector;            // Object origin.
    LocalTransform: TCGMatrix;    // Local transformation matrix for object.
    MatLib: TCGMaterialLib;       // Points to material library for this object.
    TexLib: TCGTextureLib;        // Points to texture library for this object.
    constructor Create;
    destructor Destroy; override;
    procedure Render;
    procedure MakeDisplayList;    // Create a display list that draws the object.
    procedure CallDisplayList;    // Draw the object by calling its display list.
    procedure LoadFromFile(filename: String);
    procedure LoadFromStream(s: TStream);
    procedure SaveToFile(filename: String);
    procedure SaveToStream(s: TStream);
  end;
  // CGO File format header:
  TCGObjectHeader = record
    Name: String[32];
    Origin: TCGVector;
    LocalTransform: TCGMatrix;
    VertCount: Integer;
    FaceCount: Integer;
    HasNormals: Boolean;
    Filler: array [1..131] of Byte;
  end;

const
  CG_NO_MATERIAL = -1;  // Face has no material library index.
  CG_NO_TEXTURE  = -1;  // Face has no texture library index.

function cgCube(s: Single): TCGObject;
function cgCone(r, height: Single; segs: Integer): TCGObject;

implementation

uses
  cgGL, Glut, CgGeometry, SysUtils;

{******************************************************************************}
{ TCGVERTEXARRAY IMPLEMENTATION                                                }
{******************************************************************************}

constructor TCGVertexArray.Create;
begin

  // Create a TDArray of vertices.
  inherited Create;
  FItemSize := SizeOf(TCGVertex);

end;

function TCGVertexArray.GetVertex(i: Integer): TCGVertex;
begin

  // Guess what this does...
  GetItem(i, Result);

end;

procedure TCGVertexArray.SetVertex(i: Integer; vertex: TCGVertex);
begin

  // Why am I writing comments for this???
  SetItem(i, vertex);

end;

function TCGVertexArray.VertexPtr(i: Integer): PCGVertex;
begin

  // Return a pointer to one of the vertices.
  Result := Pointer(Integer(Data) + (i * ItemSize));

end;

{******************************************************************************}
{ TCGFACEARRAY IMPLEMENTATION                                                }
{******************************************************************************}

constructor TCGFaceArray.Create;
begin

  // Create a TDArray of faces.
  inherited Create;
  FItemSize := SizeOf(TCGFace);

end;

function TCGFaceArray.GetFace(i: Integer): TCGFace;
begin

  // TO DO: Write some profound comment for this method.
  GetItem(i, Result);

end;

procedure TCGFaceArray.SetFace(i: Integer; Face: TCGFace);
begin

  // Tip of the day: You don't need to call this method to add faces to your array.
  SetItem(i, Face);
  OnAddFace(Parent, Face, i);

end;

function TCGFaceArray.FacePtr(i: Integer): PCGFace;
begin

  // Return a pointer to a face.
  Result := Pointer(Integer(Data) + (i * ItemSize));

end;

{******************************************************************************}
{ TCGVECTORARRAY IMPLEMENTATION                                                }
{******************************************************************************}

constructor TCGVectorArray.Create;
begin

  // Create an array of vectors.
  inherited Create;
  FItemSize := SizeOf(TCGVector);

end;

function TCGVectorArray.GetVector(i: Integer): TCGVector;
begin

  // I'm very disciplined about this: _every_ routine should be commented!
  GetItem(i, Result);

end;

procedure TCGVectorArray.SetVector(i: Integer; Vector: TCGVector);
begin

  // You've seen enough TDArray descendants in CgLib to know what this does.
  SetItem(i, Vector);

end;

function TCGVectorArray.VectorPtr(i: Integer): PCGVector;
begin

  // Return a pointer to a vector.
  Result := Pointer(Integer(Data) + (i * ItemSize));

end;

{******************************************************************************}
{ OBJECT RENDERING COMMANDS                                                    }
{******************************************************************************}

{ The following procedure exists only because in the future, when rendering 3D
  objects from within a TCGScene class, several objects might need to be aware
  of eachother (for collision detection or whatever). The way an object is
  rendered might be dependent on the state of other objects. For this reason,
  the rendering procedure cannot be made local to TCGObject. This procedure
  should never be called by the user, as it may disappear or drastically change
  behaviour due to changes to TCGScene. }

procedure cgRenderObject(obj: TCGObject);
var
  f: Integer;
begin

  // Render object.
  with obj do
  begin
    if Faces.Count > 0 then
    begin
      glPushAttrib(GL_ALL_ATTRIB_BITS);
      glPushMatrix;
        // Apply local transformation.
        glTranslatef(Origin.x, Origin.y, Origin.z);
        glMultMatrixf(@LocalTransform);
        // Draw faces.
        glBegin(GL_TRIANGLES);
          for f := 0 to Faces.Count - 1 do
          begin
            glNormal3fv(@Normals.VectorPtr(f)^.x);
            // Set material and texture.
            if Faces[f].Material <> CG_NO_MATERIAL then
              cgApplyMaterial(MatLib[Faces[f].Material])
            else CgApplyMaterial(cgDefaultMaterial);
            if Faces[f].Texture <> CG_NO_TEXTURE then
                TexLib[Faces[f].Texture].Enable;
            // Set color and texture coordinates, then draw vertex.
            glColor4ubv(@Vertices.VertexPtr(Faces[f].A)^.Color);
            glTexCoord2f(Vertices[Faces[f].A].u, Vertices[Faces[f].A].v);
            glVertex3fv(@Vertices.VertexPtr(Faces[f].A)^.p);

            glColor4ubv(@Vertices.VertexPtr(Faces[f].B)^.Color);
            glTexCoord2f(Vertices[Faces[f].B].u, Vertices[Faces[f].B].v);
            glVertex3fv(@Vertices.VertexPtr(Faces[f].B)^.p);

            glColor4ubv(@Vertices.VertexPtr(Faces[f].C)^.Color);
            glTexCoord2f(Vertices[Faces[f].C].u, Vertices[Faces[f].C].v);
            glVertex3fv(@Vertices.VertexPtr(Faces[f].C)^.p);
            if Faces[f].Texture <> CG_NO_TEXTURE then
                TexLib[Faces[f].Texture].Disable;
          end;
        glEnd;
      glPopMatrix;
      glPopAttrib;
    end;
  end;

end;

{******************************************************************************}
{ TCGOBJECT IMPLEMENTATION                                                     }
{******************************************************************************}

procedure cgObjectAddFace(o: TCGObject; f: TCGFace; i: Integer);
begin

  { This is executed when a face is added to the object. This is to make sure
    the normal is calculated automatically. }
  with o do
  begin
    Normals.Count := Normals.Count + 1;
    Normals[i] := cgGetNormal(Vertices[f.A].p,
                              Vertices[f.B].p,
                              Vertices[f.C].p);
  end;

end;

constructor TCGObject.Create;
begin

  // Create new 3D object.
  inherited Create;
  Vertices := TCGVertexArray.Create;
  Faces := TCGFaceArray.Create;
  Faces.Parent := Self;
  Faces.OnAddFace := cgObjectAddFace;
  Normals := TCGVectorArray.Create;
  FDisplayList := 0;
  Origin := cgOrigin;
  LocalTransform := cgIdentity;

end;

destructor TCGObject.Destroy;
begin

  // Free vertex, face and normal arrays first.
  Vertices.Free;
  Faces.Free;
  Normals.Free;
  inherited Destroy;

end;

procedure TCGObject.Render;
begin

  // Just call the rendering routine implemented above.
  cgRenderObject(Self);

end;

procedure TCGObject.MakeDisplayList;
begin

  // Create a display list to render the object.
  FDisplayList := glGenLists(1);
  glNewList(FDisplayList, GL_COMPILE);
    Render;
  glEndList;

end;

procedure TCGObject.CallDisplayList;
begin

  // If one has been created, call the display list.
  if glIsList(FDisplayList) = GL_TRUE then glCallList(FDisplayList);

end;

procedure TCGObject.LoadFromFile(filename: String);
var
  f: File;
  hdr: TCGObjectHeader;
begin

  // Load object from a .CGO file.
  AssignFile(f, filename);
  Reset(f, 1);
  BlockRead(f, hdr, SizeOf(hdr));
  Vertices.Count := hdr.VertCount;
  BlockRead(f, Vertices.Data^, Vertices.ItemSize * hdr.VertCount);
  Faces.Count := hdr.FaceCount;
  BlockRead(f, Faces.Data^, Faces.ItemSize * hdr.FaceCount);
  if hdr.HasNormals then
  begin
    Normals.Count := hdr.FaceCount;
    BlockRead(f, Normals.Data^, Normals.ItemSize * hdr.FaceCount);
  end;
  Name := hdr.Name;
  Origin := hdr.Origin;
  LocalTransform := hdr.LocalTransform;
  CloseFile(f);

end;

procedure TCGObject.LoadFromStream(s: TStream);
var
  hdr: TCGObjectHeader;
begin

  // Load object from stream.
  s.Read(hdr, SizeOf(hdr));
  Vertices.Count := hdr.VertCount;
  s.Read(Vertices.Data^, Vertices.ItemSize * hdr.VertCount);
  Faces.Count := hdr.FaceCount;
  s.Read(Faces.Data^, Faces.ItemSize * hdr.FaceCount);
  if hdr.HasNormals then
  begin
    Normals.Count := hdr.FaceCount;
    s.Read(Normals.Data^, Normals.ItemSize * hdr.FaceCount);
  end;
  Name := hdr.Name;
  Origin := hdr.Origin;
  LocalTransform := hdr.LocalTransform;

end;

procedure TCGObject.SaveToFile(filename: String);
var
  f: File;
  hdr: TCGObjectHeader;
begin

  // Save object to a .CGO file.
  AssignFile(f, filename);
  Rewrite(f, 1);
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Name := Name;
  hdr.Origin := Origin;
  hdr.LocalTransform := LocalTransform;
  hdr.VertCount := Vertices.Count;
  hdr.FaceCount := Faces.Count;
  hdr.HasNormals := Normals.Count > 0;
  BlockWrite(f, hdr, SizeOf(hdr));
  BlockWrite(f, Vertices.Data^, Vertices.ItemSize * hdr.VertCount);
  BlockWrite(f, Faces.Data^, Faces.ItemSize * hdr.FaceCount);
  if hdr.HasNormals then BlockWrite(f, Normals.Data^, Normals.ItemSize * hdr.FaceCount);
  CloseFile(f);

end;

procedure TCGObject.SaveToStream(s: TStream);
var
  hdr: TCGObjectHeader;
begin

  // Save object to a .CGO file.
  FillChar(hdr, SizeOf(hdr), 0);
  hdr.Name := Name;
  hdr.Origin := Origin;
  hdr.LocalTransform := LocalTransform;
  hdr.VertCount := Vertices.Count;
  hdr.FaceCount := Faces.Count;
  hdr.HasNormals := Normals.Count > 0;
  s.Write(hdr, SizeOf(hdr));
  s.Write(Vertices.Data^, Vertices.ItemSize * hdr.VertCount);
  s.Write(Faces.Data^, Faces.ItemSize * hdr.FaceCount);
  if hdr.HasNormals then s.Write(Normals.Data^, Normals.ItemSize * hdr.FaceCount);

end;

{******************************************************************************}
{ PRIMITIVE CREATION ROUTINES                                                  }
{******************************************************************************}

function cgCone(r, height: Single; segs: Integer): TCGObject;
var
  i: Integer;
begin

  // Create a cone.
  Result := TCGObject.Create;
  with Result do
  begin
    Vertices[0] := cgVertex(0, height, 0, cgColorB(255, 255, 255, 255), 0.5, 1);
    Vertices[1] := cgVertex(0, 0, r, cgColorB(255, 255, 255, 255), 0, 0);
    for i := 2 to segs do
    begin
      Vertices[i] := Vertices[i-1];
      cgRotateY(Vertices.VertexPtr(i)^.p, 2*pi/segs);
      if i <> segs then Vertices.VertexPtr(i)^.u := 1 / (segs - i);
    end;
    Vertices[segs+1] := cgVertex(0, 0, 0, cgColorB(255, 255, 255, 255), 0.5, 0.5);
    for i := 0 to segs - 1 do
    begin
      Faces[i] := cgFace(0, 1+(i+1) mod segs, 1+(i+2) mod segs, CG_NO_MATERIAL, CG_NO_TEXTURE);
      Faces[i + segs] := cgFace(segs+1, 1+(i+1) mod segs, 1+(i+2) mod segs, CG_NO_MATERIAL, CG_NO_TEXTURE);
    end;
  end;

end;

function cgCube(s: Single): TCGObject;
begin

  Result := TCGObject.Create;
  s := s / 2;
  with Result do
  begin
    // Front face:
    Vertices[0] := cgVertex(-s, -s, s, cgColorB(255, 255, 255, 255), 0, 0);
    Vertices[1] := cgVertex(s, -s, s, cgColorB(255, 255, 255, 255), 1, 0);
    Vertices[2] := cgVertex(s, s, s, cgColorB(255, 255, 255, 255), 1, 1);
    Vertices[3] := cgVertex(-s, s, s, cgColorB(255, 255, 255, 255), 0, 1);
    Faces[0] := cgFace(0, 1, 2, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Faces[1] := cgFace(2, 3, 0, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Normals[0] := cgVector(0, 0, 1);
    Normals[1] := Normals[0];
    // Back face:
    Vertices[4] := cgVertex(s, -s, -s, cgColorB(255, 255, 255, 255), 0, 0);
    Vertices[5] := cgVertex(-s, -s, -s, cgColorB(255, 255, 255, 255), 1, 0);
    Vertices[6] := cgVertex(-s, s, -s, cgColorB(255, 255, 255, 255), 1, 1);
    Vertices[7] := cgVertex(s, s, -s, cgColorB(255, 255, 255, 255), 0, 1);
    Faces[2] := cgFace(4, 5, 6, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Faces[3] := cgFace(6, 7, 4, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Normals[2] := cgVector(0, 0, -1);
    Normals[3] := Normals[0];
    // Top face:
    Vertices[8] := cgVertex(-s, s, s, cgColorB(255, 255, 255, 255), 0, 0);
    Vertices[9] := cgVertex(s, s, s, cgColorB(255, 255, 255, 255), 1, 0);
    Vertices[10] := cgVertex(s, s, -s, cgColorB(255, 255, 255, 255), 1, 1);
    Vertices[11] := cgVertex(-s, s, -s, cgColorB(255, 255, 255, 255), 0, 1);
    Faces[4] := cgFace(8, 9, 10, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Faces[5] := cgFace(10, 11, 8, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Normals[4] := cgVector(0, 1, 0);
    Normals[5] := Normals[0];
    // Bottom face:
    Vertices[12] := cgVertex(-s, -s, -s, cgColorB(255, 255, 255, 255), 0, 0);
    Vertices[13] := cgVertex(s, -s, -s, cgColorB(255, 255, 255, 255), 1, 0);
    Vertices[14] := cgVertex(s, -s, s, cgColorB(255, 255, 255, 255), 1, 1);
    Vertices[15] := cgVertex(-s, -s, s, cgColorB(255, 255, 255, 255), 0, 1);
    Faces[6] := cgFace(12, 13, 14, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Faces[7] := cgFace(14, 15, 12, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Normals[6] := cgVector(0, -1, 0);
    Normals[7] := Normals[0];
    // Left face:
    Vertices[16] := cgVertex(s, -s, -s, cgColorB(255, 255, 255, 255), 0, 0);
    Vertices[17] := cgVertex(s, -s, s, cgColorB(255, 255, 255, 255), 1, 0);
    Vertices[18] := cgVertex(s, s, s, cgColorB(255, 255, 255, 255), 1, 1);
    Vertices[19] := cgVertex(s, s, -s, cgColorB(255, 255, 255, 255), 0, 1);
    Faces[8] := cgFace(16, 17, 18, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Faces[9] := cgFace(18, 19, 16, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Normals[8] := cgVector(1, 0, 0);
    Normals[9] := Normals[0];
    // Right face:
    Vertices[20] := cgVertex(-s, -s, s, cgColorB(255, 255, 255, 255), 0, 0);
    Vertices[21] := cgVertex(-s, -s, -s, cgColorB(255, 255, 255, 255), 1, 0);
    Vertices[22] := cgVertex(-s, s, -s, cgColorB(255, 255, 255, 255), 1, 1);
    Vertices[23] := cgVertex(-s, s, s, cgColorB(255, 255, 255, 255), 0, 1);
    Faces[10] := cgFace(20, 21, 22, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Faces[11] := cgFace(22, 23, 20, CG_NO_MATERIAL, CG_NO_TEXTURE);
    Normals[10] := cgVector(-1, 0, 1);
    Normals[11] := Normals[0];
  end;

end;

end.
