{
  config,
  pkgs,
  ...
}: let
  iotCmlCfg = config.services.iot-cml;

  dashboardTemplate = pkgs.callPackage ./snzb02.nix {} "P2596F1C8E12435D2"; # fixed datasource uid, need to update to unstable nix to have grafana with uid options
  snzbFilter = devices: builtins.filter (device: device.type == "SNZB-02") devices;

  snzbDevicesTemplates = pkgs.lib.flatten (map (hubConfig: (
      map (device: dashboardTemplate "${device.location}/${device.name}" "${hubConfig.id}/${device.location}/${device.name}") (snzbFilter hubConfig.devices)
    ))
    iotCmlCfg.hubConfigs);

  dashboardDir = let
    linkTemplate = map (templatePath: "ln -s ${templatePath} $out/${builtins.baseNameOf templatePath}.json") snzbDevicesTemplates;
  in
    pkgs.runCommand "snzb-dashboards" {
      preferLocalBuild = true;
    }
    ''
      mkdir -p $out
      ${builtins.concatStringsSep "\n" linkTemplate}
    '';
in {
  name = "snzb02-test-dashboard";
  type = "file";
  updateIntervalSeconds = 60;
  options = {
    path = dashboardDir;
    foldersFromFilesStructure = true;
  };
}
