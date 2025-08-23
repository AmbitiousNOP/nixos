{pkgs, lib, ...}:{
  home.packages = with pkgs; [
    keymapp
    wally-cli
    obsidian
  ];

}
