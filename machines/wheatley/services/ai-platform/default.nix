{ config, ... }:
let
  bifrostPort = 8080;
in
{
  sops.templates."bifrost.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder."api_gw_keys/open_ai"}
      ANTHROPIC_API_KEY=${config.sops.placeholder."api_gw_keys/anthrophic"}
    '';
    restartUnits = [ "bifrost.service" ];
  };

  environment.sessionVariables = {
    # Set anthrophic base url to bifrost to redirect requests from code assistants (claude code, ...)
    ANTHROPIC_BASE_URL = "http://localhost:${toString bifrostPort}/anthropic";
  };

  services.ai-platform = {
    enable = true;
    librechat.enable = false;

    bifrost = {
      port = bifrostPort;
      settings = import ./bifrost-settings.nix { };
      environmentFile = config.sops.templates."bifrost.env".path;
    };
  };
}
