{ pkgs, ... }:
# Those are default packages enabled at my primary local
{
  imports = [ ./extra-tools.nix ./devops.nix ];

  home = {
    packages = with pkgs; [
      nixpkgs-fmt
      jetbrains.idea-community
      qemu_kvm
      atop
      go
      grpcurl
      nil
      wireshark
      whois
    ];
  };
}
