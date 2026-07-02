{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.oci-web-blog;
in
{
  options.services.oci-web-blog = {
    enable = mkEnableOption "oci-web-blog";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."web-blog" = {
      image = "ghcr.io/jakub-pravda/web-blog:b0c7b10";
      ports = [ "127.0.0.1:3001:3001" ];
    };
  };
}
