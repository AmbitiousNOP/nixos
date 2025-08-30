{lib, pkgs, ...}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip

    #utils
    gcc
    libusb1
    lshw

    # gui
    gtk3

    # github cli
    gh

    # google cloud sdk
    google-cloud-sdk

    # streaming
    obs-studio

    # apps
    anki-bin
    #zed-editor
    #helix
  ];



}
