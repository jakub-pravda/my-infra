{pkgs, ...}: let
  defaultPath = /etc/.secrets;
  secretFile = filename: (builtins.readFile (defaultPath + filename));
in
  filename: let
    contentList = builtins.split ":" (secretFile filename);
  in {
    username = builtins.elemAt contentList 0;
    password = pkgs.lib.last contentList;
  }
