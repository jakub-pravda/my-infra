{ config, pkgs, ... }: {
  imports = [
    ../../modules/services
    ./vpsadminos.nix
    ../../modules/iot-cml/default.nix # activate iot-cml
    ../../common/devices.nix
  ];

  networking.hostName = "cml-jpr-net";

  environment.systemPackages = with pkgs; [ kcat vim openssl tcpdump ];

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 4862 80 443 ];
  };

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Prague";

  system.stateVersion = "22.05";

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
