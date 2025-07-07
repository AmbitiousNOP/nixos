{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
	
  outputs = inputs@{ self, nixpkgs, hyprland, home-manager,  ...}: {
    nixosConfigurations = {
      laptop = let
        username = "user";
        specialArgs = {inherit username;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
        
          modules = [
            ./hosts/laptop/default.nix
            ./users/${username}/nixos.nix
	    hyprland.nixosModules.default
	    { programs.hyprland.enable = true; }
            home-manager.nixosModules.home-manager{
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }	  
          ];
        };
    };
  };
}
