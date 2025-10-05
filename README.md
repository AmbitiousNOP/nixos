My personalized NixOS files.


swap between `gnome` and `hyprland` with:
```
sudo nixos-rebuild switch --flake .#laptop --specialisation <hyprland or gnome>
```

getting steam to use NVIDIA GPU and not Intel's iGPU:
- Launcher steam --> Open a Game's page --> Click settings icon -> Properies --> Launch Options:
```
__GLX_VENDOR_LIBRARY_NAME=nvidia %command%

```
if `%command%` is left out, steam will pass the variable as a command line argument when calling the game. 
