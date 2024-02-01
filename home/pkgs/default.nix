{pkgs, ...}:
# Those are default packages enabled at my primary local
{
  imports = [./devops.nix];

  home = {
    # default packages available on all machines
    packages = with pkgs; [
      nixpkgs-fmt
      atop
      grpcurl
      nil
      wireshark
      whois
      duf # more intuitive disk config utility
      du-dust # more intuitive disk usage utility
      procs # modern replacement for ps
    ];
  };
}
