{ config, ... }:
{
  imports = [
    ./users.nix
    ./cml-node.nix
    ./services/all.nix
    ./containers.nix
  ];
}