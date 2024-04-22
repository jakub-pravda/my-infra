{
  config,
  lib,
  pkgs,
  ...
}:
# Flake update was originally handled by a github actions job, but I haven't found a way how to
#  grant access to private repo for `nix flake update` from github actions (as access to my-infra
#  private is needed for the update). So I've moved the update to a systemd timer.
with lib; let
  cfg = config.services.flake-update;
in {
  options.services.flake-update = {
    enable = mkEnableOption "flake-update";

    myInfraPublicRepo = mkOption {
      type = types.str;
      description = "my-infra public repo";
      default = "jakub-pravda/my-infra.git";
    };

    myInfraPrivateRepo = mkOption {
      type = types.str;
      description = "my-infra private repo";
      default = "jakub-pravda/my-infra-private.git";
    };
  };

  config = mkIf cfg.enable {
    systemd.timers."flake-update" = {
      description = "My infra flake update timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };

    systemd.services."flake-update" = {
      serviceConfig = {
        Type = "oneshot";
        User = "jacob"; # TODO bind service user
      };
      path = [
        pkgs.git
        pkgs.openssh
        pkgs.nix
      ];
      script = ''
        set -eu
        TMP_FILE=$(mktemp -d /tmp/XXXX=my-infra)
        trap 'rm --recursive --force $TMP_FILE' INT QUIT TERM EXIT
        # try to clone
        if [[ $(git ls-remote git@github.com:${cfg.myInfraPrivateRepo}) ]]; then
          echo "Private repo access granted"
          git clone git@github.com:${cfg.myInfraPublicRepo} $TMP_FILE
          cd $TMP_FILE
          nix flake update
          git add flake.lock
          git commit --author="Flake update bot <>" -m "Periodic flake update"
          git push
        else
          echo "Can't access private repository"
          exit 1
        fi
      '';
    };
  };
}
