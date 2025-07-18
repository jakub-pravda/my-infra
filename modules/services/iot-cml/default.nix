{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.iot-cml;
  influxdbCfg = config.services.iot-cml-influxdb;
in {
  imports = [ ./containers.nix ./influxdb.nix ];

  options.services.iot-cml = {
    enable = mkEnableOption "iot-cml";

    hubConfigs = mkOption {
      type = types.listOf
        (types.submodule (import ../../../submodules/iot-hub-host-options.nix));
      description = "List of hubs configured to this CML";
    };

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
        Port of the CML local MQTT broker
      '';
    };
  };

  config = mkIf cfg.enable {
    services.iot-cml-influxdb.enable = true;

    services.grafana = let
      # ** DATA SOURCES **
      questDb = {
        name = "QuestDB";
        uid = "P2596F1C8E12435D2";
        type = "postgres";
        url = "localhost:8812";
        database = "qdb";
        user = "admin";
        jsonData = {
          postgresVersion = 903;
          sslmode = "disable";
        };
        secureJsonData = { password = "quest"; };
      };

      influxDb2 = {
        name = "InfluxDB2";
        type = "influxdb";
        access = "proxy";
        url = "http://${influxdbCfg.host}:${toString influxdbCfg.port}";
        jsonData = {
          version = "Flux";
          organization = "trueorg";
          defaultBucket = "iot";
          skipTlsVerify = true;
        };
        secureJsonData = {
          # TODO nix-token, read from agenix
          token =
            "miKY5m8w7UftYNeQLNyhofri2Hrbvaxg5CbMQUMpe7tbFNoaJJiCTGMV1NAEg9GMXNJzeGHRT5awIpM7jG2HGw==";
        };
      };

      snzb02SenzorDashboard = import ./grafana/templates/snzb02dashboard.nix {
        inherit config;
        inherit pkgs;
      };
    in {
      enable = true;
      settings = {
        server.http_addr = "localhost";
        server.http_port = 3000;
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [ questDb influxDb2 ];
      };
    };
  };
}
