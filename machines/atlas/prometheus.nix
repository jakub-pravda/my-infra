{ config, ... }: {
  services.prometheus = {
    enable = true;
    port = 9090;
    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [{
      job_name = "vps-atlas";
      static_configs = [{
        targets = [
          "localhost:${toString config.services.prometheus.exporters.node.port}"
        ];
      }];
    }];
  };
}
