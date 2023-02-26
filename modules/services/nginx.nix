{ config, lib, ... }:
with lib;
let
  cfg = config.services.my-nginx;
  wikiCfg = config.services.jacfal-wiki;
in {
  options.services.my-nginx = { enable = mkEnableOption "my-nginx"; };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "jacfal.tech@protonmail.com";
    };

    system.activationScripts.prepareNginx = ''
      mkdir -m 0755 -p /var/www/
    '';
    services.nginx = {
      enable = true;
      virtualHosts = {
        "wiki" = lib.mkIf wikiCfg.enable {
          forceSSL = true;
          serverName = "wiki.jakubpravda.net";
          enableACME = true;
          locations = {
            "/".extraConfig = ''
              proxy_pass http://127.0.0.1:3456/;
              proxy_set_header        Host             $host;
              proxy_set_header        X-Real-IP        $remote_addr;
              proxy_set_header        X-Forwarded-For  $proxy_add_x_forwarded_for;
              auth_basic "Restricted Content";
              auth_basic_user_file /etc/.wikipasswd;
            '';
          };
        };
      };
    };
  };
}
