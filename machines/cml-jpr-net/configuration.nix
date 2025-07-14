{ pkgs, ... }: {
  imports = [
    ../shared
    ../../modules/services
    ./vpsadminos.nix
    ./wg-server.nix
    ../../users/jacob
  ];

  networking.hostName = "cml-jpr-net";
  environment.systemPackages = with pkgs; [
    atop
    git
    kcat
    vim
    openssl
    tcpdump
    wireguard-tools
  ];

  environment.etc."nixos/configuration.nix" = {
    source = "/home/jacfal/my-infra/machines/cml-jpr-net/configuration.nix";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80 # http
      443 # https
      1883 # mosquitto
    ];
    allowedUDPPorts = [
      51820 # wireguard VPN
    ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Prague";

  # allow machine specific services
  services = {
    auto-update = {
      enable = true;
      flakeToUse = "vpsfree";
    };

    jacfal-wiki.enable = true;

    iot-cml = {
      enable = true;
      hubConfigs =
        let utils = pkgs.callPackage ../../machines/shared/utils.nix { };
        in utils.getAllHubConfigs ../../machines;
      wireguardInterfaceIp = "10.100.0.1";
    };

    my-nginx.enable = true;
    flake-update.enable = true;
  };
  system.stateVersion = "24.05";
}
