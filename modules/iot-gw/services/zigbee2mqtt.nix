{ config, ... }:
{
  config.services.zigbee2mqtt = {
    enable = true;
    settings = 
    {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true;
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://localhost:1883";
      };
      serial.port = "/dev/ttyUSB0";
      frontend.port = 8080;
      advanced.network_key = "GENERATE";

      devices = {
      "0x00124b00251f6180" = {
        friendly_name = "kitchen/tmp01";
      };
    };
    };
  };
}