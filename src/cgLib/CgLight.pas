unit CgLight;

{ CgLib: Lighting class. }

interface

uses
  CgTypes, GL;

type
  TCGLight = class(TObject)      // OpenGL light source.
  private
    FIndex: GLenum;
    FAmbient: TCGColorF;
    FDiffuse: TCGColorF;
    FSpecular: TCGColorF;
    FPosition: TCGVector;
    FSpotDirection: TCGVector;
    FSpotExponent: Single;
    FSpotCutoff: Single;
    FConstAtt: Single;
    FLinearAtt: Single;
    FQuadraticAtt: Single;
    FInfinite: Boolean;
    procedure SetAmbient(c: TCGColorF);
    procedure SetDiffuse(c: TCGColorF);
    procedure SetSpecular(c: TCGColorF);
    procedure SetPosition(v: TCGVector);
    procedure SetSpotDirection(d: TCGVector);
    procedure SetSpotExponent(e: Single);
    procedure SetSpotCutoff(c: Single);
    procedure SetConstAtt(a: Single);
    procedure SetLinearAtt(a: Single);
    procedure SetQuadraticAtt(a: Single);
    procedure SetInfinite(i: Boolean);
  public
    constructor Create(light: GLenum);
    procedure Enable;
    procedure Disable;
    property Ambient: TCGColorF read FAmbient write SetAmbient;
    property Diffuse: TCGColorF read FDiffuse write SetDiffuse;
    property Specular: TCGColorF read FSpecular write SetSpecular;
    property Position: TCGVector read FPosition write SetPosition;
    property SpotDirection: TCGVector read FSpotDirection write SetSpotDirection;
    property SpotExponent: Single read FSpotExponent write SetSpotExponent;
    property SpotCutoff: Single read FSpotCutoff write SetSpotCutoff;
    property ConstAtt: Single read FConstAtt write SetConstAtt;
    property LinearAtt: Single read FLinearAtt write SetLinearAtt;
    property QuadraticAtt: Single read FQuadraticAtt write SetQuadraticAtt;
    property Infinite: Boolean read FInfinite write SetInfinite;
  end;

procedure cgDisableAllLights;

implementation

procedure cgDisableAllLights;
begin

  // Disable all lights and lighting.
  glDisable(GL_LIGHT0);
  glDisable(GL_LIGHT1);
  glDisable(GL_LIGHT2);
  glDisable(GL_LIGHT3);
  glDisable(GL_LIGHT4);
  glDisable(GL_LIGHT5);
  glDisable(GL_LIGHT6);
  glDisable(GL_LIGHT7);
  glDisable(GL_LIGHTING);

end;

constructor TCGLight.Create(light: GLenum);
begin

  // Create a new light source. The light parameter is GL_LIGHT0 to GL_LIGHT7.
  inherited Create;
  FIndex := light;
  // Set OpenGL defaults.
  FAmbient := cgColorF(0, 0, 0, 1);
  FDiffuse := cgColorF(1, 1, 1, 1);
  FSpecular := cgColorF(1, 1, 1, 1);
  FPosition := cgVector(0, 0, 1);
  FPosition.w := 0;
  FInfinite := TRUE;
  FSpotDirection := cgVector(0, 0, -1);
  FSpotExponent := 0;
  FSpotCutoff := 180;
  FConstAtt := 1;
  FLinearAtt := 0;
  FQuadraticAtt := 0;

end;

procedure TCGLight.Enable;
begin

  // Enable lighting if necessary, then enable this particular light.
  glEnable(GL_LIGHTING);
  glEnable(FIndex);

end;

procedure TCGLight.Disable;
begin

  // Disable this light (not all lights!).
  glDisable(FIndex);

end;

procedure TCGLight.SetAmbient(c: TCGColorF);
begin

  // Set light's ambient color.
  FAmbient := c;
  glLightfv(FIndex, GL_AMBIENT, @FAmbient);

end;

procedure TCGLight.SetDiffuse(c: TCGColorF);
begin

  // Set diffuse color.
  FDiffuse := c;
  glLightfv(FIndex, GL_DIFFUSE, @FDiffuse);

end;

procedure TCGLight.SetSpecular(c: TCGColorF);
begin

  // Set specular highlight color.
  FSpecular := c;
  glLightfv(FIndex, GL_SPECULAR, @FSpecular);

end;

procedure TCGLight.SetPosition(v: TCGVector);
begin

  // Set position.
  FPosition := v;
  if FInfinite then v.w := 0 else v.w := 1;
  glLightfv(FIndex, GL_POSITION, @FPosition);

end;

procedure TCGLight.SetSpotDirection(d: TCGVector);
begin

  // Set spotlight direction.
  FSpotDirection := d;
  glLightfv(FIndex, GL_SPOT_DIRECTION, @FSpotDirection);

end;

procedure TCGLight.SetSpotExponent(e: Single);
begin

  // Set spotlight exponent (sort of like light density or hotspot).
  FSpotExponent := e;
  glLightf(FIndex, GL_SPOT_EXPONENT, FSpotExponent);

end;

procedure TCGLight.SetSpotCutoff(c: Single);
begin

  // Set spot cutoff angle.
  FSpotCutoff := c;
  glLightf(FIndex, GL_SPOT_CUTOFF, FSpotCutoff);

end;

procedure TCGLight.SetConstAtt(a: Single);
begin

  // Set constant attenuation factor.
  FConstAtt := a;
  glLightf(FIndex, GL_CONSTANT_ATTENUATION, FConstAtt);

end;

procedure TCGLight.SetLinearAtt(a: Single);
begin

  // Set linear attenuation factor.
  FLinearAtt := a;
  glLightf(FIndex, GL_LINEAR_ATTENUATION, FConstAtt);

end;

procedure TCGLight.SetQuadraticAtt(a: Single);
begin

  // Set quadratic attenuation factor.
  FQuadraticAtt := a;
  glLightf(FIndex, GL_QUADRATIC_ATTENUATION, FConstAtt);

end;

procedure TCGLight.SetInfinite(i: Boolean);
begin

  { Toggle between local and infinite light source. For local lights, Position
    stores the actual light's position, for infinite lights, position stores
    the light's direction. }
  FInfinite := i;
  // OpenGL lights are made infinite by setting their w coordinate to 0.
  if i then FPosition.w := 0 else FPosition.w := 1;
  glLightfv(FIndex, GL_POSITION, @FPosition);

end;

end.
