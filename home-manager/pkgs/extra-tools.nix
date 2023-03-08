# additional linux tools and utilities
{ config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      duf # more intuitive disk config utility
      du-dust # more intuitive disk usage utility
      procs # modern replacement for ps
    ];
  };
}
