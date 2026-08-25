{
  pkgs,
  lib,
  isDarwin,
}:
# Default packages accessible across all servers/workstations
# Must contains only small system related packages, that can be
# shared with all environments.
with pkgs;
[
  # System monitoring tools
  bottom
  dust
  duf
  procs

  # Networking tools
  curl
  whois

  # Others
  git # required by nix
  openssh
  tmux

  # Editors
  helix
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
