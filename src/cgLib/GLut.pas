unit Glut;

interface

uses
  cgGL;

type
  PInteger = ^Integer;            // These two really suck, but I didn't see any
  PPChar = ^PChar;                // other or better way to solve the glutInit issue.
  TGlutVoidCallback = procedure; stdcall;
  TGlut1IntCallback = procedure(value: Integer); stdcall;
  TGlut2IntCallback = procedure(v1, v2: Integer); stdcall;
  TGlut3IntCallback = procedure(v1, v2, v3: Integer); stdcall;
  TGlut4IntCallback = procedure(v1, v2, v3, v4: Integer); stdcall;
  TGlut1Char2IntCallback = procedure(c: Byte; v1, v2: Integer); stdcall;

{$INCLUDE GLDRIVER.INC}

const
  {$IFDEF SGIGL}
    GLUTDLL = 'GLUT.DLL';
  {$ELSE}
    {$IFDEF 3DFXGL}
      GLUTDLL = '';   //*** There is no 3dfxOpenGL version of GLUT!
    {$ELSE}
      GLUTDLL = 'GLUT32.DLL';
    {$ENDIF}
  {$ENDIF}

  GLUT_API_VERSION                = 3;
  GLUT_XLIB_IMPLEMENTATION        = 12;
  // Display mode bit masks.
  GLUT_RGB                        = 0;
  GLUT_RGBA                       = GLUT_RGB;
  GLUT_INDEX                      = 1;
  GLUT_SINGLE                     = 0;
  GLUT_DOUBLE                     = 2;
  GLUT_ACCUM                      = 4;
  GLUT_ALPHA                      = 8;
  GLUT_DEPTH                      = 16;
  GLUT_STENCIL                    = 32;
  GLUT_MULTISAMPLE                = 128;
  GLUT_STEREO                     = 256;
  GLUT_LUMINANCE                  = 512;

  // Mouse buttons.
  GLUT_LEFT_BUTTON                = 0;
  GLUT_MIDDLE_BUTTON              = 1;
  GLUT_RIGHT_BUTTON               = 2;

  // Mouse button state.
  GLUT_DOWN                       = 0;
  GLUT_UP                         = 1;

  // function keys
  GLUT_KEY_F1                     = 1;
  GLUT_KEY_F2                     = 2;
  GLUT_KEY_F3                     = 3;
  GLUT_KEY_F4                     = 4;
  GLUT_KEY_F5                     = 5;
  GLUT_KEY_F6                     = 6;
  GLUT_KEY_F7                     = 7;
  GLUT_KEY_F8                     = 8;
  GLUT_KEY_F9                     = 9;
  GLUT_KEY_F10                    = 10;
  GLUT_KEY_F11                    = 11;
  GLUT_KEY_F12                    = 12;
  // directional keys
  GLUT_KEY_LEFT                   = 100;
  GLUT_KEY_UP                     = 101;
  GLUT_KEY_RIGHT                  = 102;
  GLUT_KEY_DOWN                   = 103;
  GLUT_KEY_PAGE_UP                = 104;
  GLUT_KEY_PAGE_DOWN              = 105;
  GLUT_KEY_HOME                   = 106;
  GLUT_KEY_END                    = 107;
  GLUT_KEY_INSERT                 = 108;

  // Entry/exit  state.
  GLUT_LEFT                       = 0;
  GLUT_ENTERED                    = 1;

  // Menu usage state.
  GLUT_MENU_NOT_IN_USE            = 0;
  GLUT_MENU_IN_USE                = 1;

  // Visibility  state.
  GLUT_NOT_VISIBLE                = 0;
  GLUT_VISIBLE                    = 1;

  // Window status  state.
  GLUT_HIDDEN                     = 0;
  GLUT_FULLY_RETAINED             = 1;
  GLUT_PARTIALLY_RETAINED         = 2;
  GLUT_FULLY_COVERED              = 3;

  // Color index component selection values.
  GLUT_RED                        = 0;
  GLUT_GREEN                      = 1;
  GLUT_BLUE                       = 2;

  // Layers for use.
  GLUT_NORMAL                     = 0;
  GLUT_OVERLAY                    = 1;

  // Stroke font constants (use these in GLUT program).
  GLUT_STROKE_ROMAN		  = Pointer(0);
  GLUT_STROKE_MONO_ROMAN	  = Pointer(1);

  // Bitmap font constants (use these in GLUT program).
  GLUT_BITMAP_9_BY_15		  = Pointer(2);
  GLUT_BITMAP_8_BY_13		  = Pointer(3);
  GLUT_BITMAP_TIMES_ROMAN_10	  = Pointer(4);
  GLUT_BITMAP_TIMES_ROMAN_24	  = Pointer(5);
  GLUT_BITMAP_HELVETICA_10	  = Pointer(6);
  GLUT_BITMAP_HELVETICA_12	  = Pointer(7);
  GLUT_BITMAP_HELVETICA_18	  = Pointer(8);

  // glutGet parameters.
  GLUT_WINDOW_X                   = 100;
  GLUT_WINDOW_Y                   = 101;
  GLUT_WINDOW_WIDTH               = 102;
  GLUT_WINDOW_HEIGHT              = 103;
  GLUT_WINDOW_BUFFER_SIZE         = 104;
  GLUT_WINDOW_STENCIL_SIZE        = 105;
  GLUT_WINDOW_DEPTH_SIZE          = 106;
  GLUT_WINDOW_RED_SIZE            = 107;
  GLUT_WINDOW_GREEN_SIZE          = 108;
  GLUT_WINDOW_BLUE_SIZE           = 109;
  GLUT_WINDOW_ALPHA_SIZE          = 110;
  GLUT_WINDOW_ACCUM_RED_SIZE      = 111;
  GLUT_WINDOW_ACCUM_GREEN_SIZE    = 112;
  GLUT_WINDOW_ACCUM_BLUE_SIZE     = 113;
  GLUT_WINDOW_ACCUM_ALPHA_SIZE    = 114;
  GLUT_WINDOW_DOUBLEBUFFER        = 115;
  GLUT_WINDOW_RGBA                = 116;
  GLUT_WINDOW_PARENT              = 117;
  GLUT_WINDOW_NUM_CHILDREN        = 118;
  GLUT_WINDOW_COLORMAP_SIZE       = 119;
  GLUT_WINDOW_NUM_SAMPLES         = 120;
  GLUT_WINDOW_STEREO              = 121;
  GLUT_WINDOW_CURSOR              = 122;
  GLUT_SCREEN_WIDTH               = 200;
  GLUT_SCREEN_HEIGHT              = 201;
  GLUT_SCREEN_WIDTH_MM            = 202;
  GLUT_SCREEN_HEIGHT_MM           = 203;
  GLUT_MENU_NUM_ITEMS             = 300;
  GLUT_DISPLAY_MODE_POSSIBLE      = 400;
  GLUT_INIT_WINDOW_X              = 500;
  GLUT_INIT_WINDOW_Y              = 501;
  GLUT_INIT_WINDOW_WIDTH          = 502;
  GLUT_INIT_WINDOW_HEIGHT         = 503;
  GLUT_INIT_DISPLAY_MODE          = 504;
  GLUT_ELAPSED_TIME               = 700;

  // glutDeviceGet parameters.
  GLUT_HAS_KEYBOARD               = 600;
  GLUT_HAS_MOUSE                  = 601;
  GLUT_HAS_SPACEBALL              = 602;
  GLUT_HAS_DIAL_AND_BUTTON_BOX    = 603;
  GLUT_HAS_TABLET                 = 604;
  GLUT_NUM_MOUSE_BUTTONS          = 605;
  GLUT_NUM_SPACEBALL_BUTTONS      = 606;
  GLUT_NUM_BUTTON_BOX_BUTTONS     = 607;
  GLUT_NUM_DIALS                  = 608;
  GLUT_NUM_TABLET_BUTTONS         = 609;

  // glutLayerGet parameters.
  GLUT_OVERLAY_POSSIBLE           = 800;
  GLUT_LAYER_IN_USE               = 801;
  GLUT_HAS_OVERLAY                = 802;
  GLUT_TRANSPARENT_INDEX          = 803;
  GLUT_NORMAL_DAMAGED             = 804;
  GLUT_OVERLAY_DAMAGED            = 805;

  // glutVideoResizeGet parameters.
  GLUT_VIDEO_RESIZE_POSSIBLE       = 900;
  GLUT_VIDEO_RESIZE_IN_USE         = 901;
  GLUT_VIDEO_RESIZE_X_DELTA        = 902;
  GLUT_VIDEO_RESIZE_Y_DELTA        = 903;
  GLUT_VIDEO_RESIZE_WIDTH_DELTA    = 904;
  GLUT_VIDEO_RESIZE_HEIGHT_DELTA   = 905;
  GLUT_VIDEO_RESIZE_X              = 906;
  GLUT_VIDEO_RESIZE_Y              = 907;
  GLUT_VIDEO_RESIZE_WIDTH          = 908;
  GLUT_VIDEO_RESIZE_HEIGHT         = 909;

  // glutGetModifiers return mask.
  GLUT_ACTIVE_SHIFT                = 1;
  GLUT_ACTIVE_CTRL                 = 2;
  GLUT_ACTIVE_ALT                  = 4;

  // glutSetCursor parameters.
  // Basic arrows.
  GLUT_CURSOR_RIGHT_ARROW          = 0;
  GLUT_CURSOR_LEFT_ARROW           = 1;
  // Symbolic cursor shapes.
  GLUT_CURSOR_INFO                 = 2;
  GLUT_CURSOR_DESTROY              = 3;
  GLUT_CURSOR_HELP                 = 4;
  GLUT_CURSOR_CYCLE                = 5;
  GLUT_CURSOR_SPRAY                = 6;
  GLUT_CURSOR_WAIT                 = 7;
  GLUT_CURSOR_TEXT                 = 8;
  GLUT_CURSOR_CROSSHAIR            = 9;
  // Directional cursors.
  GLUT_CURSOR_UP_DOWN              = 10;
  GLUT_CURSOR_LEFT_RIGHT           = 11;
  // Sizing cursors.
  GLUT_CURSOR_TOP_SIDE             = 12;
  GLUT_CURSOR_BOTTOM_SIDE          = 13;
  GLUT_CURSOR_LEFT_SIDE            = 14;
  GLUT_CURSOR_RIGHT_SIDE           = 15;
  GLUT_CURSOR_TOP_LEFT_CORNER      = 16;
  GLUT_CURSOR_TOP_RIGHT_CORNER     = 17;
  GLUT_CURSOR_BOTTOM_RIGHT_CORNER  = 18;
  GLUT_CURSOR_BOTTOM_LEFT_CORNER   = 19;
  // Inherit from parent window.
  GLUT_CURSOR_INHERIT              = 100;
  // Blank cursor.
  GLUT_CURSOR_NONE                 = 101;
  // Fullscreen crosshair (if available).
  GLUT_CURSOR_FULL_CROSSHAIR       = 102;

  // GLUT initialization sub-API.
  procedure glutInit(argcp: PInteger; argv: PPChar); stdcall; external GLUTDLL;
  procedure glutInitDisplayMode(mode: Word); stdcall; external GLUTDLL;
  procedure glutInitDisplayString(const str: PChar); stdcall; external GLUTDLL;
  procedure glutInitWindowPosition(x, y: Integer); stdcall; external GLUTDLL;
  procedure glutInitWindowSize(width, height: Integer); stdcall; external GLUTDLL;
  procedure glutMainLoop; stdcall; external GLUTDLL;

  // GLUT window sub-API.
  function glutCreateWindow(const title: PChar): Integer; stdcall; external GLUTDLL;
  function glutCreateSubWindow(win, x, y, width, height: Integer): Integer; stdcall; external GLUTDLL;
  procedure glutDestroyWindow(win: Integer); stdcall; external GLUTDLL;
  procedure glutPostRedisplay; stdcall; external GLUTDLL;
  procedure glutPostWindowRedisplay(win: Integer); stdcall; external GLUTDLL;
  procedure glutSwapBuffers; stdcall; external GLUTDLL;
  function glutGetWindow: Integer; stdcall; external GLUTDLL;
  procedure glutSetWindow(win: Integer); stdcall; external GLUTDLL;
  procedure glutSetWindowTitle(const title: PChar); stdcall; external GLUTDLL;
  procedure glutSetIconTitle(const title: PChar); stdcall; external GLUTDLL;
  procedure glutPositionWindow(x, y: Integer); stdcall; external GLUTDLL;
  procedure glutReshapeWindow(width, height: Integer); stdcall; external GLUTDLL;
  procedure glutPopWindow; stdcall; external GLUTDLL;
  procedure glutPushWindow; stdcall; external GLUTDLL;
  procedure glutIconifyWindow; stdcall; external GLUTDLL;
  procedure glutShowWindow; stdcall; external GLUTDLL;
  procedure glutHideWindow; stdcall; external GLUTDLL;
  procedure glutFullScreen; stdcall; external GLUTDLL;
  procedure glutSetCursor(cursor: Integer); stdcall; external GLUTDLL;
  procedure glutWarpPointer(x, y: Integer); stdcall; external GLUTDLL;

  // GLUT overlay sub-API.
  procedure glutEstablishOverlay; stdcall; external GLUTDLL;
  procedure glutRemoveOverlay; stdcall; external GLUTDLL;
  procedure glutUseLayer(layer: GLenum); stdcall; external GLUTDLL;
  procedure glutPostOverlayRedisplay; stdcall; external GLUTDLL;
  procedure glutPostWindowOverlayRedisplay(win: Integer); stdcall; external GLUTDLL;
  procedure glutShowOverlay; stdcall; external GLUTDLL;
  procedure glutHideOverlay; stdcall; external GLUTDLL;

  // GLUT menu sub-API.
  function glutCreateMenu(callback: TGlut1IntCallback): Integer; stdcall; external GLUTDLL;
  procedure glutDestroyMenu(menu: Integer); stdcall; external GLUTDLL;
  function glutGetMenu: Integer; stdcall; external GLUTDLL;
  procedure glutSetMenu(menu: Integer); stdcall; external GLUTDLL;
  procedure glutAddMenuEntry(const caption: PChar; value: Integer); stdcall; external GLUTDLL;
  procedure glutAddSubMenu(const caption: PChar; submenu: Integer); stdcall; external GLUTDLL;
  procedure glutChangeToMenuEntry(item: Integer; const caption: PChar; value: Integer); stdcall; external GLUTDLL;
  procedure glutChangeToSubMenu(item: Integer; const caption: PChar; submenu: Integer); stdcall; external GLUTDLL;
  procedure glutRemoveMenuItem(item: Integer); stdcall; external GLUTDLL;
  procedure glutAttachMenu(button: Integer); stdcall; external GLUTDLL;
  procedure glutDetachMenu(button: Integer); stdcall; external GLUTDLL;

  // GLUT  sub-API.
  procedure glutDisplayFunc(f: TGlutVoidCallback); stdcall; external GLUTDLL;
  procedure glutReshapeFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutKeyboardFunc(f: TGlut1Char2IntCallback); stdcall; external GLUTDLL;
  procedure glutMouseFunc(f: TGlut4IntCallback); stdcall; external GLUTDLL;
  procedure glutMotionFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutPassiveMotionFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutEntryFunc(f: TGlut1IntCallback); stdcall; external GLUTDLL;
  procedure glutVisibilityFunc(f: TGlut1IntCallback); stdcall; external GLUTDLL;
  procedure glutIdleFunc(f: TGlutVoidCallback); stdcall; external GLUTDLL;
  procedure glutTimerFunc(millis: Word; f: TGlut1IntCallback; value: Integer); stdcall; external GLUTDLL;
  procedure glutMenuStateFunc(f: TGlut1IntCallback); stdcall; external GLUTDLL;
  procedure glutSpecialFunc(f: TGlut3IntCallback); stdcall; external GLUTDLL;
  procedure glutSpaceballMotionFunc(f: TGlut3IntCallback); stdcall; external GLUTDLL;
  procedure glutSpaceballRotateFunc(f: TGlut3IntCallback); stdcall; external GLUTDLL;
  procedure glutSpaceballButtonFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutButtonBoxFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutDialsFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutTabletMotionFunc(f: TGlut2IntCallback); stdcall; external GLUTDLL;
  procedure glutTabletButtonFunc(f: TGlut4IntCallback); stdcall; external GLUTDLL;
  procedure glutMenuStatusFunc(f: TGlut3IntCallback); stdcall; external GLUTDLL;
  procedure glutOverlayDisplayFunc(f:TGlutVoidCallback); stdcall; external GLUTDLL;
  procedure glutWindowStatusFunc(f: TGlut1IntCallback); stdcall; external GLUTDLL;

  // GLUT color index sub-API.
  procedure glutSetColor(cell: Integer; red, green, blue: GLfloat); stdcall; external GLUTDLL;
  function glutGetColor(ndx, component: Integer): GLfloat; stdcall; external GLUTDLL;
  procedure glutCopyColormap(win: Integer); stdcall; external GLUTDLL;

  // GLUT state retrieval sub-API.
  function glutGet(t: GLenum): Integer; stdcall; external GLUTDLL;
  function glutDeviceGet(t: GLenum): Integer; stdcall; external GLUTDLL;
  // GLUT extension support sub-API
  function glutExtensionSupported(const name: PChar): Integer; stdcall; external GLUTDLL;
  function glutGetModifiers: Integer; stdcall; external GLUTDLL;
  function glutLayerGet(t: GLenum): Integer; stdcall; external GLUTDLL;

  // GLUT font sub-API
  procedure glutBitmapCharacter(font, character: Integer); stdcall; external GLUTDLL;
  function glutBitmapWidth(font, character: Integer): Integer; stdcall; external GLUTDLL;
  procedure glutStrokeCharacter(font, character: Integer); stdcall; external GLUTDLL;
  function glutStrokeWidth(font, character: Integer): Integer; stdcall; external GLUTDLL;
  function glutBitmapLength(font: Integer; const str: PChar): Integer; stdcall; external GLUTDLL;
  function glutStrokeLength(font: Integer; const str: PChar): Integer; stdcall; external GLUTDLL;

  // GLUT pre-built models sub-API
  procedure glutWireSphere(radius: GLdouble; slices, stacks: GLint); stdcall; external GLUTDLL;
  procedure glutSolidSphere(radius: GLdouble; slices, stacks: GLint); stdcall; external GLUTDLL;
  procedure glutWireCone(base, height: GLdouble; slices, stacks: GLint); stdcall; external GLUTDLL;
  procedure glutSolidCone(base, height: GLdouble; slices, stacks: GLint); stdcall; external GLUTDLL;
  procedure glutWireCube(size: GLdouble); stdcall; external GLUTDLL;
  procedure glutSolidCube(size: GLdouble); stdcall; external GLUTDLL;
  procedure glutWireTorus(innerRadius, outerRadius: GLdouble; sides, rings: GLint); stdcall; external GLUTDLL;
  procedure glutSolidTorus(innerRadius, outerRadius: GLdouble; sides, rings: GLint); stdcall; external GLUTDLL;
  procedure glutWireDodecahedron; stdcall; external GLUTDLL;
  procedure glutSolidDodecahedron; stdcall; external GLUTDLL;
  procedure glutWireTeapot(size: GLdouble); stdcall; external GLUTDLL;
  procedure glutSolidTeapot(size: GLdouble); stdcall; external GLUTDLL;
  procedure glutWireOctahedron; stdcall; external GLUTDLL;
  procedure glutSolidOctahedron; stdcall; external GLUTDLL;
  procedure glutWireTetrahedron; stdcall; external GLUTDLL;
  procedure glutSolidTetrahedron; stdcall; external GLUTDLL;
  procedure glutWireIcosahedron; stdcall; external GLUTDLL;
  procedure glutSolidIcosahedron; stdcall; external GLUTDLL;

  // GLUT video resize sub-API.
  function glutVideoResizeGet(param: GLenum): Integer; stdcall; external GLUTDLL;
  procedure glutSetupVideoResizing; stdcall; external GLUTDLL;
  procedure glutStopVideoResizing; stdcall; external GLUTDLL;
  procedure glutVideoResize(x, y, width, height: Integer); stdcall; external GLUTDLL;
  procedure glutVideoPan(x, y, width, height: Integer); stdcall; external GLUTDLL;

  // GLUT debugging sub-API.
  procedure glutReportErrors; stdcall; external GLUTDLL;

implementation

end.
