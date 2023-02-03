{
  description = "My machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    go-home = {
      url = "github:jakub-pravda/go-home";
      #follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... }@inputs:
    let
      pkgs = inputs.nixpkgs-unstable.legacyPackages."x86_64-linux";
      sysPkgs = system: import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = false;
        overlays = [
          (_: _: { go-home = inputs.go-home.packages.${system}.default; })
        ];
      };

      lib = inputs.nixpkgs.lib;
    in {
      # home-manager configuration
      homeConfigurations.jacob = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home-manager
        ];
      };
      
      devShells."x86_64-linux".default = pkgs.mkShell { 
        buildInputs = [ pkgs.cowsay ]; 
      };

      # server confoguration
      nixosConfigurations = {
        vpsfree = lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = sysPkgs "x86_64-linux";
          modules = [
            machines/cml-jpr-net/configuration.nix
          ];
        };

        rpi = lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = sysPkgs "aarch64-linux";
          modules = [
            machines/home-gw/configuration.nix
          ];
        };
      };
    };
}