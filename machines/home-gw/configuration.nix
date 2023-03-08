{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/services
    ./wg-client.nix
    ../../users/jacob.nix
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
    git
    tcpdump
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    wireguard-tools
  ];

  services = {
    openssh.enable = true;
    iot-gw = {
      enable = true;
      cmlHost = {
        host = "37.205.13.151";
        hostInternal = "10.100.0.1";
        mosquittoPort = 1883;
      };
      hubConfig = import ./iot-hub.nix;
    };
    my-home-assistant.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    51820 # wireguard VPN
    8080 # zigbee2mqtt frontend
    8123 # home-automation
  ];
  system.stateVersion = "22.05"; # Did you read the comment?
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };

  # monitoring
  # services.datadog-agent = {
  #   enable    = true;
  #   hostname  = "home-gw";
  #   site      = "datadoghq.eu";

  #   apiKeyFile = /run/keys/datadog_api_key;
  # };
}
