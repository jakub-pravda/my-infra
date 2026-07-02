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
      };
    };
  };
}
