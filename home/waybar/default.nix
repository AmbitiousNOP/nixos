{pkgs, config, ...}:
{
  home.file.".config/waybar/config.jsonc".source = ./config.jsonc;
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/theme.css".source = ./theme.css;
  home.file.".config/waybar/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
  home.file.".config/waybar/themes" = {
    source = ./themes;
    recursive = true;
  };

}
