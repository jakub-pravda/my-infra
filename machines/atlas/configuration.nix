# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# TODO read https://madaidans-insecurities.github.io/guides/linux-hardening.html
# TODO read https://ryanseipp.com/post/hardening-nixos/
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../users/jacob
    inputs.sops-nix.nixosModules.sops
  ];

  boot.loader.grub.enable = true;

  nix.settings.trusted-users = [
    "root"
    "jacob"
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    git
    #influxdb3
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  system.stateVersion = "25.05"; # Do not change this!
  boot.loader.grub.device = "/dev/nvme0n1";

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/jacob/.config/sops/age/keys.txt"; # TODO per environment

    secrets."services/github/atlas_runner_pat" = {};
  };

  services = {
    github-runners."atlas-ci-runner" = {
      enable = true;
      url = "https://github.com/jakub-pravda/my-infra/";
      tokenFile = config.sops.secrets."services/github/atlas_runner_pat".path;
    };
    openssh.enable = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9shyrS1wVfeR4se3mZ0bvN1wxf4jX3+0AohJy0Tng4 me@jakubpravda.net"
  ];

  networking = {
    hostName = "atlas";
  };
}
