{ lib, config, ... }:
with lib;
let
  cfg = config.services.ai-platform;
in
{
  options.services.ai-platform = {
    enable = mkEnableOption "AI platform";

    bifrost = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable the Bifrost AI gateway.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Port the Bifrost AI gateway listens on.";
      };

      settings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Bifrost config.json content, see services.bifrost.settings.";
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a file supplying secrets referenced from bifrost settings, see services.bifrost.environmentFile.";
      };
    };

    librechat = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable LibreChat.";
      };

      port = mkOption {
        type = types.port;
        default = 3080;
        description = "Port LibreChat listens on.";
      };

      env = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Extra environment variables for LibreChat, see services.librechat.env.";
      };

      credentials = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = "Secrets loaded as systemd credentials for LibreChat, see services.librechat.credentials.";
      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        description = "librechat.yaml content, see services.librechat.settings.";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.bifrost.enable {
      services.bifrost = {
        enable = true;
        port = cfg.bifrost.port;
        settings = cfg.bifrost.settings;
        environmentFile = cfg.bifrost.environmentFile;
      };
    })

    (mkIf cfg.librechat.enable {
      services.librechat = {
        enable = true;
        enableLocalDB = true;
        env = cfg.librechat.env // {
          PORT = cfg.librechat.port;
        };
        credentials = cfg.librechat.credentials;
        settings = cfg.librechat.settings;
      };
    })
  ];
}
