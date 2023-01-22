{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.trv-sensor-sync;
  iotMosquittoCfg = config.services.iot-mosquitto;

  topicSyncCron = "*/15 * * * *";
in {
  options.services.trv-sensor-sync = {
    enable = mkEnableOption "trv-sesnsor-sync";
  };

  config = mkIf cfg.enable {
    systemd.services."tss" = {
      description = "TRV sensor synchronizer";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''
          "${pkgs.go-home}/bin/tss" \
            --broker tcp://${iotMosquittoCfg.address}:${
              toString iotMosquittoCfg.port
            } \
            --sensor-topic myhome-kr/livingroom/son-sns-01 \
            --trv-topic myhome-kr/livingroom/danfoss-thermo-01 \
            --cron ${topicSyncCron}
        '';
      };
    };
  };
}
