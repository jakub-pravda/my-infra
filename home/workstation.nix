{pkgs, ...}: {
  # Following packages, programs definition suits best for a workstation machines
  home = {
    packages = with pkgs; [
      # Provisioning tools
      azure-cli
      packer
      tfswitch

      # Python development
      python3

      # Scala development
      scala_3
      scala-cli
      jdk17_headless
    ];
  };

  programs = {
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        github.copilot
        github.copilot-chat
        jnoortheen.nix-ide
        timonwong.shellcheck
      ];
    };
  };
}
