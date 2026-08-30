{ config, ... }:
let
  bifrostPort = 8080;
  librechatPort = 3080;
in
{
  sops.templates."bifrost.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder."bifrost/open_ai"}
    '';
    restartUnits = [ "bifrost.service" ];
  };

  services.ai-platform = {
    enable = true;

    bifrost = {
      port = bifrostPort;
      settings = import ./bifrost-settings.nix { };
      environmentFile = config.sops.templates."bifrost.env".path;
    };

    librechat = {
      port = librechatPort;
      env = {
        HOST = "127.0.0.1";
        ALLOW_REGISTRATION = true;
        ALLOW_EMAIL_LOGIN = true;
        ALLOW_SOCIAL_LOGIN = false;
      };

      credentials = {
        CREDS_KEY = config.sops.secrets."librechat/creds_key".path;
        CREDS_IV = config.sops.secrets."librechat/creds_iv".path;
        JWT_SECRET = config.sops.secrets."librechat/jwt_secret".path;
        JWT_REFRESH_SECRET = config.sops.secrets."librechat/jwt_refresh_secret".path;
        # Referenced as ''${BIFROST_OPENAI_KEY} from librechat-settings.nix below
        BIFROST_OPENAI_KEY = config.sops.secrets."bifrost/open_ai".path;
      };

      settings = import ./librechat-settings.nix { inherit bifrostPort; };
    };
  };
}
