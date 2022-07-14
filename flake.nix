{
  # see https://nixops.readthedocs.io/en/latest/guides/deploy-without-root.html
  description = "Flake to manage my my local infrastructure";
  
  # inputs = {
  #   nixpkgs.url = "nixpkgs/nixos-unstable";
  # };
  
  outputs = { self, nixpkgs, ... }:
    let
      domain = "my-infra.jpr";
      pkgsFor = system: import nixpkgs {
        inherit system;
      };

    in {      
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      
      nixopsConfigurations.default = {
        inherit nixpkgs;
        network.storage.legacy.databasefile = "./.nixops/deployments.nixops";
        network.description = "Non-root deployment";
         
        homeGW = import ./home-gw/configuration.nix;
        #vpsfree = import ./cml/configuration.nix;
      };
    };
}