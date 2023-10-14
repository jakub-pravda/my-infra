{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  dockerIotNetworkName = "iot-network";

  # mosquitto must be accessible from nodes
  cmlNodeCfg = config.services.iot-cml;

  hubNames = map (hubConfig: hubConfig.id) cmlNodeCfg.hubConfigs;
  telegrafQuestFeederConfig =
    pkgs.callPackage ./conf/telegraf-iot-quest-feeder.nix {inherit pkgs;}
    hubNames;
  mosquittoConf = pkgs.callPackage ./conf/mosquitto.nix {inherit pkgs;};

  # images
  mosquittoVersion = "eclipse-mosquitto:2.0.15";
  questDbVersion = "questdb/questdb";
  telegrafImageVersion = "telegraf:1.23";

  # volumes
  questDbDataPath = "/var/lib/questdb-docker-vol";
  mosqittoDataPath = "/var/lib/mosquitto-docker-vol";
in {
  config = mkIf cmlNodeCfg.enable {
    system.activationScripts = {
      dockerEnvInit = {
        text = ''
          # prepare directories for volumes
          mkdir -p ${questDbDataPath} ${mosqittoDataPath}

          # create docker networks
          if [[ -z "$(${pkgs.docker}/bin/docker network ls -q --filter name=${dockerIotNetworkName})" ]]; then
            echo "Creating new docker network (${dockerIotNetworkName})"
            ${pkgs.docker}/bin/docker network create ${dockerIotNetworkName}
          fi
        '';
      };
    };

    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers = {
      telegraf-iot-quest-feeder = {
        image = "${telegrafImageVersion}";
        volumes = ["${telegrafQuestFeederConfig}:/etc/telegraf/telegraf.conf:ro"];
        extraOptions = ["--network=${dockerIotNetworkName}"];
      };

      quest-db = {
        image = "${questDbVersion}";
        ports = ["127.0.0.1:9000:9000" "127.0.0.1:9009:9009" "127.0.0.1:8812:8812"];
        volumes = ["${questDbDataPath}:/var/lib/questdb"];
        extraOptions = ["--network=${dockerIotNetworkName}"];
      };

      mosquitto = {
        image = "${mosquittoVersion}";
        ports = [
          "${cmlNodeCfg.wireguardInterfaceIp}:${
            toString cmlNodeCfg.mosquittoPort
          }:1883"
        ];
        volumes = [
          "${mosquittoConf}:/mosquitto/config/mosquitto.conf"
          "${mosqittoDataPath}/data:/mosquitto/data"
          "${mosqittoDataPath}/log:/mosquitto/log"
        ];
        extraOptions = ["--network=${dockerIotNetworkName}"];
      };
    };
  };
}
