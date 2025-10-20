{ lib, config, ... }: {

  options.containerOptions = {
    persesContainerPort = lib.mkOption {
      type = lib.types.int;
      description = "Perses external container port";
      default = 8080;
    };

    containerUser = lib.mkOption {
      type = lib.types.str;
      description = "User for running containers";
    };
  };

  config = {
    virtualisation = {
      podman.enable = true;
      oci-containers = {
        backend = "podman";
        containers = {
          # Temporary perses instance
          # Replace with NixOs service when perses PR merged!
          # https://github.com/NixOS/nixpkgs/pull/411771
          "perses" = {
            image = "persesdev/perses:main-2025-10-14-7a2570a1-distroless-debug";
            # ports = [ "127.0.0.1:8082:8080" ];
            extraOptions = [ "--network=host" ];
          };
          "web-blog" = {
            image = "ghcr.io/jakub-pravda/web-blog:a0f7a93";
            ports = [ "127.0.0.1:3000:3000" ];
          };
        };
      };
    };
  };
}
