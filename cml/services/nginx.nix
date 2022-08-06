{ config, ... }: 
{
  config.security.acme = {
    acceptTerms = true;
    defaults.email = "jacfal.tech@protonmail.com";
  };

  config.services.nginx = {
    enable = true;
    virtualHosts = {
      "test_connection" = ({
        forceSSL = true;
        serverName = "cml.jakubpravda.net";
        enableACME = true;
        listen = [{ port = 443; addr = "0.0.0.0"; ssl = true;}];
        locations."/" = {
          proxyPass = "http://127.0.0.1:9000/";
          extraConfig = ''
            auth_basic "Restricted Content";
            auth_basic_user_file /etc/.htpasswd;
          '';
        };
      });
      "iot_data_pipeline" = ({
        forceSSL = true;
        serverName = "cml.jakubpravda.net";
        enableACME = true;
        listen = [{ port = 4862; addr = "0.0.0.0"; ssl = true;}];
        locations."/" = {
          proxyPass = "http://127.0.0.1:2684/";
          extraConfig = ''
            auth_basic "Restricted Content";
            auth_basic_user_file /etc/.htpasswd;
          '';
        };
      });
    };
    streamConfig = ''
      server {
        listen 8883;
        proxy_pass 127.0.0.1:1883;
        ssl_certificate /var/lib/acme/cml.jakubpravda.net/fullchain.pem;
        ssl_certificate_key /var/lib/acme/cml.jakubpravda.net/key.pem;
        ssl_trusted_certificate /var/lib/acme/cml.jakubpravda.net/chain.pem;
      }
    '';
  };
}