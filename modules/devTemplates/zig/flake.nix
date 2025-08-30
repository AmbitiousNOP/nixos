{
  description = "Zig dev env (master)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.zig = {
    url = "github:mitchellh/zig-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, zig, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs { inherit system; };
          zigMaster = zig.packages.${system}.master;  # <- no overlay needed
        }
      );
    in {
      devShells = forEachSystem ({ pkgs, zigMaster }: {
        default = pkgs.mkShell {
          packages = [
            zigMaster
            pkgs.zls
            pkgs.lldb
          ];
        };
      });
    };
}

