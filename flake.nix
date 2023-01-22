{
  description = "Infrastructure builder";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    
    go-home = {
      url = "github:jakub-pravda/go-home";
      #follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      sysPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (_: _: { go-home = inputs.go-home.packages.${system}.default; })
        ];
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = rec {
        vpsfree = lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = sysPkgs "x86_64-linux";
          modules = [
            machines/cml-jpr-net/configuration.nix
          ];
        };

        rpi = lib.nixosSystem rec {
          system = "aarch64-linux";
          pkgs = sysPkgs "aarch64-linux";
          modules = [
            machines/home-gw/configuration.nix
          ];
        };
      };
    };
}