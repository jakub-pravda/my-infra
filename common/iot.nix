{ lib, ... }:

with lib;

{ options = {
    iot = {
      hubName = mkOption {
        type = types.str;
        example = "myHome";
        description = ''
          Name of the iote hub (eg. home, office, cottage, ...).
        '';
      };

      devices = mkOption {
        type = types.listOf (types.submodule (import ../submodules/device.nix));
      };
    };
  };
}