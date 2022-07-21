{ config, ...}:
{
  # zigbee2mqtt service settings
  config.services.zigbee2mqtt = {
    enable = true;
    settings = 
    {
      permit_join = true;
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://localhost:1883";
      };
      serial.port = "/dev/ttyUSB0";
      frontend.port = 8080;
      advanced.network_key = "GENERATE";
    };
  };

  # mqtt broker service settings
  config.services.mosquitto = {
    enable = true;
    listeners = [ {
      acl = [ "pattern readwrite #" ];
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    } ];
  };
}