{ inputs, pkgs, ... }:
let
  mainUser = "jacob";
in
{
  imports = [
    ./hardware-configuration.nix
    ./containers.nix
    ./services.nix
    ../../users/jacob
    ./sops
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    settings = {
      allowed-users = [ mainUser ];
      trusted-users = [
        "root"
        mainUser
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

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  networking = {
    hostName = "hetz01";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
    };
    networkmanager.enable = true;
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

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "25.11"; # Do not change this!
  containerOptions.containerUser = mainUser;

}
