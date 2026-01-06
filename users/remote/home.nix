{ config, pkgs, ... }:
{
  home.username = "remote";
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
    user.email = "dev@ambitiousnop.computer";
    signing = {
      signByDefault = true;
      key = "457EA42E44D2D8C0";
    };
    extraConfig = {
      gpg = {
        program = "${pkgs.gnupg}/bin/gpg";
        format = "openpgp";
      };
      commit = {
        gpgsign = true;
      };
      tag = {
        gpgsign = true;
      };
    };
  };
}
