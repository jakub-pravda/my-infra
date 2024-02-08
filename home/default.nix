{pkgs, ...}: let
  username = "jacob";
in {
  # Following packages, programs definition is a minimal definition shared across all machines, whether it's a server or a workstation
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "22.05";

    # Manage dotfiles
    file = {
      ".ssh/config".source = ./dotfiles/sshconfig;
    };

    # Packages definition
    packages = with pkgs; [
      # Monitoring tools
      atop
      du-dust
      duf
      procs

      # Networking tools
      curl
      grpcurl
      wireshark
      whois

      # Development tools
      nil
      nixpkgs-fmt

      # System tools
      openssh
      tmux
    ];
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userEmail = "me@jakubpravda.net";
      userName = "Jakub Pravda";
    };

    neovim.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
      '';

      oh-my-zsh = {
        enable = true;
        theme = "eastwood";
        plugins = [
          "git"
          "sudo"
        ];
      };
    };
  };
}
