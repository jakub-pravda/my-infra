{ config, pkgs, ... }:
let
  baseTopic = config.iot.hubName;
  httpSecret = pkgs.callPackage ../../../common/secret-management.nix { inherit pkgs; } /cml-http-endpoint;
in
{
  config.services.telegraf = {
    enable = true;
    extraConfig = {

      inputs.mqtt_consumer = {
        servers = [ "tcp://127.0.0.1:1883" ];
        topics = [ "${baseTopic}/#" ];
        topic_tag = "topic";
        data_format = "json";
      };

      # debug options
      outputs.file = {
        files = ["stdout"];
      };

      outputs.http = {
        url = "https://cml.jakubpravda.net/";
        method = "POST";
        data_format = "influx";
        username = "${httpSecret.username}";
        password = "${httpSecret.password}";
      };
    };
  };
}