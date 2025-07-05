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

  pkgsDefaultJava = pkgs.jdk17;

  # Following packages, programs definition is a minimal definition shared across all machines, whether it's a server or a workstation
  defaultPackages = with pkgs; [
    # Monitoring tools
    atop
    bottom
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
    kitty

    # System tools
    openssh
    tmux
  ];

  workstationPackages = with pkgs;
    (
      if isWorkstation
      then [
        # Nix
        nil
        nixpkgs-fmt

        # Provisioning tools
        awscli2
        azure-cli
        tfswitch

        # Development
        jetbrains.idea-community

        # Golang development
        go

        # Python development
        poetry
        (python312.withPackages (
          ps:
            with ps; [
              black
              flake8
              mypy
              pip
              pylint
              pytest
              ruff
            ]
        ))

        # Rust development
        rustup

        # Scala development
        metals
        sbt
        scala_3
        scala-cli
      ]
      else []
    )
    ++
    # Workstation packages
    (
      if isWorkstation && !isWsl
      then [
        # Productivity tools
        firefox
        google-chrome
        libreoffice
        spotify

        # Note taking
        obsidian

        # Development
        zed-editor
      ]
      else []
    );
in {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = defaultPackages ++ workstationPackages;
    stateVersion = "22.05";

    shellAliases = {
      htop = "btm";
    };

    # Manage dotfiles (on workstations only)
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
        config =
          if isCI
          then ""
          else builtins.readFile ./dotfiles/gitconfig;
      in
        pkgs.writeTextFile {
          name = "gitconfig";
          text = ''
            ${config}

            ${dotFiles.gitconfigDotfile}
          '';
        };

      awsConfig = pkgs.writeTextFile {
        name = "awsconfig";
        text = dotFiles.awsConfigDotfile;
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

      kittyThemeConfig = pkgs.writeTextFile {
        name = "kitty";
        text =
          if isCI
          then "# CI dummy kitty theme"
          else builtins.readFile ./dotfiles/kitty-theme.conf;
      };

      kittyConfig = pkgs.writeTextFile {
        name = "kitty";
        text = builtins.readFile ./dotfiles/kitty.conf;
      };

      kittyThemeConfig = pkgs.writeTextFile {
        name = "kitty";
        text = builtins.readFile ./dotfiles/kitty-theme.conf;
      };

      zedConfig = pkgs.writeTextFile {
        name = "zed";
        text = builtins.readFile ./dotfiles/zed-conf.jsonc;
      };
    in
      lib.mkIf isWorkstation {
        ".ssh/config".source = sshConfig;
        ".gitconfig".source = gitConfig;
        ".aws/config".source = awsConfig;
        "/home/jacob/.config/kitty/kitty.conf".source = kittyConfig;
        "/home/jacob/.config/kitty/kitty-theme.conf".source = kittyThemeConfig;
        "/home/jacob/.config/zed/settings.json".source = zedConfig;
      };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      JAVA_HOME = pkgsDefaultJava;
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

      autosuggestion.enable = true;
      enableCompletion = true;
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

        export PATH="$HOME/bin:$PATH"
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
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;

      extensions = with pkgs.vscode-extensions; [
        charliermarsh.ruff
        github.copilot
        github.copilot-chat
        golang.go
        jnoortheen.nix-ide
        matangover.mypy
        ms-python.python
        ms-toolsai.jupyter
        rust-lang.rust-analyzer
        scala-lang.scala
        scalameta.metals
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        timonwong.shellcheck
        vscodevim.vim
        vscode-icons-team.vscode-icons
      ];
    };
  };
}
