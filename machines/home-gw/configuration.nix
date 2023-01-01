{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../common/sensor-node-conf.nix
    ../../common/users.nix
    ../../modules/iot-gw # activate io-gw module
    ../../modules/home-assistant
    ./wg-client.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "home-gw"; # Define your hostname.
  time.timeZone = "Europe/Prague";

  environment.etc."nixos/configuration.nix" = {
    source = "/home/jacfal/my-infra/machines/home-gw/configuration.nix";
  };

  environment.systemPackages = with pkgs; [
    atop
    tcpdump
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wireguard-tools
  ];

  services.openssh.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    51820 # wireguard VPN
    8080  # zigbee2mqtt frontend
    8123  # home-automation
  ];
  system.stateVersion = "22.05"; # Did you read the comment?
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  # monitoring
  # services.datadog-agent = {
  #   enable    = true;
  #   hostname  = "home-gw";
  #   site      = "datadoghq.eu";

  #   apiKeyFile = /run/keys/datadog_api_key;
  # };
}
