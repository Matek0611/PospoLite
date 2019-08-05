unit Pospolite.Radials.RegisterAll;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PospoLite.Menus.Radial, PropEdits, typinfo, LResources,
  ComponentEditors;

procedure Register;

implementation

procedure UnlistPublishedProperty(ComponentClass: TPersistentClass; const PropertyName: String);
var
  pi: PPropInfo;
begin
  pi := TypInfo.GetPropInfo(ComponentClass, PropertyName);
  if (pi <> nil) then
    RegisterPropertyEditor(pi^.PropType, ComponentClass, PropertyName, PropEdits.THiddenPropertyEditor);
end;

procedure Register;
begin
  {$i plxradials.lrs}
  RegisterComponents('PospoLite', [TplxRadialMenu]);
  RegisterComponentEditor(TplxRadialMenu, TDefaultComponentEditor);

  UnlistPublishedProperty(TplxRadialMenu, 'Alignment');
  UnlistPublishedProperty(TplxRadialMenu, 'AutoPopup');
  UnlistPublishedProperty(TplxRadialMenu, 'BidiMode');
  UnlistPublishedProperty(TplxRadialMenu, 'ImagesWidth');
  UnlistPublishedProperty(TplxRadialMenu, 'OwnerDraw');
  UnlistPublishedProperty(TplxRadialMenu, 'ParentBidiMode');
  UnlistPublishedProperty(TplxRadialMenu, 'TrackButton');
  UnlistPublishedProperty(TplxRadialMenu, 'OnDrawItem');
  UnlistPublishedProperty(TplxRadialMenu, 'OnMeasureItem');
end;

end.

