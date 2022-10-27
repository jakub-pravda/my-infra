{ config, pkgs, ... }:
{
  imports = [
    ./vpsadminos.nix
    ../../modules/iot-cml/default.nix # activate iot-cml
    ../../common/devices.nix
  ];

  networking.hostName = "cml-jpr-net";

  environment.systemPackages = with pkgs; [
    kcat
    vim
    openssl
    tcpdump
  ];

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
}