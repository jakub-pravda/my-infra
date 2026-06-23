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

    sops.templates."langfuse-env" = {
      content = ''
        CLICKHOUSE_PASSWORD=${config.sops.placeholder."langfuse/clickhouse/password"}
        DATABASE_URL=postgresql://postgres:${
          config.sops.placeholder."langfuse/postgres/password"
        }@postgres:5432/postgres
        POSTGRES_PASSWORD=${config.sops.placeholder."langfuse/postgres/password"}
        MINIO_ROOT_PASSWORD=${config.sops.placeholder."langfuse/minio/password"}
        LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY=${config.sops.placeholder."langfuse/minio/password"}
        LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY=${config.sops.placeholder."langfuse/minio/password"}
        LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY=${config.sops.placeholder."langfuse/minio/password"}
        REDIS_AUTH=${config.sops.placeholder."langfuse/redis/password"}
        NEXTAUTH_SECRET=${config.sops.placeholder."langfuse/next_auth_secret"}
        ENCRYPTION_KEY=${config.sops.placeholder."langfuse/encryption_key"}
        SALT=${config.sops.placeholder."langfuse/salt"}
      '';
    };

    sops.templates."langfuse-redis.conf" = {
      content = ''
        requirepass ${config.sops.placeholder."langfuse/redis/password"}
        maxmemory-policy noeviction
      '';
    };

    # Containers
    services = {
      oci-langfuse = {
        enable = true;
        environmentFiles = [ config.sops.templates."langfuse-env".path ];
        redis.configFile = config.sops.templates."langfuse-redis.conf".path;
      };
      oci-web-blog.enable = true;
    };
  };
}
