{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.trv-temp-scheduler;

  livingRoomScheduler = {
    topic = "myhome-kr/livingroom/danfoss-thermo-01";
    defaultTemperature = 21;
    timeTable = [{
      start = "22:00";
      end = "06:00";
      temperature = 18;
    }];
  };

in {
  options.services.trv-temp-scheduler = {
    enable = mkEnableOption "trv-temp-scheduler";

    mosquittoBroker = mkOption {
      type = types.str;
      description = "MQTT broker address";
    };

    mosquittoPort = mkOption {
      type = types.port;
      description = "MQTT broker port";
    };
  };

  config = mkIf cfg.enable {
    systemd.services."iot-tsc" = {
      description = "TRV temperature scheduler";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Restart = "always";
        ExecStart = ''
          "${pkgs.go-home}/bin/tsc" ${
            cli.toGNUCommandLineShell { } {
              broker =
                "mqtt://${cfg.mosquittoBroker}:${toString cfg.mosquittoPort}";
              scheduler = builtins.toJSON livingRoomScheduler;
            }
          }
        '';
      };
    };
  };
}
