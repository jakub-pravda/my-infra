{ config, ... }: {
  config.services.datadog-agent = {
    enable = true;
    hostname = config.networking.hostName;
    site = "datadoghq.eu";
    apiKeyFile = /run/keys/datadog_api_key;
  };
}
