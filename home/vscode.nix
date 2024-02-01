{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      github.copilot
      github.copilot-chat
      jnoortheen.nix-ide
      timonwong.shellcheck
    ];
  };
}
