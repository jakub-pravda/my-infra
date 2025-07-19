{ ... }: {
  virtualisation.podman = { enable = true; };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      "web-blog" = {
        image = "ghcr.io/jakub-pravda/web-blog:29fe671";
        ports = [ "127.0.0.1:3000:3000" ];
      };
    };
  };
}
