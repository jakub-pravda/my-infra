{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.nixosTest ({
  name = "jacfal-wiki";
  nodes = {
    server = { ... }: {
      imports = [
        ../modules/services/jacfal-wiki.nix
      ];
      services.jacfal-wiki.enable = true;
    };
  };

  testScript = ''
    import os

    start_all()
    server.wait_for_unit("clone-jacfal-wiki")
  
    if os.path.exists("/srv/www/jacfal-wiki/personal-wiki.html"):
      raise Exception("Wiki file not exists")
  '';
})