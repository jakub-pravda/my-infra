{ config, ... }: 
{
  config.services.nginx = {
    enable = false;
    virtualHosts = {
      "37.205.13.151" = ({
        locations."/".proxyPass = "http://127.0.0.1:9000/";

        serverAliases = [
          "www.domain.tld"
        ];
      });
    };
  };

}