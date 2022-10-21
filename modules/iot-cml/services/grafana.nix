{ config, pkgs, ... }:
let
  # ** DATA SOURCES **
  questDb = {
    name            = "QuestDB";
    #uid             = "H3CoF8i4k"; # currently only in unstable
    type            = "postgres";
    url             = "localhost:8812";
    database        = "qdb";
    user            = "admin";
    jsonData        = { postgresVersion = 903; sslmode = "disable"; };
    secureJsonData  = { password = "quest"; };
  };

  # ** DASHBOARDS **
  snzb02SenzorDashboard = (import ./grafana/templates/snzb02dashboard.nix { inherit pkgs; });
in
{
  config.services.grafana = {
    enable = true;

    provision = {
      enable = true;
      datasources = [ questDb ];
      dashboards = [
        snzb02SenzorDashboard
      ];
    };
  };
}