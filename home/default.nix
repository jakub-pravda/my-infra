{
  config,
  pkgs,
  ...
}: {
  imports = [./pkgs ./vscode.nix ./git.nix ./zsh.nix];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
  };

  # Dotfiles
  home.file = {
    ".ssh/config".source = ./dotfiles/sshconfig;
  };
}
