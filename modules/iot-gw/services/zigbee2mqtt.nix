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

      devices = {
      "0x00124b00251f6180" = {
        friendly_name = "kitchen/son-sns-01";
      };
    };
    };
  };
}