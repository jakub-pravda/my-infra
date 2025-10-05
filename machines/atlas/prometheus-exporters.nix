{ ... }: {
  services.prometheus.exporters = {
    # exporter for hardware and OS metrics
    node = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9100;
    };
  };
}
