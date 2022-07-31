{ config, ... }:
{
  config.services.telegraf = {
    enable = true;
    extraConfig = {

      inputs.mqtt_consumer = {
        servers = [ "tcp://127.0.0.1:1883" ];
        topics = [ "zigbee2mqtt/#" ];
        topic_tag = "topic";
        data_format = "json"; 
      };

      outputs.file = {
        files = [ "stdout" ];
      };
    };
  };
}