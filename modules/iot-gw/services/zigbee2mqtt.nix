{ config, lib, ... }:
with lib;
let
  devicesMap = map (
    device: { 
      name  = device.id; 
      value = { friendly_name="${device.location}/${device.name}"; }; 
    }) config.iot.devices;

in { config.services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true;
      mqtt = {
        base_topic = config.iot.hubName;
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

      devices = listToAttrs devicesMap;
    };
  };
}