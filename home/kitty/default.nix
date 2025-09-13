{pkgs, config, ...}:
{

  programs.kitty = {
    enable = true;
  };
  
  #home.file = {
  #  theme = {source = ./current-theme.conf; target = ".config/kitty/current-theme.conf";};
  #  config = {source = ./kitty.conf; target = ".config/kitty/kitty.conf";};
  #};

  #home.file.".config/kitty/current-theme.conf".source = ./current-theme.conf;
  #home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
  


}
