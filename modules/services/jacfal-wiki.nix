{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jacfal-wiki;
in {
  options.services.jacfal-wiki = {
    enable = mkEnableOption "jacfal-wiki";
  };
  # TODO commit script

  config = mkIf cfg.enable {
    # enable tiddly wiki server
    services.tiddlywiki = {
      enable = true;
      listenOptions = { port = 3456; };
    };
  };
}
