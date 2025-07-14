{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.my-home-assistant;
  homeAssisatntCfg = config.services.my-home-assistant;
  homeAssistantConfig = {
    homeassistant = {
      name = "Home";
      unit_system = "metric";
      temperature_unit = "C";
      time_zone = "Europe/Prague";
      currency = "CZK";
    };
    frontend = { themes = "!include_dir_merge_named themes"; };
  };
in {
  options.services.my-home-assistant = {
    enable = mkEnableOption "my-home-assistant";
  };

  config.services.home-assistant = mkIf cfg.enable {
    inherit (homeAssisatntCfg) enable;
    config = homeAssistantConfig;
    configDir = "/var/lib/hass";
    extraComponents =
      [ "default_config" "met" "radio_browser" "mqtt" "mobile_app" ];
  };
}
