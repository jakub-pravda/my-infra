{
  description = "My machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    jacob-keys = {
      url = "https://github.com/jakub-pravda.keys";
      flake = false;
    };
    
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
    with inputs;
    let
      pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
      sysPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = false;
        overlays = [
          (_: _: { 
            go-home = go-home.packages.${system}.default; 
          })
        ];
      };

      lib = nixpkgs.lib;
    in {
      # home-manager configuration
      homeConfigurations.jacob = home-manager.lib.homeManagerConfiguration {
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
          # Make inputs accessible ad module parameters
          specialArgs = { flake-self = self; } // inputs;
          modules = [
            machines/cml-jpr-net/configuration.nix
          ];
        };

        rpi = lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = sysPkgs "aarch64-linux";
          # Make inputs accessible ad module parameters
          specialArgs = { flake-self = self; } // inputs;
          modules = [
            machines/home-gw/configuration.nix
          ];
        };
      };
    };
}