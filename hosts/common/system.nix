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

  # auto update
  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "600";
    operation = "switch";
  };

  # clean old deployments
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  security.sudo.execWheelOnly = true;
  security.auditd.enable = true;
  security.audit.enable = true;
  security.protectKernelImage = true;

  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  services.openssh = {
    passwordAuthentication = false;
    allowSFTP = false;
    challengeResponseAuthentication = false;
    extraConfig = ''
      			AllowTcpForwarding yes
      			X11Forwarding no 
      			AllowAgentForwarding no 
      			AllowStreamLocalForwarding no 
      			AuthenticationMethods publickey
      		'';
  };

  services.udev.enable = true;
  services.udev.packages = [
    pkgs.zsa-udev-rules
    pkgs.yubikey-personalization
  ];
  services.udev.extraRules = ''
    	ACTION=="remove",\
        	ENV{ID_BUS}=="usb",\
            ENV{ID_MODEL_ID}=="0407",\
            ENV{ID_VENDOR_ID}=="1050",\
            ENV{ID_VENDOR}=="Yubico",\
            RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  security.pam.u2f = {
    enable = true;
    control = "required";
    settings = {
      interactive = true;
      cue = true;
    };
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    xrdp-sesman.u2fAuth = true;
  };

  networking.hostName = hostname;
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
  #networking.networkmanager.dns = "dnsmasq";
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  networking.networkmanager = {
    ethernet.macAddress = "stable";
    wifi.macAddress = "random";
  };
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  #services.dnsmasq = {
  #enable = true;
  #settings = {
  #  server = [
  #    "/internal/192.168.49.2"
  #    "1.1.1.1"
  #  ];
  #};
  #};

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkForce false;

  boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = "1";
  boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = true;
  boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = "1";

  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = true;

  boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = false;
  boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = false;

  boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = false;
  boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = false;

  # Set time zone.
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
  nix.settings.allowed-users = [ "@wheel" ];
  virtualisation.docker.enable = true;

  users.users.remote = {
    isNormalUser = true;
    description = "Remote user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "docker"
    ];
    shell = pkgs.zsh;
  };

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
      services.desktopManager.gnome.enable = true;
      services.displayManager.gdm.enable = true;

      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "xfce4-session";
      services.xserver.desktopManager.xfce.enable = true;
      services.gnome.gnome-remote-desktop.enable = true;

      #systemd.services.gnome-remote-desktop = {
      #wantedBy = [ "graphical.target" ];
      #};
      networking.firewall.interfaces.enp0s31f6.allowedTCPPorts = [ 3389 ];
      networking.firewall.allowedTCPPorts = [ ];

      services.displayManager.autoLogin.enable = false;
      services.getty.autologinUser = null;

      systemd.targets.sleep.enable = false;
      systemd.targets.suspend.enable = false;
      systemd.targets.hibernate.enable = false;
      systemd.targets.hybrid-sleep.enable = false;

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
        xfce.xfce4-session
        xfce.xfce4-panel
        xfce.xfce4-terminal
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
