{ config, ... }:
let
  librechatPort = 3080;
  bifrostPort = 8080;
in
{
  services.librechat = {
    enable = true;

    # Local MongoDB, the only datastore librechat strictly needs.
    enableLocalDB = true;

    env = {
      HOST = "127.0.0.1";
      PORT = librechatPort;
      ALLOW_REGISTRATION = true;
      ALLOW_EMAIL_LOGIN = true;
      ALLOW_SOCIAL_LOGIN = false;
    };

    credentials = {
      CREDS_KEY = config.sops.secrets."librechat/creds_key".path;
      CREDS_IV = config.sops.secrets."librechat/creds_iv".path;
      JWT_SECRET = config.sops.secrets."librechat/jwt_secret".path;
      JWT_REFRESH_SECRET = config.sops.secrets."librechat/jwt_refresh_secret".path;
      # Referenced as ''${BIFROST_OPENAI_KEY} from settings below
      BIFROST_OPENAI_KEY = config.sops.secrets."bifrost/open_ai".path;
    };

    settings = import ./config.nix { inherit bifrostPort; };
  };
}
