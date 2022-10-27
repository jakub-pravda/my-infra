{ config, pkgs, ... }:
let
  iotCfg = config.iot;
  dashboardTemplate =  pkgs.callPackage ./snzb02.nix { } "P2596F1C8E12435D2"; # fixed datasource uid, need to update to unstable nix to have grafana with uid options
  snzbDevices = builtins.filter (device: device.type == "SNZB-02") iotCfg.devices;

  snzbDevicesTemplates = map (device: dashboardTemplate "${device.location}/${device.name}" "${iotCfg.hubName}/${device.location}/${device.name}") snzbDevices;
  dashboardDir =
  let
    linkTemplate = map (templatePath: "ln -s ${templatePath} $out/${builtins.baseNameOf templatePath}.json") snzbDevicesTemplates;
  in pkgs.runCommand "snzb-dashboards" {
    preferLocalBuild = true;
  } 
  ''
  mkdir -p $out
  ${builtins.concatStringsSep "\n" linkTemplate}
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