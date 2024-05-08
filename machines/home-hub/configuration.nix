{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ../shared
    ./hardware-configuration.nix
    ../../modules/services
    ./wg-client.nix
    ../../users/jacob
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "home-hub"; # Define your hostname.
  time.timeZone = "Europe/Prague";

  environment.etc."nixos/configuration.nix" = {
    source = "/home/jacfal/my-infra/machines/home-hub/configuration.nix";
  };

  environment.systemPackages = with pkgs; [
    atop
    git
    tcpdump
    vim
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

  networking.firewall.allowedTCPPorts = [
    22
    51820 # wireguard VPN
    8080 # zigbee2mqtt frontend
    8123 # home-automation
  ];
  system.stateVersion = "24.05";
}
