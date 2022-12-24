{ config, pkgs, ... }:
let
  # ** DATA SOURCES **
  questDb = {
    name = "QuestDB";
    uid = "P2596F1C8E12435D2";
    type = "postgres";
    url = "localhost:8812";
    database = "qdb";
    user = "admin";
    jsonData = {
      postgresVersion = 903;
      sslmode = "disable";
    };
    secureJsonData = { password = "quest"; };
  };

  # ** DASHBOARDS **
  snzb02SenzorDashboard = (import ./grafana/templates/snzb02dashboard.nix {
    inherit config;
    inherit pkgs;
  });
in {
  config.services.grafana = {
    enable = true;
    settings = {
      server.http_addr = "localhost";
      server.http_port = 3000;
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [ questDb ];
      dashboards.settings.providers = [ snzb02SenzorDashboard ];
    };
  };
}
