{ config, pkgs, ...}:
let 
  telegrafIotListenerConfig = pkgs.callPackage ./config/telegraf-iot-listener.nix { inherit pkgs; };
  dockerIotNetworkName = "iot-network";
in {
  config.system.activationScripts = {
    createDockerNetwork = {
      text = ''
      if [[ -z "$(${pkgs.docker}/bin/docker network ls -q --filter name=${dockerIotNetworkName})" ]]; then
        echo "Creating new docker network (${dockerIotNetworkName})"
        ${pkgs.docker}/bin/docker network create ${dockerIotNetworkName}
      fi
      '';
    };
  };

  config.virtualisation.oci-containers.backend = "docker";
  config.virtualisation.oci-containers.containers = {
    
    telegraf-iot-listener = {
      image = "telegraf:1.23";
      ports = ["127.0.0.1:2684:2684"];
      volumes = [ 
        "${telegrafIotListenerConfig}:/etc/telegraf/telegraf.conf:ro"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };

    rabbit-mq = {
      image = "rabbitmq:3.10-management";
      ports = [
        "127.0.0.1:5672:5672"
        "127.0.0.1:15672:15672"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };

    quest-db = {
      image = "questdb/questdb";
      ports = [ "127.0.0.1:9000:9000" ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };
  };
}