{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  config = {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.users.users.jacob.home}/.config/sops/age/keys.txt";
      secrets = {
        "langfuse/clickhouse/password" = { };
        "langfuse/postgres/password" = { };
        "langfuse/minio/password" = { };
        "langfuse/redis/password" = { };
        "langfuse/next_auth_secret" = { };
        "langfuse/salt" = { };
        "langfuse/encryption_key" = { };
        "bifrost/open_ai" = { };
        "bifrost/anthropic" = { };
        "bifrost/gemini" = { };
        "bifrost/vk_sramek_copilot" = { };
        "librechat/creds_key".restartUnits = [ "librechat.service" ];
        "librechat/creds_iv".restartUnits = [ "librechat.service" ];
        "librechat/jwt_secret".restartUnits = [ "librechat.service" ];
        "librechat/jwt_refresh_secret".restartUnits = [ "librechat.service" ];
        "librechat/google_client_id".restartUnits = [ "librechat.service" ];
        "librechat/google_client_secret".restartUnits = [ "librechat.service" ];
      };
    };
  };
}
