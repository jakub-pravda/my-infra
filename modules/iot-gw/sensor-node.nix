{ lib, ... }:
with lib;
{
  options.sensor-node = {
    enable = mkEnableOption "sensor-node";
    
    cmlHost = mkOption {
      type = types.str;
      description = ''
        Address of the CML node
      '';
    };

    cmlMosquittoPort = mkOption {
      type = types.port;
      default = 1883;
      description = ''
        Port of the CML Mosqiotto. Used for mqtt bridge
      '';
    };

    devices = mkOption {
        type = types.listOf (types.submodule (import ../../submodules/device.nix));
    };

    hubName = mkOption {
        type = types.str;
        example = "myHome";
        description = ''
          Name of the iote hub (eg. home, office, cottage, ...).
        '';
      };
  };
}