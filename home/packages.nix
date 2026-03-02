{ pkgs, lib, isWorkstation ? false, ... }:
# Default packages accessible across all workstations
with pkgs; [
  # Monitoring tools
  atop
  bottom
  dust
  duf
  procs

  # Networking tools
  curl
  grpcurl
  wireshark
  whois

  # Development tools
  git
  helix

  # System tools
  openssh
  tmux
]
