{
  description = "My personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
	
  outputs = inputs@{ self, nixpkgs, home-manager,  ...}: {
    nixosConfigurations = {
      laptop = let
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
            ./hosts/laptop/p14s/default.nix
            ./users/${username}/nixos.nix
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
