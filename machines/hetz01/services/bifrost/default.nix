{ config, ... }:
let
  bifrostPort = 8080;
in
{
  sops.templates."bifrost.env" = {
    content = ''
      OPENAI_API_KEY=${config.sops.placeholder."bifrost/open_ai"}
    '';
    restartUnits = [ "bifrost.service" ];
  };

  services.bifrost = {
    enable = true;
    port = bifrostPort;
    settings = import ./config.nix { };
    environmentFile = config.sops.templates."bifrost.env".path;
  };
}
