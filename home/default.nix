{
  pkgs,
  my-infra-private,
  ...
}: let
  username = "jacob";
in {
  # Following packages, programs definition is a minimal definition shared across all machines, whether it's a server or a workstation
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "22.05";

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

    # Manage dotfiles
    file = let
      # store private and public configs together
      sshConfig = let
        config = builtins.readFile ./dotfiles/sshconfig;
      in
        pkgs.writeTextFile {
          name = "sshconfig";
          text = ''
            ${config}

            ${my-infra-private.lib.sshDotfile}
          '';
        };

      gitConfig = let
        config = builtins.readFile ./dotfiles/gitconfig;
      in
        pkgs.writeTextFile {
          name = "gitconfig";
          text = ''
            ${config}

            ${my-infra-private.lib.gitconfigDotfile}
          '';
        };
    in {
      ".ssh/config".source = sshConfig;
      ".gitconfig".source = gitConfig;
    };
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
