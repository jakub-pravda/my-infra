{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.iot-gw;
  devicesMap = map (device: {
    name = device.id;
    value = { friendly_name = "${device.location}/${device.name}"; };
  }) cfg.devices;
in {
  options.services.iot-gw = {
    enable = mkEnableOption "iot-gw";

    cmlHost = mkOption {
      type = types.submodule (import ../../submodules/cml-host-options.nix);
      description = ''
        Iot CML node options. Gateway sends all it's data to the CML node.
      '';
    };

    devices = mkOption {
      type =
        types.listOf (types.submodule (import ../../submodules/device.nix));
      description = ''
        List of IoT devices to be configured on the gateway.
      '';
    };

    hubName = mkOption {
      type = types.str;
      example = "myHome";
      description = ''
        Name of the IoT gateway hub (eg. home, office, cottage, ...).
      '';
    };

    mosquittoHost = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Iot gateway mosquitto address
      '';
    };

    mosquittoPort = mkOption {
      type = types.port;
      default = 1883;
      description = ''
        Iot gateway mosquitto port
      '';
    };
  };

  config = mkIf cfg.enable {
    services = {
      # TRV - sensor tandem
      trv-sensor-sync = {
        enable = true;
        mosquittoBroker = cfg.mosquittoHost;
        mosquittoPort = cfg.mosquittoPort;
      };

      trv-temp-scheduler = {
        enable = true;
        mosquittoBroker = cfg.mosquittoHost;
        mosquittoPort = cfg.mosquittoPort;
      };

      # zigbee2mqtt settings
      zigbee2mqtt = {
        enable = true;
        settings = {
          homeassistant = config.services.home-assistant.enable;
          permit_join = true;
          mqtt = {
            base_topic = cfg.hubName;
            server = "mqtt://localhost:1883";
          };
          serial.port = "/dev/ttyUSB0";
          frontend.port = 8080;
          advanced.network_key = [ # TODO more secret
            43
            75
            203
            206
            165
            142
            51
            124
            166
            55
            122
            253
            132
            60
            133
            27
          ];

          devices = listToAttrs devicesMap;
        };
      };

      # mosquitto settings
      mosquitto = {
        enable = true;
        listeners = [{
          acl = [ "pattern readwrite #" ];
          address = cfg.mosquittoHost;
          port = cfg.mosquittoPort;
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }];
        bridges."cml" = {
          addresses = [{
            address = cfg.cmlHost.hostInternal;
            port = cfg.cmlHost.mosquittoPort;
          }];
          topics = [ "${cfg.hubName}/#" ];
        };
      };
    };
  };
}
