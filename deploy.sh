#!/bin/bash

rsync -azP --delete ./ jacfal@192.168.0.157:~/my-infra
rsync -azP --delete ./ jacfal@37.205.13.151:~/my-infra
# sudo nixos-rebuild test -I nixos-config=/home/jacfal/my-infra/home-gw/configuration.nix