{ config, ... }:
let
  sensorNode = config.sensor-node;
in {
  config.services.mosquitto = {
    enable = true;
    listeners = [ 
    {
      acl = [ "pattern readwrite #" ];
      address = "localhost";
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    }];
    bridges."cml" = {
      addresses = [
        {
          address = sensorNode.cmlHost;
          port = sensorNode.cmlMosquittoPort;
        }
      ];
      topics = [ "${sensorNode.hubName}/#" ];
    };
  };
}