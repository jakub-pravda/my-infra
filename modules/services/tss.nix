{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.trv-sensor-sync;
  topicSyncCron = "*/15 * * * *";
in {
  options.services.trv-sensor-sync = {
    enable = mkEnableOption "trv-sesnsor-sync";

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
    systemd.services."iot-tss" = {
      description = "TRV sensor synchronizer";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Restart = "always";
        ExecStart = ''
          "${pkgs.go-home}/bin/tss" \
            --broker mqtt://${cfg.mosquittoBroker}:${
              toString cfg.mosquittoPort
            } \
            --sensor-topic 'myhome-kr/livingroom/son-sns-01' \
            --trv-topic 'myhome-kr/livingroom/danfoss-thermo-01' \
            --cron '${topicSyncCron}'
        '';
      };
    };
  };
}
