# { pkgs, ... }:
# pkgs.nixosTest ({
#   name = "gohome-services";
#   nodes = {
#     server = { ... }: {
#       imports = [
#         ../modules/services/tss.nix
#       ];
#       services.trv-sesnsor-sync.enable = true;
#     };
#   };
#   testScript = ''
#     import os
#     start_all()
#     server.wait_for_unit("tss")
#   '';
# })
{
  nodes = {
    machine = {
      config,
      pkgs,
      ...
    }: {
      pkgs.redis.enable = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("redis")
  '';
}
