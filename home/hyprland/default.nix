{pkgs, config, ...}: {

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  home.file.".config/hypr/wallpaper" = {
      source = ./wallpaper;
      recursive = true;
    };

}
