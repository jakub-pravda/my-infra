{ config, ... }:
{
  imports = [
    ./users.nix
    ./services/all.nix
    ./containers.nix
  ];
}