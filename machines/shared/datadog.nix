{ config, ... }: 
let
 whoami = config.networking.hostName; 
in {
  # load datadog secret
  config.age.secrets.datadog = {
    file = ../${whoami}/secrets/datadog.age;
    owner = "datadog";
    group = "datadog";
  };
  
  # service config
  config.services.datadog-agent = {
    enable = true;
    hostname = config.networking.hostName;
    site = "datadoghq.eu";
    apiKeyFile = config.age.secrets.datadog.path;
  };
}
