{
  description = "My machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    devshell.url = "github:numtide/devshell";
    go-home.url = "github:jakub-pravda/go-home";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-infra-private = {
      url = "git+ssh://git@github.com/jakub-pravda/my-infra-private.git";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs:
    with inputs; let
      # system arch variables
      x86_64-linux = "x86_64-linux";
      aarch64-linux = "aarch64-linux";

      # packages definition
      desktopPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (_: _: {
              jetbrains =
                nixpkgs-unstable.legacyPackages."${system}".jetbrains;
            })
          ];
        };

      serverPkgs = system:
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

      # other
      lib = nixpkgs.lib;
    in {
      devShells.x86_64-linux.default = let
        pkgs = import nixpkgs {
          system = x86_64-linux;
          overlays = [devshell.overlays.default];
        };
      in
        pkgs.devshell.mkShell {
          imports = [(pkgs.devshell.importTOML ./devshell.toml)];
        };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      # Separate home configuration for non NixOs machines
      homeConfigurations = {
        wsl = home-manager.lib.homeManagerConfiguration {
          pkgs = desktopPkgs x86_64-linux;
          modules = [./home];
          extraSpecialArgs = {
            my-infra-private = my-infra-private;
            isWorkstation = true;
            isWsl = true;
          };
        };
      };

      nixosConfigurations = {
        # *** Workstations ***
        wheatley = lib.nixosSystem rec {
          system = x86_64-linux;
          pkgs = desktopPkgs system;
          specialArgs = {flake-self = self;} // inputs;
          modules = [
            machines/wheatley/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users.jacob = import ./home/default.nix;
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  my-infra-private = my-infra-private;
                  isWorkstation = true;
                  isWsl = false;
                };
              };
            }
          ];
        };

        # *** Servers ***
        vpsfree = lib.nixosSystem rec {
          system = x86_64-linux;
          pkgs = serverPkgs system;
          # Make inputs accessible ad module parameters
          specialArgs = {flake-self = self;} // inputs;
          modules = [
            machines/cml-jpr-net/configuration.nix
            agenix.nixosModules.default
            {
              environment.systemPackages = [agenix.packages.${system}.default]; # agenix cli
            }
          ];
        };

        home-hub = lib.nixosSystem rec {
          system = aarch64-linux;
          pkgs = serverPkgs system;
          # Make inputs accessible ad module parameters
          specialArgs = {flake-self = self;} // inputs;
          modules = [
            machines/home-hub/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users.jacob = import ./home/default.nix;
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  isWorkstation = false;
                  isWsl = false;
                };
              };
            }
          ];
        };
      };
    };
}
