{ config, pkgs, ... }:
{
  imports = [
    ./users.nix
    ./vpsadminos.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  nix.settings.trusted-users = [ "jacfal" ];
  deployment.targetUser = "root";
  deployment.targetHost = "37.205.13.151";

  virtualisation.docker.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "22.05";
}