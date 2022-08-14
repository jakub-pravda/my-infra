{ config, pkgs, ...}:
let 
  telegrafIotListenerConfig = pkgs.callPackage ./config/telegraf-iot-listener.nix { inherit pkgs; };
  telegrafQuestFeederConfig = pkgs.callPackage ./config/telegraf-iot-quest-feeder.nix { inherit pkgs; };
  dockerIotNetworkName = "iot-network";

  # images
  questDbVersion = "questdb/questdb";
  rabbitMqVersion = "rabbitmq:3.10-management";
  telegrafImageVersion = "telegraf:1.23";
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
      image = "${telegrafImageVersion}";
      ports = ["127.0.0.1:2684:2684"];
      volumes = [
        "${telegrafIotListenerConfig}:/etc/telegraf/telegraf.conf:ro"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };

    telegraf-iot-quest-feeder = {
      image = "${telegrafImageVersion}";
      volumes = [
        "${telegrafQuestFeederConfig}:/etc/telegraf/telegraf.conf:ro"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };

    rabbit-mq = {
      image = "${rabbitMqVersion}";
      ports = [
        "127.0.0.1:5672:5672"
        "127.0.0.1:15672:15672"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };

    quest-db = {
      image = "${questDbVersion}";
      ports = [ "127.0.0.1:9000:9000" "127.0.0.1:9009:9009" ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };
  };
}