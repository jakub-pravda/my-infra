{config, ...}: let
  bifrostPort = 8080;
in {
  sops.templates."bifrost.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder."api_gw_keys/open_ai"}
      ANTHROPIC_API_KEY=${config.sops.placeholder."api_gw_keys/anthrophic"}
    '';
    restartUnits = ["bifrost.service"];
  };

  environment.sessionVariables = {
    ANTHROPIC_BASE_URL = "http://localhost:${toString bifrostPort}/anthropic";
  };

  services.bifrost = {
    enable = true;
    port = bifrostPort;
    settings = import ./config.nix {};
    environmentFile = config.sops.templates."bifrost.env".path;
  };
}
