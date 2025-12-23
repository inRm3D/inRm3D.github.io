unit Tabs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLType, Types, Controls, ComCtrls;

type
  { Lightweight replacement for the VCL TTabSet used by the project.
    It simply subclasses the LCL TTabControl and exposes helpers that
    mimic the API pieces the existing code relies on. }
  TTabSet = class(TTabControl)
  private
    function GetFirstIndex: Integer;
  public
    function ItemWidth(Index: Integer): Integer;
    property FirstIndex: Integer read GetFirstIndex;
  end;

implementation

function TTabSet.GetFirstIndex: Integer;
var
  I: Integer;
  R: TRect;
begin
  Result := 0;
  for I := 0 to Tabs.Count - 1 do
  begin
    R := TabRect(I);
    if (R.Left >= 0) or (I = Tabs.Count - 1) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TTabSet.ItemWidth(Index: Integer): Integer;
var
  R: TRect;
begin
  Result := 0;
  if (Index < 0) or (Index >= Tabs.Count) then
    Exit;
  R := TabRect(Index);
  if (R.Right > R.Left) then
    Result := R.Right - R.Left
  else
    Result := 16 + Length(Tabs[Index]) * 8;
end;

end.
