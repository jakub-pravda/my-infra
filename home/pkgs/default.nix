{pkgs, ...}:
# Those are default packages enabled at my primary local
{
  imports = [./devops.nix];

  home = {
    # default packages available on all machines
    packages = with pkgs; [
      atop
      curl
      duf # more intuitive disk config utility
      du-dust # more intuitive disk usage utility
      grpcurl
      nil
      nixpkgs-fmt
      procs # modern replacement for ps
      vim
      wireshark
      whois
    ];
  };
}
