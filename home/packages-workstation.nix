{ pkgs }:
# Default packages accessible across all workstations
with pkgs; [
  # Nix
  nil
  nixpkgs-fmt

  # Development
  helix
  jetbrains.idea-oss
  typos-lsp
  zed-editor

  # Golang development
  go

  # Python development
  poetry
  (python312.withPackages
    (ps: with ps; [ black flake8 mypy pip pylint pytest ruff ]))

  # Rust development
  rustup

  # Scala development
  metals
  sbt
  scala_3
  scala-cli

  # Productivity tools
  bitwarden-desktop
  firefox
  google-chrome
  libreoffice
  spotify

  # Note taking
  obsidian
]
