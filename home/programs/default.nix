{config, lib, pkgs, ...}:
{
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./unfree.nix
  ];
}
