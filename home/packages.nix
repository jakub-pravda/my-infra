{
  pkgs,
  lib,
  isDarwin,
}:
# Default packages accessible across all workstations
with pkgs;
[
  # Monitoring tools
  bottom
  dust
  duf
  procs

  # Networking tools
  curl
  grpcurl
  whois

  # Development tools
  git
  helix

  # System tools
  openssh
  tmux

  # AI/ML
  docker-sbx
  ollama
  pi-coding-agent
]
++ (
  if !isDarwin then
    [
      # Packages not available for Darwin platform
      atop
    ]
  else
    [ ]
)
