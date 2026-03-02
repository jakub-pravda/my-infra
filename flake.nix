{
  description = "My machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-my.url = "github:jakub-pravda/nixpkgs/shadow-pc";

    go-home.url = "github:jakub-pravda/go-home";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, ... }@inputs:
    with inputs;
    let
      # system arch variables
      x86_64-linux = "x86_64-linux";
      aarch64-linux = "aarch64-linux";

      supportedSystems = [ x86_64-linux aarch64-linux ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });

      # Packages definition

      # remark: myPkgs are here to test shadow-pc package
      myPkgs = system:
        import nixpkgs-my {
          inherit system;
          # Allow unfree packages (shadow pc)
          config.allowUnfree = true;
        };

      desktopPkgs = system: pkgs:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ (_: _: { inherit ((myPkgs system)) shadow-launcher; }) ];
        };

      serverPkgs = system: pkgs:
        import pkgs {
          inherit system;
          config.allowUnfree = false;
          overlays = [
            (_: _: {
              go-home = go-home.packages.${system}.default;
              inherit (nixpkgs-unstable.legacyPackages."${system}") zigbee2mqtt;
            })
          ];
        };
    in {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (poetry.override { python3 = python312; })
            go-task
            nixfmt-classic
            statix
            vulnix
          ];
        };
      });

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      homeModules = {
        default = ./home/default.nix;
        appConfigs = ./home/config-app.nix;
        systemConfigs = ./home/config-system.nix;
      };

      nixosConfigurations = {
        # *** Workstations ***
        wheatley = let
          system = x86_64-linux;
          nixpkgs = nixpkgs-unstable;

          pkgs = desktopPkgs system nixpkgs;

          username = "jacob";
          additionalPrograms = { };
          additionalPackages =
            import ./home/packages-workstation.nix { inherit pkgs; };

          appConfigs = import ./home/config-app.nix { inherit pkgs; };
          systemConfigs = import ./home/config-system.nix { inherit pkgs; };

        in nixpkgs.lib.nixosSystem {
          inherit system;
          inherit pkgs;
          specialArgs = { flake-self = self; } // inputs;
          modules = [
            machines/wheatley/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users.jacob = import ./home/default.nix;
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit username;
                  inherit additionalPackages;
                  inherit additionalPrograms;
                  configFiles =
                    nixpkgs.lib.recursiveUpdate appConfigs systemConfigs;
                };
              };
            }
          ];
        };

        # *** Servers ***
        atlas = let
          system = x86_64-linux;
          pkgs = nixpkgs;
        in pkgs.lib.nixosSystem {
          inherit system;
          pkgs = serverPkgs system pkgs;
          # Make inputs accessible add module parameters
          specialArgs = { inherit inputs; };
          modules = [ machines/atlas/configuration.nix ];
        };
      };
    };
}
