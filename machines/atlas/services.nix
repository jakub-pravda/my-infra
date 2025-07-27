{ config, ...}:
{
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
    traefik = {
      enable = true;
      dataDir = "/var/lib/traefik";
      staticConfigOptions = {
        api = { };
        accessLog = { 
          filePath = "/var/lib/traefik/access.log";
          format = "json";
        };
        log = {
          level = "DEBUG";
          filePath = "/var/lib/traefik/traefik.log";
          format = "json";
        };
        entryPoints = {
          http = {
            address = "195.201.240.89:80";
          };
        };
      };
      dynamicConfigOptions = {
        http = {
          routers = {
            router1 = {
              entryPoints = ["http"];
              rule = "PathPrefix(`/`)";
              service = "web-blog";
            };
          };
          services = {
            web-blog = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:3000";
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}
