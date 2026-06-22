<<<<<<< HEAD
=======
{
  pkgs,
  lib,
  config,
  ...
}:

>>>>>>> 547409d (chore: nix fmt - non legacy formatter)
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
<<<<<<< HEAD

  config = {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
=======

  # Runtime
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
>>>>>>> 547409d (chore: nix fmt - non legacy formatter)
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
      mode = "0400";
      uid = 999; # redis user id in the container
      content = ''
        requirepass ${config.sops.placeholder."langfuse/redis/password"}
        maxmemory-policy noeviction
      '';
    };
<<<<<<< HEAD
=======
    volumes = [
      "langfuse_langfuse_clickhouse_data:/var/lib/clickhouse:rw"
      "langfuse_langfuse_clickhouse_logs:/var/log/clickhouse-server:rw"
    ];
    ports = [
      "127.0.0.1:8123:8123/tcp"
      "127.0.0.1:9000:9000/tcp"
    ];
    user = "101:101";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:8123/ping || exit 1"
      "--health-interval=5s"
      "--health-retries=10"
      "--health-start-period=1s"
      "--health-timeout=5s"
      "--network-alias=clickhouse"
      "--network=langfuse_default"
    ];
  };

  systemd.services."podman-langfuse-clickhouse" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_clickhouse_data.service"
      "podman-volume-langfuse_langfuse_clickhouse_logs.service"
    ];
    requires = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_clickhouse_data.service"
      "podman-volume-langfuse_langfuse_clickhouse_logs.service"
    ];
    partOf = [
      "podman-compose-langfuse-root.target"
    ];
    wantedBy = [
      "podman-compose-langfuse-root.target"
    ];
  };

  virtualisation.oci-containers.containers."langfuse-langfuse-web" = {
    image = "docker.io/langfuse/langfuse:3";
    environment = {
      "CLICKHOUSE_CLUSTER_ENABLED" = "false";
      "CLICKHOUSE_MIGRATION_URL" = "clickhouse://clickhouse:9000";
      "CLICKHOUSE_PASSWORD" = "clickhouse";
      "CLICKHOUSE_URL" = "http://clickhouse:8123";
      "CLICKHOUSE_USER" = "clickhouse";
      "DATABASE_URL" = "postgresql://postgres:postgres@postgres:5432/postgres";
      "EMAIL_FROM_ADDRESS" = "";
      "ENCRYPTION_KEY" = "0000000000000000000000000000000000000000000000000000000000000000";
      "LANGFUSE_BULLMQ_SKIP_REDIS_VERSION_CHECK" = "false";
      "LANGFUSE_ENABLE_EXPERIMENTAL_FEATURES" = "false";
      "LANGFUSE_INGESTION_CLICKHOUSE_WRITE_INTERVAL_MS" = "";
      "LANGFUSE_INGESTION_QUEUE_DELAY_MS" = "";
      "LANGFUSE_INIT_ORG_ID" = "";
      "LANGFUSE_INIT_ORG_NAME" = "";
      "LANGFUSE_INIT_PROJECT_ID" = "";
      "LANGFUSE_INIT_PROJECT_NAME" = "";
      "LANGFUSE_INIT_PROJECT_PUBLIC_KEY" = "";
      "LANGFUSE_INIT_PROJECT_SECRET_KEY" = "";
      "LANGFUSE_INIT_USER_EMAIL" = "";
      "LANGFUSE_INIT_USER_NAME" = "";
      "LANGFUSE_INIT_USER_PASSWORD" = "";
      "LANGFUSE_OCI_AUTH_TYPE" = "workload_identity";
      "LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID" = "minio";
      "LANGFUSE_S3_BATCH_EXPORT_BUCKET" = "langfuse";
      "LANGFUSE_S3_BATCH_EXPORT_ENABLED" = "false";
      "LANGFUSE_S3_BATCH_EXPORT_ENDPOINT" = "http://minio:9000";
      "LANGFUSE_S3_BATCH_EXPORT_EXTERNAL_ENDPOINT" = "http://localhost:9090";
      "LANGFUSE_S3_BATCH_EXPORT_FORCE_PATH_STYLE" = "true";
      "LANGFUSE_S3_BATCH_EXPORT_PREFIX" = "exports/";
      "LANGFUSE_S3_BATCH_EXPORT_REGION" = "auto";
      "LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY" = "miniosecret";
      "LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID" = "minio";
      "LANGFUSE_S3_EVENT_UPLOAD_BUCKET" = "langfuse";
      "LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT" = "http://minio:9000";
      "LANGFUSE_S3_EVENT_UPLOAD_FORCE_PATH_STYLE" = "true";
      "LANGFUSE_S3_EVENT_UPLOAD_PREFIX" = "events/";
      "LANGFUSE_S3_EVENT_UPLOAD_REGION" = "auto";
      "LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY" = "miniosecret";
      "LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID" = "minio";
      "LANGFUSE_S3_MEDIA_UPLOAD_BUCKET" = "langfuse";
      "LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT" = "http://localhost:9090";
      "LANGFUSE_S3_MEDIA_UPLOAD_FORCE_PATH_STYLE" = "true";
      "LANGFUSE_S3_MEDIA_UPLOAD_PREFIX" = "media/";
      "LANGFUSE_S3_MEDIA_UPLOAD_REGION" = "auto";
      "LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY" = "miniosecret";
      "LANGFUSE_USE_AZURE_BLOB" = "false";
      "LANGFUSE_USE_OCI_NATIVE_OBJECT_STORAGE" = "false";
      "NEXTAUTH_SECRET" = "mysecret";
      "NEXTAUTH_URL" = "http://localhost:3000";
      "REDIS_AUTH" = "myredissecret";
      "REDIS_HOST" = "redis";
      "REDIS_PORT" = "6379";
      "REDIS_TLS_CA" = "/certs/ca.crt";
      "REDIS_TLS_CERT" = "/certs/redis.crt";
      "REDIS_TLS_ENABLED" = "false";
      "REDIS_TLS_KEY" = "/certs/redis.key";
      "SALT" = "mysalt";
      "SMTP_CONNECTION_URL" = "";
      "TELEMETRY_ENABLED" = "true";
    };
    ports = [
      "127.0.0.1:3000:3000/tcp"
    ];
    dependsOn = [
      "langfuse-clickhouse"
      "langfuse-minio"
      "langfuse-postgres"
      "langfuse-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=langfuse-web"
      "--network=langfuse_default"
    ];
  };

  systemd.services."podman-langfuse-langfuse-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-langfuse_default.service"
    ];
    requires = [
      "podman-network-langfuse_default.service"
    ];
    partOf = [
      "podman-compose-langfuse-root.target"
    ];
    wantedBy = [
      "podman-compose-langfuse-root.target"
    ];
  };

  virtualisation.oci-containers.containers."langfuse-langfuse-worker" = {
    image = "docker.io/langfuse/langfuse-worker:3";
    environment = {
      "CLICKHOUSE_CLUSTER_ENABLED" = "false";
      "CLICKHOUSE_MIGRATION_URL" = "clickhouse://clickhouse:9000";
      "CLICKHOUSE_PASSWORD" = "clickhouse";
      "CLICKHOUSE_URL" = "http://clickhouse:8123";
      "CLICKHOUSE_USER" = "clickhouse";
      "DATABASE_URL" = "postgresql://postgres:postgres@postgres:5432/postgres";
      "EMAIL_FROM_ADDRESS" = "";
      "ENCRYPTION_KEY" = "0000000000000000000000000000000000000000000000000000000000000000";
      "LANGFUSE_BULLMQ_SKIP_REDIS_VERSION_CHECK" = "false";
      "LANGFUSE_ENABLE_EXPERIMENTAL_FEATURES" = "false";
      "LANGFUSE_INGESTION_CLICKHOUSE_WRITE_INTERVAL_MS" = "";
      "LANGFUSE_INGESTION_QUEUE_DELAY_MS" = "";
      "LANGFUSE_OCI_AUTH_TYPE" = "workload_identity";
      "LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID" = "minio";
      "LANGFUSE_S3_BATCH_EXPORT_BUCKET" = "langfuse";
      "LANGFUSE_S3_BATCH_EXPORT_ENABLED" = "false";
      "LANGFUSE_S3_BATCH_EXPORT_ENDPOINT" = "http://minio:9000";
      "LANGFUSE_S3_BATCH_EXPORT_EXTERNAL_ENDPOINT" = "http://localhost:9090";
      "LANGFUSE_S3_BATCH_EXPORT_FORCE_PATH_STYLE" = "true";
      "LANGFUSE_S3_BATCH_EXPORT_PREFIX" = "exports/";
      "LANGFUSE_S3_BATCH_EXPORT_REGION" = "auto";
      "LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY" = "miniosecret";
      "LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID" = "minio";
      "LANGFUSE_S3_EVENT_UPLOAD_BUCKET" = "langfuse";
      "LANGFUSE_S3_EVENT_UPLOAD_ENDPOINT" = "http://minio:9000";
      "LANGFUSE_S3_EVENT_UPLOAD_FORCE_PATH_STYLE" = "true";
      "LANGFUSE_S3_EVENT_UPLOAD_PREFIX" = "events/";
      "LANGFUSE_S3_EVENT_UPLOAD_REGION" = "auto";
      "LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY" = "miniosecret";
      "LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID" = "minio";
      "LANGFUSE_S3_MEDIA_UPLOAD_BUCKET" = "langfuse";
      "LANGFUSE_S3_MEDIA_UPLOAD_ENDPOINT" = "http://localhost:9090";
      "LANGFUSE_S3_MEDIA_UPLOAD_FORCE_PATH_STYLE" = "true";
      "LANGFUSE_S3_MEDIA_UPLOAD_PREFIX" = "media/";
      "LANGFUSE_S3_MEDIA_UPLOAD_REGION" = "auto";
      "LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY" = "miniosecret";
      "LANGFUSE_USE_AZURE_BLOB" = "false";
      "LANGFUSE_USE_OCI_NATIVE_OBJECT_STORAGE" = "false";
      "NEXTAUTH_URL" = "http://localhost:3000";
      "REDIS_AUTH" = "myredissecret";
      "REDIS_HOST" = "redis";
      "REDIS_PORT" = "6379";
      "REDIS_TLS_CA" = "/certs/ca.crt";
      "REDIS_TLS_CERT" = "/certs/redis.crt";
      "REDIS_TLS_ENABLED" = "false";
      "REDIS_TLS_KEY" = "/certs/redis.key";
      "SALT" = "mysalt";
      "SMTP_CONNECTION_URL" = "";
      "TELEMETRY_ENABLED" = "true";
    };
    ports = [
      "127.0.0.1:3030:3030/tcp"
    ];
    dependsOn = [
      "langfuse-clickhouse"
      "langfuse-minio"
      "langfuse-postgres"
      "langfuse-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=langfuse-worker"
      "--network=langfuse_default"
    ];
  };

  systemd.services."podman-langfuse-langfuse-worker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-langfuse_default.service"
    ];
    requires = [
      "podman-network-langfuse_default.service"
    ];
    partOf = [
      "podman-compose-langfuse-root.target"
    ];
    wantedBy = [
      "podman-compose-langfuse-root.target"
    ];
  };

  virtualisation.oci-containers.containers."langfuse-minio" = {
    image = "cgr.dev/chainguard/minio";
    environment = {
      "MINIO_ROOT_PASSWORD" = "miniosecret";
      "MINIO_ROOT_USER" = "minio";
    };
    volumes = [
      "langfuse_langfuse_minio_data:/data:rw"
    ];
    ports = [
      "9090:9000/tcp"
      "127.0.0.1:9091:9001/tcp"
    ];
    cmd = [
      "-c"
      "mkdir -p /data/langfuse && minio server --address \":9000\" --console-address \":9001\" /data"
    ];
    log-driver = "journald";
    extraOptions = [
      "--entrypoint=[\"sh\"]"
      "--health-cmd=[\"mc\", \"ready\", \"local\"]"
      "--health-interval=1s"
      "--health-retries=5"
      "--health-start-period=1s"
      "--health-timeout=5s"
      "--network-alias=minio"
      "--network=langfuse_default"
    ];
  };

  systemd.services."podman-langfuse-minio" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_minio_data.service"
    ];
    requires = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_minio_data.service"
    ];
    partOf = [
      "podman-compose-langfuse-root.target"
    ];
    wantedBy = [
      "podman-compose-langfuse-root.target"
    ];
  };

  virtualisation.oci-containers.containers."langfuse-postgres" = {
    image = "docker.io/postgres:17";
    environment = {
      "PGTZ" = "UTC";
      "POSTGRES_DB" = "postgres";
      "POSTGRES_PASSWORD" = "postgres";
      "POSTGRES_USER" = "postgres";
      "TZ" = "UTC";
    };
    volumes = [
      "langfuse_langfuse_postgres_data:/var/lib/postgresql/data:rw"
    ];
    ports = [
      "127.0.0.1:5432:5432/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=pg_isready -U postgres"
      "--health-interval=3s"
      "--health-retries=10"
      "--health-timeout=3s"
      "--network-alias=postgres"
      "--network=langfuse_default"
    ];
  };

  systemd.services."podman-langfuse-postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_postgres_data.service"
    ];
    requires = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_postgres_data.service"
    ];
    partOf = [
      "podman-compose-langfuse-root.target"
    ];
    wantedBy = [
      "podman-compose-langfuse-root.target"
    ];
  };
  virtualisation.oci-containers.containers."langfuse-redis" = {
    image = "docker.io/redis:7";
    volumes = [
      "langfuse_langfuse_redis_data:/data:rw"
    ];
    ports = [
      "127.0.0.1:6379:6379/tcp"
    ];
    cmd = [
      "--requirepass"
      "myredissecret"
      "--maxmemory-policy"
      "noeviction"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=[\"redis-cli\", \"ping\"]"
      "--health-interval=3s"
      "--health-retries=10"
      "--health-timeout=10s"
      "--network-alias=redis"
      "--network=langfuse_default"
    ];
  };

  systemd.services."podman-langfuse-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_redis_data.service"
    ];
    requires = [
      "podman-network-langfuse_default.service"
      "podman-volume-langfuse_langfuse_redis_data.service"
    ];
    partOf = [
      "podman-compose-langfuse-root.target"
    ];
    wantedBy = [
      "podman-compose-langfuse-root.target"
    ];
  };
>>>>>>> 547409d (chore: nix fmt - non legacy formatter)

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
