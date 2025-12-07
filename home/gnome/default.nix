{ pkgs, config, ... }:

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          #pkgs.gnomeExtensions.dock-from-dash
          "dash-to-dock@michele_g"
        ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "LEFT";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/user/.local/share/backgrounds/2025-09-16-19-56-43-nix-dark.png";
        picture-uri-dark = "file:///home/user/.local/share/backgrounds/2025-09-16-19-56-43-nix-dark.png";
      };
    };
  };
}
