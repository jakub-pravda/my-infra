{ pkgs }:
let
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

  helixConfigLanguages = pkgs.writeTextFile {
    name = "helix-languages";
    text = builtins.readFile ./dotfiles/hx-languages.toml;
  };

  helixConfig = pkgs.writeTextFile {
    name = "helix";
    text = builtins.readFile ./dotfiles/hx-config.toml;
  };
in {
  ".config/kitty/kitty.conf".source = kittyConfig;
  ".config/kitty/kitty-theme.conf".source = kittyThemeConfig;
  ".config/zed/settings.json".source = zedConfig;
  ".config/helix/languages.toml".source = helixConfigLanguages;
  ".config/helix/config.toml".source = helixConfig;
}
