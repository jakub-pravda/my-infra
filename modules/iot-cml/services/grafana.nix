{ config, ... }:
{
  config.services.grafana = {
    enable = true;
  };
  # TODO access from internet
  # TODO dashboard provisioning
}