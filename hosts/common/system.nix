{
  config,
  pkgs,
  lib,
  username,
  hostname,
  ...
}:

{
  # Enable a specific unfree software to be installed
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "cuda-merged"
      "cuda_cuobjdump"
      "cuda_sanitizer_api"
      "libnvjitlink"
      "cuda_gdb"
      "cuda_nvcc"
      "cuda_nvdisasm"
      "cuda_nvprune"
      "cuda_profiler_api"
      "cuda_cccl"
      "cuda_cupti"
      "cuda_cudart"
      "cuda_nvtx"
      "cuda_nvrtc"
      "cuda_nvml_dev"
      "cuda_cuxxfilt"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libcusparse"
      "libnpp"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "obsidian"
      "discord"
    ];

  # Enable exerpimental features globally
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.udev.enable = true;
  services.udev.packages = [ pkgs.zsa-udev-rules ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkForce false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ username ];

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    zsh
    vim
    wget
    #greetd.tuigreet
    wl-clipboard
    #libsForQt5.dolphin
    #tmux
    #adwaita-icon-theme
    btop
    nvtopPackages.full
    docker
  ];

  programs.steam = {
    enable = true;
  };

  specialisation = {
    gnome.configuration = {
      system.nixos.tags = [ "gnome" ];
      services.xserver.enable = true;
      #services.xserver.displayManager.gdm.enable = true;
      #services.xserver.desktopManager.gnome.enable = true;
      services.desktopManager.gnome.enable = true;
      services.displayManager.gdm.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.graphics.extraPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];

      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
      };

      home-manager.users.${username}.imports = [
        ../../home/gnome/default.nix
      ];

      environment.gnome.excludePackages = with pkgs; [
        gnome-weather
        gnome-photos
        gnome-tour
        gnome-maps
        gnome-music
        gnome-connections
        gnome-characters
        gnome-contacts
        gnome-calendar
        geary
        epiphany
        yelp
      ];
      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        gnome-tweaks
      ];

    };

    hyprland.configuration = {
      system.nixos.tags = [ "hyprland" ];
      home-manager.users.${username}.imports = [
        ../../home/hyprland/default.nix
        ../../home/waybar/default.nix
      ];

      programs.hyprland = {
        enable = true;
        withUWSM = true;
        # set the flake package
        #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        # make sure to also set the portal package, so that they are in sync
        #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      };
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.hyprland}/bin/Hyprland";
            user = "greeter";
          };
        };
      };
      environment.sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
      };
    };
  };

  #services.xserver.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  system.stateVersion = "25.05";
}
