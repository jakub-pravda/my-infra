{
  pkgs,
  lib,
  my-infra-private,
  isWorkstation,
  isWsl,
  ...
}: let
  username = "jacob";
  dotFiles = pkgs.callPackage "${my-infra-private}/dotfiles.nix" {inherit pkgs;};

  # Following packages, programs definition is a minimal definition shared across all machines, whether it's a server or a workstation
  defaultPackages = with pkgs; [
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
    git
    nil
    nixpkgs-fmt

    # System tools
    openssh
    tmux
  ];

  workstationPackages = with pkgs;
    if isWorkstation
    then [
      # Productivity tools
      firefox
      spotify

      # IDE
      jetbrains.idea-community

      # Provisioning tools
      azure-cli
      tfswitch

      # Python development
      python3

      # Scala development
      jdk17_headless
      scala_3
      scala-cli
    ]
    else [];
in {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = defaultPackages ++ workstationPackages;
    stateVersion = "22.05";

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

            ${dotFiles.sshDotfile}
          '';
        };

      gitConfig = let
        config = builtins.readFile ./dotfiles/gitconfig;
      in
        pkgs.writeTextFile {
          name = "gitconfig";
          text = ''
            ${config}

            ${dotFiles.gitconfigDotfile}
          '';
        };
    in {
      ".ssh/config".source = sshConfig;
      ".gitconfig".source = gitConfig;
    };
  };

  programs = {
    home-manager.enable = true;

    # *** Default programs ***
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

        # ssh agent
        eval $(ssh-agent -s)
        if [ -e ~/.ssh/id_ed25519_github ]; then
          ssh-add ~/.ssh/id_ed25519_github
        fi
      '';

      oh-my-zsh = {
        enable = true;
        theme = "eastwood";
        plugins = [
          "aliases"
          "colorize"
          "docker"
          "git"
          "sudo"
          "systemd"
        ];
      };
    };
    # *** Workstation only programs ***
    vscode = {
      enable = isWorkstation && !isWsl;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
        ms-python.python
        jnoortheen.nix-ide
        tamasfe.even-better-toml
        timonwong.shellcheck
      ];
    };
  };
}
