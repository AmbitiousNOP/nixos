{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./modules/default.nix
    #./modules/modules.nix
  ];

  programs.neovim = {
    enable = true;
  };

  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
  ];
}
