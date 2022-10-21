{ pkgs, ... }:
let
  dashboardTemplate =  pkgs.callPackage ./snzb02.nix { } "P2596F1C8E12435D2"; # fixed datasource uid, need to update to unstable nix to have grafana with uid options
 
  lrSensorDashboard = dashboardTemplate "kitchen/son-sns-01" "zigbee2mqtt/kitchen/son-sns-01";

  dashboardDir = pkgs.runCommand "logstash-settings" {
    inherit lrSensorDashboard;
    preferLocalBuild = true;
  } 
  ''
  mkdir -p $out
  ln -s $lrSensorDashboard $out/lr-snzb02.json
  '';
in
{
  name = "snzb02-test-dashboard";
  type = "file";
  updateIntervalSeconds = 60;
  options = {
    path                      = dashboardDir;
    foldersFromFilesStructure  = true;
  };
}