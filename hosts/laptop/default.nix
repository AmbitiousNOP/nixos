{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../modules/system.nix
      ./hardware/hardware-configuration.nix
      ../../modules/hyprland.nix
    ];
	
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}
