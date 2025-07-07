{pkgs, config, ...}:
{
  home.file.".config/kitty/current-theme.conf".source = ./current-theme.conf;
  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;

}
