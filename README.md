# My Infra

This repo contains mainly Nix(Os) configuration for my personal/work ntb and home servers. 

## TODO
 - [ ] Make this README great again
 - [ ] Use home manager configuration also for server users (maybe split pkgs conf to desktop and server)

## Useful commands

* apply home manager configuration

```bash
$ home-manager switch --flake './#jacob'
```

* list NixOs system generations

```bash
$ nix-env --list-generations --profile /nix/var/nix/profiles/system
```

* rollback to previous generation

```bash
$ nixos-rebuild switch --rollback
# or rollback to the N generation
$ nix-env -G 1
```

* run repl with input arguments `{ pkgs, lib, ... }`

```bash
$ nix repl ./jacfal.wiki.nix --arg lib '<nixpkgs>' --arg pkgs '<nixpkgs>'
```

* run tests interactively within Python session

```bash
$ $(nix-build -A driverInteractive test-jacfal-wiki.nix)/bin/nixos-test-driver
...
>>> start_all()
>>> server.shell_interact()
```

* listing installed derivations (with derivation paths)

```bash
$ nix-env -q --out-path
```

* list NIX channels

```bash
$ nix-channel --list
```

* determine nixpkgs platform 

```bash
$ bash $(nix-build '<nixpkgs>' -A gnu-config)/config.guess
```

## Non-server configuration

Use this configuration for desktop, notebook machines. I'm using `home-manager` for orchestraing my personal laptop(s) as I would like to keep user related packages separated.

## Home manager configuration

Install home manager at your machine to use it with flakes. Following commands use flakes from path `~/my-infra`.

```bash
# choosing release branch depends on your nixpkgs version
nix run home-manager/master -- init ~/my-infra
```

And then run, for config switch.

```bash
nix run home-manager/master -- init --switch
```

Previous command installs home manager utils, so next switch iteration can be done with `home-manager` command.

```bash
home-manager switch --flake ~/my-infra
```

## Troubleshooting

You can face the issue with the missing lock file (according to this github [issue](https://github.com/nix-community/home-manager/issues/3734), it can occurs pretty frequently)

```
error: opening lock file '/nix/var/nix/profiles/per-user/jacob/profile.lock': No such file or directory
```

The workaround is to create the missing directory.

```bash
$ sudo mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
$ sudo chown -R $USER:nixbld /nix/var/nix/profiles/per-user/$USER
```

And run the switch again.

## Troubleshooting
### Zigbee2mqtt

When...

```
Configuration is not consistent with adapter state/backup!
- PAN ID: configured=, adapter=
- Extended PAN ID: configured=, adapter=
- Network Key: configured=xy, adapter=zxt
- Channel List: configured=11, adapter=11
Zigbee2MQTT:error 2022-09-28 18:58:31: Error: startup failed - configuration-adapter mismatch - see logs above for more information
```

Network key regenerated during the startup. The solution is to remove the `coordinator_backup.json` and then repair all devices.

```bash
rm  /var/lib/zigbee2mqtt/coordinator_backup.json 
```

