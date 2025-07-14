{ lib, ... }:
with lib; {
  options = {
    host = mkOption {
      type = types.str;
      example = "cml.example.com";
      description =
        "Hostname or ip address of the cml server. Reachable from the internet.";
    };

    hostInternal = mkOption {
      type = types.str;
      example = "10.0.0.1";
      description =
        "Hostname or ip address of the cml server. Reachable from the internal network.";
    };

    mosquittoPort = mkOption {
      type = types.port;
      default = 1883;
      description = ''
        Port of the CML Mosqiotto. Used for mqtt bridge
      '';
    };
  };
}
