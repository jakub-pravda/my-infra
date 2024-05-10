{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.auto-update;
in {
  options.services.auto-update = {
    enable = mkEnableOption "auto-update";

    myInfraGithubRepo = mkOption {
      type = types.str;
      description = "my-infra github repo";
      default = "jakub-pravda/my-infra";
    };

    flakeToUse = mkOption {
      type = types.str;
      description = "Flake to use for machine upgrade";
    };
  };

  config = mkIf cfg.enable {
    systemd.timers."auto-update" = {
      description = "Machine auto update timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    systemd.services."auto-update" = {
      serviceConfig = {
        Type = "oneshot";
      };
      path = [
        pkgs.nixos-rebuild
      ];
      script = ''
        nixos-rebuild dry-build --flake github:${cfg.myInfraGithubRepo}#${cfg.flakeToUse}
      '';
    };
  };
}
