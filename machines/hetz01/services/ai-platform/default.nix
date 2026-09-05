{ lib, config, ... }:
let
  bifrostPort = 8080;
  librechatPort = 3080;
  librechatPublicUrl = "https://ai.jakubpravda.net";
  # The only account permitted to sign in.
  librechatAdminUsers = [ "jkb.pravda@gmail.com" ];
  librechatUsers = [ ];
in
{
  sops.templates."bifrost.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder."bifrost/open_ai"}
      ANTHROPIC_API_KEY=${config.sops.placeholder."bifrost/anthropic"}
      GEMINI_API_KEY=${config.sops.placeholder."bifrost/gemini"}
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
      adminUsers = librechatAdminUsers;
      users = librechatUsers;
      port = librechatPort;
      env = {
        HOST = "127.0.0.1";
        # Traefik terminates TLS, so express must honour X-Forwarded-* to
        # build correct OAuth redirect URIs and to set secure cookies.
        TRUST_PROXY = 1;
        DOMAIN_CLIENT = librechatPublicUrl;
        DOMAIN_SERVER = librechatPublicUrl;

        # *** Authentication: Google SSO only ***
        ALLOW_EMAIL_LOGIN = false;
        ALLOW_REGISTRATION = false;
        ALLOW_PASSWORD_RESET = false;
        ALLOW_SOCIAL_LOGIN = true;
        # Never auto-create accounts from a social profile. Together with the
        # seeded user this limits sign-in to defined users.
        ALLOW_SOCIAL_REGISTRATION = false;
        GOOGLE_CALLBACK_URL = "/oauth/google/callback";

        IMAGE_GEN_OAI_BASEURL = "http://127.0.0.1:${toString bifrostPort}/v1";
        IMAGE_GEN_OAI_MODEL = "gemini/gemini-3.1-flash-image";
      };

      credentials = {
        CREDS_KEY = config.sops.secrets."librechat/creds_key".path;
        CREDS_IV = config.sops.secrets."librechat/creds_iv".path;
        JWT_SECRET = config.sops.secrets."librechat/jwt_secret".path;
        JWT_REFRESH_SECRET = config.sops.secrets."librechat/jwt_refresh_secret".path;
        GOOGLE_CLIENT_ID = config.sops.secrets."librechat/google_client_id".path;
        GOOGLE_CLIENT_SECRET = config.sops.secrets."librechat/google_client_secret".path;
        BIFROST_VK_SRAMEK_COPILOT = config.sops.secrets."bifrost/vk_sramek_copilot".path;
        IMAGE_GEN_OAI_API_KEY = config.sops.secrets."bifrost/vk_sramek_copilot".path;
      };

      settings = import ./librechat-settings.nix {
        inherit lib;
        inherit bifrostPort;
        allowedUsers = librechatAdminUsers ++ librechatUsers;
      };
    };
  };
}
