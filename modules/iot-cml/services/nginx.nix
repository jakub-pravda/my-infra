{ config, ... }: 
{
  config.security.acme = {
    acceptTerms = true;
    defaults.email = "jacfal.tech@protonmail.com";
  };

  config.services.nginx = {
    enable = true;
    virtualHosts = {
      "iot_data_pipeline" = ({
        forceSSL = true;
        serverName = "cml.jakubpravda.net";
        enableACME = true;
        listen = [{ port = 4862; addr = "0.0.0.0"; ssl = true;}];
        locations."/" = {
          proxyPass = "http://127.0.0.1:2684/telegraf";
          extraConfig = ''
            auth_basic "Restricted Content";
            auth_basic_user_file /etc/.htpasswd;
          '';
        };
      });
    };
  };
}