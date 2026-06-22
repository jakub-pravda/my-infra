{ ... }: {
  services = {
    openssh.enable = true;
    # *** Traefik config ***
    traefik = let
      ingressIpAddress = "167.233.126.106";
      dataDir = "/var/lib/traefik";
    in {
      enable = true;
      inherit dataDir;
      staticConfigOptions = {
        api = { };
        accessLog = {
          filePath = "${dataDir}/access.log";
          format = "json";
        };
        log = {
          level = "DEBUG";
          filePath = "${dataDir}/traefik.log";
          format = "json";
        };
        entryPoints = {
          web = {
            address = "${ingressIpAddress}:80";
            http = {
              redirections = {
                entryPoint = {
                  to = "websecure";
                  scheme = "https";
                  permanent = true;
                };
              };
            };
          };
          websecure = { address = "${ingressIpAddress}:443"; };
        };
        certificatesResolvers = {
          letsencrypt = {
            acme = {
              email = "jakub.pravda@pm.me";
              storage = "${dataDir}/acme.json";
              caServer = "https://acme-v02.api.letsencrypt.org/directory";
              httpChallenge = { entryPoint = "web"; };
            };
          };
        };
      };
      dynamicConfigOptions = {
        http = {
          routers = {
            router1 = {
              entryPoints = [ "web" "websecure" ];
              rule = "Host(`jakubpravda.net`) && PathPrefix(`/`)";
              tls = { certResolver = "letsencrypt"; };
              service = "web-blog";
            };
          };
          services = {
            web-blog = {
              loadBalancer = {
                servers = [{ url = "http://localhost:3001"; }];
              };
            };
          };
        };
      };
    };
  };
}
