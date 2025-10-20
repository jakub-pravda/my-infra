{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.perses-dashboard-deploy;
  deploymentDir = pkgs.stdenv.mkDerivation {
    name = "dahboards-dir";
    src = ../../dashboards/built; # your directory

    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
      echo "Deployment dir content"
      cd $out && ls -l
    '';
  };
  deploymentScript = pkgs.writeShellScriptBin "dashboard-deployment" ''
    delay_seconds=5
    max_attempts=5
    attempt=1
    while ! percli login http://localhost:8080; do
      if ((attempt >= max_attempts)); then
          echo "Perses login failed"
          exit 1
      fi
      echo "Attempt $attempt failed. Retrying in $delay_seconds seconds..."
      sleep $delay_seconds
      ((attempt++))
    done  
    percli apply -d ${deploymentDir}
  '';
in {
  options.services.perses-dashboard-deploy = {
    enable = mkEnableOption "perses-dashboard-deploy";
  };

  config = mkIf cfg.enable {
    systemd.services."perses-dashboard-deploy" = {
      serviceConfig = { Type = "oneshot"; };
      wantedBy = [ "multi-user.target" ];
      requires = [ "podman-perses.service" ];
      after = [ "network.target" "podman-perses.service" ];
      serviceConfig = { RemainAfterExit = true; };
      environment = {
        HOME = "./tmp"; # needed by percli
      };
      path = with pkgs; [ cue perses ];
      script = builtins.readFile "${deploymentScript}/bin/dashboard-deployment";
    };
  };
}
