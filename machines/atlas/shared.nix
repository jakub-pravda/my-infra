# TODO move me to shared module
{ pkgs, ... }: {
  programs = {
    # *** Default programs ***
    neovim.enable = true;
    zsh = {
      enable = true;

      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "eastwood";
        plugins = [ "aliases" "colorize" "docker" "git" "sudo" "systemd" ];
      };
    };
  };
  users.extraUsers."jacob".shell = pkgs.zsh;
}
