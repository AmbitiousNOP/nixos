{
  config,
  lib,
  pkgs,
  ...
}:

{
  # P14s is a rebadged T14 with slight internal differences.
  # This may change for future models, so we duplicate the T14 hierarchy here.

  imports = [
    ../.
    ../../common/pc/ssd
    ../../common/system.nix
  ];

  # Force use of the amdgpu driver for backlight control on kernel versions where the
  # native backlight driver is not already preferred. This is preferred over the
  # "vendor" setting, in this case the thinkpad_acpi driver.
  # See https://hansdegoede.livejournal.com/27130.html
  # See https://lore.kernel.org/linux-acpi/20221105145258.12700-1-hdegoede@redhat.com/
  #boot.kernelParams = lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.2") [
  #  "acpi_backlight=native"
  #];
  boot.kernelParams = [ "i915.force_probe=7d55" ];

  # Bootloader
  # see https://github.com/NixOS/nixpkgs/issues/69289
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.2") pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5de541ce-d74e-434b-808d-07c4a9497ee3";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/298A-6C81";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/19b2f757-2ad4-4a07-bbda-a59342413829"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";


}
