{ config, ... }: {
  services = {
    openssh.enable = true;
    # *** GITLAB runners ***
    github-runners."atlas-ci" = {
      enable = true;
      url = "https://github.com/jakub-pravda/my-infra/";
      tokenFile = config.sops.secrets."services/github/atlas_runner_pat".path;
      # remark: github user has access to the private nixos configuration
      user = "github";
    };
    # *** Traefik config ***
    traefik = let dataDir = "/var/lib/traefik";
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
            address = "195.201.240.89:80";
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
          websecure = { address = "195.201.240.89:443"; };
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
                servers = [{ url = "http://localhost:3000"; }];
              };
            };
          };
        };
      };
    };
  };
}
