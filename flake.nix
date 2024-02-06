{
  description = "My machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
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
    devshell.url = "github:numtide/devshell";
  };

  outputs = {self, ...} @ inputs:
    with inputs; let
      #pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
      sysPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = false;
          overlays = [
            (_: _: {
              go-home = go-home.packages.${system}.default;
              zigbee2mqtt =
                nixpkgs-unstable.legacyPackages."${system}".zigbee2mqtt;
            })
          ];
        };

      lib = nixpkgs.lib;
    in {
      # Home configuration
      homeConfigurations = {
        wsl = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable {
            config = {
              allowUnfree = true;
              users.users."jacob".shell = pkgs.zsh;
            };
            system = "x86_64-linux";
          };
          modules = [./home ./home/workstation.nix];
        };
      };

      # devshell configuration
      devShells."x86_64-linux".default = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [devshell.overlays.default];
        };
      in
        pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };
      # formatter settings
      formatter."x86_64-linux" = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      # server confoguration
      nixosConfigurations = {
        vpsfree = lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = sysPkgs "x86_64-linux";
          # Make inputs accessible ad module parameters
          specialArgs = {flake-self = self;} // inputs;
          modules = [
            machines/cml-jpr-net/configuration.nix
            agenix.nixosModules.default # agenix module
            {
              environment.systemPackages = [agenix.packages.${system}.default]; # agenix cli
            }
          ];
        };

        rpi = lib.nixosSystem rec {
          system = "aarch64-linux";
          pkgs = sysPkgs "aarch64-linux";
          # Make inputs accessible ad module parameters
          specialArgs = {flake-self = self;} // inputs;
          modules = [
            machines/home-gw/configuration.nix
            agenix.nixosModules.default # agenix module
            {
              environment.systemPackages = [agenix.packages.${system}.default]; # agenix cli
            }
          ];
        };
      };
    };
}
