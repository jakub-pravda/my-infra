{ pkgs }:
let
  sshConfig = let config = builtins.readFile ./dotfiles/sshconfig;
  in pkgs.writeTextFile {
    name = "sshconfig";
    text = ''
      ${config}
    '';
  };

  gitConfig = let config = builtins.readFile ./dotfiles/gitconfig;
  in pkgs.writeTextFile {
    name = "gitconfig";
    text = ''
      ${config}
    '';
  };
in {
  ".ssh/config".source = sshConfig;
  ".gitconfig".source = gitConfig;
}
