# My Infra

This repo contains mainly Nix(Os) configuration for my personal/work ntb and home servers. 

## TODO
 - [ ] Fix non working auto updates
 - [*] Add ability to format code with `nixpkgs-fmt`
 - [ ] Periodic flake update (with CI)
 - [ ] CI Build (`flake.nix` clean)
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

