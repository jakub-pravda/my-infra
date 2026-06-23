{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  config = {
    sops = {
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/jacob/.config/sops/age/keys.txt";
      secrets."langfuse/clickhouse/password" = { };
      secrets."langfuse/postgres/password" = { };
      secrets."langfuse/minio/password" = { };
      secrets."langfuse/redis/password" = { };
      secrets."langfuse/next_auth_secret" = { };
      secrets."langfuse/salt" = { };
      secrets."langfuse/encryption_key" = { };
    };
  };
}
