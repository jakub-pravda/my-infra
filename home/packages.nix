{ pkgs, lib, isDarwin }:
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
  ollama
] ++ (if !isDarwin then
  [
    # Packages not available for Darwin platform
    atop
  ]
else
  [ ])
