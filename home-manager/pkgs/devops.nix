{ pkgs, ... }: {
  home = { packages = with pkgs; [ azure-cli packer tfswitch ]; };
}
