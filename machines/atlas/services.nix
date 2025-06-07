{
  config,
  pkgs,
  ...
}: {
  config.services.influxdb = {
    enable = false;
    package = pkgs.influxdb;
  };
}
