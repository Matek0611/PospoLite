{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit plRadials_laz;

{$warn 5023 off : no warning about unused units}
interface

uses
  PospoLite.Menus.Radial, Pospolite.Radials.RegisterAll, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Pospolite.Radials.RegisterAll', 
    @Pospolite.Radials.RegisterAll.Register);
end;

initialization
  RegisterPackage('plRadials_laz', @Register);
end.
