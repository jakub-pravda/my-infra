{ config, lib, ... }:
with lib;
let
  cfg = config.services.iot-mosquitto;
  sensorNode = config.sensor-node;
in {
  options.services.iot-mosquitto = {

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Iot Mosquitto address
      '';
    };

    port = mkOption {
      type = types.port;
      default = 1883;
      description = ''
        Iot Mosquitto port
      '';
    };

  };

  config.services.mosquitto = {
    enable = true;
    listeners = [{
      acl = [ "pattern readwrite #" ];
      address = cfg.address;
      port = cfg.port;
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    }];
    bridges."cml" = {
      addresses = [{
        address = sensorNode.cmlHost;
        port = sensorNode.cmlMosquittoPort;
      }];
      topics = [ "${sensorNode.hubName}/#" ];
    };
  };
}
