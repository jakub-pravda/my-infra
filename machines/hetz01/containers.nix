{
  lib,
  config,
  ...
}:
{

  imports = [
    ../../modules/services/oci-langfuse.nix
    ../../modules/services/oci-web-blog.nix
  ];

  options.containerOptions = {
    containerUser = lib.mkOption {
      type = lib.types.str;
      description = "User for running containers";
    };
  };

  config = {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };

    # Enable container name DNS for all Podman networks.
    networking.firewall.interfaces =
      let
        matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
      in
      {
        "${matchAll}".allowedUDPPorts = [ 53 ];
      };

    virtualisation.oci-containers.backend = "podman";

    # Containers
    services = {
      oci-langfuse = {
        enable = true;
        clickhouse.password = "clickhouse";
        postgres.password = "postgres";
        minio.password = "miniosecret";
        redis.password = "myredissecret";
        langfuse = {
          nextauthSecret = "mysecret";
          encryptionKey = "0000000000000000000000000000000000000000000000000000000000000000";
          salt = "mysalt";
        };
      };
      oci-web-blog.enable = true;
    };
  };
}
