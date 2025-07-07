{
  pkgs,
  config,
  ...
}:
{
  home.file.".config/rofi/bluetooth-menu.rasi".source = ./bluetooth-menu.rasi;
  home.file.".config/rofi/theme.rasi".source = ./theme.rasi;
  home.file.".config/rofi/wifi-menu.rasi".source = ./wifi-menu.rasi;
  home.file.".config/rofi/power-menu.rasi".source = ./power-menu.rasi;
  home.file.".config/rofi/themes" = {
    source = ./themes;
    recursive = true;
  };

}
