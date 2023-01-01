{ lib, ... }:
with lib;
{
  options.services.cml-node = {
    enable = mkEnableOption "iot-cml";

    wireguardInterfaceIp = mkOption {
      type = types.str;
      default = "10.100.0.1";
      description = ''
        Wireguard wg0 interface ip address.
      '';
    };

    mosquittoPort = mkOption {
      type = types.port;
      default = 1883;
      description = ''
        Port of the local MQTT broker
      '';
    };
  };
}