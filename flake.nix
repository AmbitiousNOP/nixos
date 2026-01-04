{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }:
    {
      nixosConfigurations = {
        laptop =
          let
            username = "user";
            hostname = "laptop";
            specialArgs = {
              inherit username;
              inherit hostname;
            };
          in
          nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
              ./hosts/thinkpad/p14s/hardware-configuration.nix
              ./hosts/common/system.nix
              nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen5
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-gpu-intel
              nixos-hardware.nixosModules.common-gpu-nvidia
              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-laptop-ssd

              ./users/${username}/nixos.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.extraSpecialArgs = inputs // specialArgs;
                home-manager.users.${username} = import ./users/${username}/home.nix;
                home-manager.users.remote = import ./users/remote/home.nix;
              }
            ];
          };
      };
    };
}
