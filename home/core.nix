{
  config,
  lib,
  pkgs,
  ...
}:
let
  username = config.home.username;
in
{
  home = {
    homeDirectory = lib.mkForce "/home/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
