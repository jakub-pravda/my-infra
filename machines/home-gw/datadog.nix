{ config, ... }: {
  config.services.datadog-agent = {
    enable = true;
    hostname = config.networking.hostName;
    site = "datadoghq.eu";
    apiKeyFile = config.age.secrets.datadog.path;
  };
}
