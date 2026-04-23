{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./containers.nix
    ./services.nix
    ../../users/jacob
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.grub.enable = true;

  nix = {
    settings = {
      allowed-users = [ "jacob" ];
      trusted-users = [ "root" "jacob" ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "03:00";
    };
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
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

  environment.systemPackages = with pkgs; [ git vim ];

  system.stateVersion = "25.11"; # Do not change this!

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile =
      "/home/jacob/.config/sops/age/keys.txt"; # TODO per environment

    secrets."services/github/atlas_runner_pat" = { };
  };
  containerOptions.containerUser = "jacob";

  networking = { hostName = "atlas"; };
}
