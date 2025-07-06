{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../users/jacob
    ../../users/github
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.grub.enable = true;

  nix.settings = {
    allowed-users = [
      "jacob"
      "github"
      "github-runner-atlas-ci-runner"
    ];
    trusted-users = [
      "root"
      "jacob"
      "github"
    ];
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    git
    #influxdb3
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  system.stateVersion = "25.05"; # Do not change this!
  boot.loader.grub.device = "/dev/nvme0n1";

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/jacob/.config/sops/age/keys.txt"; # TODO per environment

    secrets."services/github/atlas_runner_pat" = {};
  };

  services = {
    github-runners."atlas-ci-runner" = {
      enable = true;
      url = "https://github.com/jakub-pravda/my-infra/";
      tokenFile = config.sops.secrets."services/github/atlas_runner_pat".path;
      user = "github";
    };
    openssh.enable = true;
  };

  networking = {
    hostName = "atlas";
  };
}
