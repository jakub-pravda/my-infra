#!/bin/bash

# copy to the rpi4 machine
rsync -azP --delete  --exclude \".git\" ./ jacfal@192.168.1.192:~/my-infra

# copy to the vpsfree machine
rsync -azP --delete  --exclude \".git\" ./ jacfal@37.205.13.151:~/my-infra


# sudo nixos-rebuild test -I nixos-config=/home/jacfal/my-infra/home-gw/configuration.nix