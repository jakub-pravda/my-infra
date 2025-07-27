{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./containers.nix
    ./services.nix
    ./shared.nix
    ../../users/jacob
    ../../users/github
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.grub.enable = true;

  nix = {
    settings = {
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

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "03:00";
    };
  };
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
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

    secrets."services/github/atlas_runner_pat" = { };
  };
  containerOptions.containerUser = "jacob";

  networking = {
    hostName = "atlas";
  };
}
