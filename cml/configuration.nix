{ config, pkgs, ... }:
{
  imports = [
    ./users.nix
    ./vpsadminos.nix
    ./services/nginx.nix
  ];

  networking.hostName = "cml-jpr-net";

  environment.systemPackages = with pkgs; [
    vim
    openssl
  ];

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 443 4862 ];
  };
  
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Prague";

  system.stateVersion = "22.05";
}