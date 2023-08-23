{...}: let
  hubConfigFilename = "iot-hub.nix";

  # define functions
  containsHubConfig = folder:
    builtins.pathExists "${folder}/${hubConfigFilename}";
  getHubConfig = dir: (
    if containsHubConfig dir
    then import "${dir}/${hubConfigFilename}"
    else {}
  );
  getAllHubConfigs = rootDir: let
    allDirs = builtins.mapAttrs (file: type:
      if type == "directory"
      then (getHubConfig "${rootDir}/${file}")
      else {}) (builtins.readDir rootDir);
  in
    builtins.filter (s: s != {}) (builtins.attrValues allDirs);
in {
  # expose functions
  inherit containsHubConfig;
  inherit getHubConfig;
  inherit getAllHubConfigs;
}
