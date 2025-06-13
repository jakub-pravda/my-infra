{
  config,
  pkgs,
  ...
}: {
  config.services.influxdb = {
    enable = true;
    package = pkgs.influxdb3;
  };
}
