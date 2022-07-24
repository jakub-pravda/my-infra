{ config, pkgs, ... }:
{
  imports = [
    ./users.nix
    ./vpsadminos.nix
    ./services/nginx.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  
  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Prague";

  system.stateVersion = "22.05";
}