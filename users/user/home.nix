{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    
    ../../home/hyprland
    ../../home/waybar
    ../../home/kitty
    ../../home/programs
    ../../home/rofi
    ../../home/shell
    ../../home/neovim
  ];

  programs.git = {
    userName = "AmbitiousNOP";
    userEmail = "cjpenn7@icloud.com";
  };

}
