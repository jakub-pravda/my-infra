{ config, pkgs, ...}:
let 
  telegrafIotListenerConfig = pkgs.callPackage ./config/telegraf-iot-listener.nix { inherit pkgs; };
  telegrafQuestFeederConfig = pkgs.callPackage ./config/telegraf-iot-quest-feeder.nix { inherit pkgs; };
  dockerIotNetworkName = "iot-network";

  # images
  questDbVersion        = "questdb/questdb";
  redPandaVersion       = "docker.redpanda.com/vectorized/redpanda:latest";     
  rabbitMqVersion       = "rabbitmq:3.10-management";
  telegrafImageVersion  = "telegraf:1.23";

  # volumes
  questDbDataPath   = "/var/lib/questdb-docker-vol"; # TODO docker volume
  redPandaDataPath  = "redpanda-1-docker-vol";

  # container specific
  numOfRedpandaInstances = 3;
in {
  config.system.activationScripts = {
    dockerEnvInit = {
      text = ''
      # prepare directories for volumes
      mkdir -p ${questDbDataPath} ${redPandaDataPath}

      # create docker networks
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

    # TODO cluster it
    redpanda-1 = {
      image = "${redPandaVersion}";
      ports = [ "127.0.0.1:9092:9092" ];
      volumes = [
        "${redPandaDataPath}:/var/lib/redpanda/data"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
      cmd = [
        "redpanda start"
        "--overprovisioned"
        "--memory 1G"
        "--reserve-memory 0M"
        "--node-id 0"
        "--smp 1"
        "--check=false"
        "--kafka-addr PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092"
        "--advertise-kafka-addr PLAINTEXT://0.0.0.0:29092,OUTSIDE://redpanda-1:9092"
      ];
    };

    quest-db = {
      image = "${questDbVersion}";
      ports = [ 
        "127.0.0.1:9000:9000" 
        "127.0.0.1:9009:9009" 
        "127.0.0.1:8812:8812" 
      ];
      volumes = [
        "${questDbDataPath}:/var/lib/questdb"
      ];
      extraOptions = ["--network=${dockerIotNetworkName}"];
    };
  };
}