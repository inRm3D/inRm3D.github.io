program inRm3D;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  , Interfaces,
{$ENDIF}
  Forms,
  LCLIntf, LCLType, LMessages,
  inRm3Dunit in 'inRm3Dunit.pas' {frmMain},
  DArrays in 'cgLib\DArrays.pas',
  CgUtils in 'cglib\CgUtils.pas',
  CgTypes in 'cglib\CgTypes.pas',
  Express in 'cgLib\Express.pas',
  GLut in 'cglib\GLut.pas',
  GLu in 'cglib\GLu.pas',
  GL in 'cglib\GL.pas',
  BMP in 'cgLib\BMP.pas',
  pars in 'cgLib\pars.pas',
  build in 'cgLib\build.pas',
  Splash in 'SubUnit\Splash.pas' {frmSplash},
  parsglb in 'cgLib\parsglb.pas',
  GIFimage in 'cgLib\GIFimage.pas',
  DragImage in 'SubUnit\DragImage.pas',
  CgGeometry in 'cgLib\CgGeometry.pas',
  PNGimage in 'cgLib\PNGimage1.5\PNGimage.pas',
  PNGzlib in 'cgLib\PNGimage1.5\PNGzlib.pas',
  PNGlang in 'cgLib\PNGimage1.5\PNGlang.pas';

{$R *.res}
{$R Hand_C.res} //光标
begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDrag, frmDrag);
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.Run;
end.
