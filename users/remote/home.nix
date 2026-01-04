{ pkgs, ... }:
{
  imports = [
    ../../home/core.nix

    #../../home/hyprland
    #../../home/waybar
    ../../home/kitty
    ../../home/programs
    ../../home/rofi
    ../../home/shell
    ../../home/neovim
    ../../home/helix
    ../../home/vscodium
    #../../home/gnome
  ];

  programs.git.settings = {
    user.name = "AmbitiousNOP";
  };

}
