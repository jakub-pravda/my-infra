{ config, ... }:
{
  imports = [
    ./users.nix
    ./services/all.nix
    ./containers.nix
    ../../common/iot.nix
  ];
}