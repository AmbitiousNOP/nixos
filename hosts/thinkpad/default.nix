{ config, lib, ... }:

{
  imports = [ ../common/pc/laptop ];
  hardware.trackpoint.enable = lib.mkDefault true;
  hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;
}
