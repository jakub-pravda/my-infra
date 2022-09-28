{ config, lib, pkgs, ... }:
with lib;
let
  homeAssistantConfig = {
    homeassistant = {
      name              = "Home";
      unit_system       = "metric";
      temperature_unit  = "C";
      time_zone         = "Europe/Prague";
      currency          = "CZK";
    };
    frontend = {
      themes = "!include_dir_merge_named themes";
    };
  };

  homeAssistantConfigYaml = generators.toYAML {} homeAssistantConfig;
in 
{
  config.services.home-assistant = {
    enable = true;
    config = homeAssistantConfig;
    extraComponents = [
      # Components required to complete the onboarding
      "met"
      "radio_browser"
      # Zigbee2mqtt
      "mqtt"
    ];
  };
}
