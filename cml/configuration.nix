{ config, pkgs, ... }:
{
  imports = [
    ./users.nix
    ./vpsadminos.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  virtualisation.docker.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "22.05";
}