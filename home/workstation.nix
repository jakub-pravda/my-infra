{pkgs, ...}: {
  # Following packages, programs definition suits best for a workstation machines
  home = {
    packages = with pkgs; [
      # IDE
      jetbrains.idea-community

      # Provisioning tools
      azure-cli
      packer
      tfswitch

      # Python development
      python3

      # Scala development
      jdk17_headless
      scala_3
      scala-cli

    ];
  };

  programs = {
    vscode = {
      enable = false;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
        jnoortheen.nix-ide
        timonwong.shellcheck
      ];
    };
  };
}
