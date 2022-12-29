{ config, pkgs, ... }: {
  imports = [
    ../../modules/services
    ./vpsadminos.nix
    ../../modules/iot-cml/default.nix # activate iot-cml
    ../../common/devices.nix
    ./wg-server.nix
  ];

  networking.hostName = "cml-jpr-net";

  environment.systemPackages = with pkgs; [ 
    atop
    kcat 
    vim 
    openssl 
    tcpdump
    wireguard-tools
  ];

  environment.etc."nixos/configuration.nix" = {
    source = "/home/jacfal/my-infra/machines/cml-jpr-net/configuration.nix";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      80    # http
      443   # https
    ];
    allowedUDPPorts = [ 
      51820 # wireguard VPN
    ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Prague";

  system = {
    autoUpgrade = {
      enable        = true;
      allowReboot   = true;
    };
    stateVersion = "22.05";
  };

  # allow machine specific services
  services.jacfal-wiki.enable = true;

  # monitoring
  # TODO bind key to nixos
  # services.datadog-agent = {
  #   enable    = true;
  #   hostname  = "cml-jpr-net";
  #   site      = "datadoghq.eu";

  #   apiKeyFile = /run/keys/datadog_api_key;
  # };
}
