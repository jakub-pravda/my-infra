{ pkgs }:
# Default packages accessible across all workstations
with pkgs;
[
  # Nix
  nil
  nixpkgs-fmt

  # Development
  helix
  typos-lsp
  zed-editor

  # Golang development
  go
  gopls

  # Python development
  (python312.withPackages (
    ps: with ps; [
      black
      pip
      pytest
      ruff
      ty
      uv
    ]
  ))

  # Rust development
  rustup

  # Scala development
  metals
  sbt
  scala_3
  scala-cli

  # Productivity tools
  #bitwarden-desktop FIXME - using EOL electron (waiting for fix)
  brave
  firefox
  google-chrome
  kitty
  libreoffice
  spotify

  # Note taking
  obsidian
]
