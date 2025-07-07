{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprland
    waybar
    kitty
    wofi
    dunst
    xdg-desktop-portal-hyprland
    rofi-wayland
    bluetui
    bluez-tools
    brightnessctl
    pkgs.nerd-fonts.jetbrains-mono
    lm_sensors
    hyprpaper
  ];

  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  services.dbus.enable = true;
  programs.dconf.enable = true;
}

