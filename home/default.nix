{ pkgs, lib, username ? "jacob", additionalPackages ? [ ]
, additionalPrograms ? { }, configFiles ? { }, ... }:
let
  homeDirectory = "/home/${username}";
  pkgsDefaultJava = pkgs.jdk21;

  defaultPackages = import ./packages.nix { inherit pkgs lib; };
in {
  home = {
    inherit username;
    inherit homeDirectory;
    packages = defaultPackages ++ additionalPackages;
    stateVersion = "24.11";

    shellAliases = { htop = "btm"; };

    # Manage dotfiles (on workstations only)
    # file = import ./configs.nix { inherit pkgs; };
    file = configFiles;

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PAGER = "less";
      JAVA_HOME = pkgsDefaultJava;

      # For python development
      #LD_LIBRARY_PATH = $LD_LIBRARY_PATH:pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc];
    };
  };

  programs = lib.recursiveUpdate {
    home-manager.enable = true;

    zsh = {
      enable = true;

      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        # ssh agent
        eval $(ssh-agent -s)
        if [ -e ~/.ssh/id_ed25519_github ]; then
          ssh-add ~/.ssh/id_ed25519_github
        fi

        export PATH="$HOME/bin:$PATH"
      '';

      oh-my-zsh = {
        enable = true;
        theme = "eastwood";
        plugins = [ "aliases" "colorize" "docker" "git" "sudo" "systemd" ];
      };
    };
  } additionalPrograms;
}
