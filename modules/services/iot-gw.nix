{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.iot-gw;
in {
  options.services.iot-gw = { enable = mkEnableOption "iot-gw"; };

  config =
    mkIf cfg.enable { services.trv-sensor-sync.enable = mkDefault true; };
}
