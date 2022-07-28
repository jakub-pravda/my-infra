{ config, ... }: 
{
  config.security.acme = {
    acceptTerms = true;
    defaults.email = "jacfal.tech@protonmail.com";
  };

  config.services.nginx = {
    enable = false;
    virtualHosts = {
      "cml.jakubpravda.net" = ({
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:9000/";
      });
    };
  };

}