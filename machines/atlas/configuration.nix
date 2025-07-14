{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./shared.nix
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

  nix.gc = {
    automatic = true;
    dates = "03:00";
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "02:00";
    };
    flake = "github:jakub-pravda/my-infra";
    dates = "00:30";
  };

  environment.systemPackages = with pkgs; [
    git
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
      # remark: github user has access to the private nixos configuration
      user = "github";
    };
    openssh.enable = true;
  };

  # TODO enable system autoupgrade
  # TODO use home manager shell

  networking = {
    hostName = "atlas";
  };
}
