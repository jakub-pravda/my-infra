{
  config,
  lib,
  ...
}:
with lib;
# I'm using influxdb 2 ony temporarily, until the version 3 is released, as it contains a lot of cool features
  let
    cfg = config.services.iot-cml-influxdb;
    cmlNodeCfg = config.services.iot-cml;
    hubNameList = map (hubConfig: hubConfig.id) cmlNodeCfg.hubConfigs;

    whoami = config.networking.hostName;

    # subscribe config
    hubNamesSubscribeAll = map (hubName: "${hubName}/#") hubNameList;

    allowedGeneralFields = [
      "battery"
      "linkquality"
    ];

    allowedTempSensorFields = [
      "humidity"
      "temperature"
      "pressure"
    ];

    allowedTrvFields = [
      "external_measured_room_sensor"
      "local_temperature"
      "occupied_heating_setpoint_scheduled"
      "pi_heating_demand"
    ];

    allowedFields = builtins.concatLists [
      allowedGeneralFields
      allowedTempSensorFields
      allowedTrvFields
    ];
  in {
    options.services.iot-cml-influxdb = {
      enable = mkEnableOption "iot-cml-influxdb";

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "The host of the InfluxDB instance";
      };

      port = mkOption {
        type = types.port;
        default = 8086;
        description = "The port of the InfluxDB instance";
      };
    };
    config = mkIf cfg.enable {
      age.secrets.influxtoken = {
        file = ../../../machines/${whoami}/secrets/influx-telegraf-token.age;
        owner = "influxdb2";
        group = "influxdb2";
      };

      services.influxdb2 = {
        enable = true;
        settings = {
          http-bind-address = "${cfg.host}:${toString cfg.port}";
        };
      };

      # telegraf is responsible for collecting the data from the mqtt broker and sending it to the influxdb instance
      systemd.services.telegraf.serviceConfig.Environment = ''
        INFLUX_TOKEN=$(head -n 1 ${config.age.secrets.influxtoken.path})
      '';
      services.telegraf = {
        enable = true;
        extraConfig = {
          inputs = {
            mqtt_consumer = {
              servers = ["tcp://${cmlNodeCfg.wireguardInterfaceIp}:${toString cmlNodeCfg.mosquittoPort}"];
              topics = hubNamesSubscribeAll;
              qos = 1;
              data_format = "json";
              fieldpass = allowedFields;
            };
          };

          outputs = {
            influxdb_v2 = {
              urls = ["http://${cfg.host}:${toString cfg.port}"];
              token = "\${INFLUX_TOKEN}";
              organization = "trueorg";
              bucket = "iot";
            };

            file = {
              # for debugging
              files = ["stdout"];
              data_format = "json";
            };
          };
        };
      };
    };
  }
