{lib, pkgs, ...}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip

    #utils
    gcc
    libusb1

    # gui
    gtk3

    # github cli
    gh

    # streaming
    obs-studio

    # apps
    anki-bin
  ];



}
