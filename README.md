# Home manager - Apply configuration

```bash
home-manager switch --flake './#jacob'
```

# NixOs - CheatSheet

List NixOs system generations

```bash
nix-env --list-generations --profile /nix/var/nix/profiles/system
```

Rollback to previous generation

```bash
 nixos-rebuild switch --rollback
```

Rollback to N generation

```bash
/nix/var/nix/profiles/system-N-link/bin/switch-to-configuration switch
```

Run repl with input arguments `{ pkgs, lib, ... }`

```bash
nix repl ./jacfal.wiki.nix --arg lib '<nixpkgs>' --arg pkgs '<nixpkgs>'
```

Run tests via build


```bash
nix-build ./test-jacfal-wiki.nix
```

RUn tests interactively within Python session

```bash
$(nix-build -A driverInteractive test-jacfal-wiki.nix)/bin/nixos-test-driver
...
>>> start_all()
>>> server.shell_interact()
```


## Installation

Install package

```bash
$ nix-env -i hello
```

List generations sx

```bash
$ nix-env --list-generations
```

Listing installed derivations (with derivation paths)

```bash
$ nix-env -q --out-path
```

Rollback to the previous generation

```bash
nix-env -- rollback
```

Switch to the generation 

```bash
nix-env -G 1
```

List NIX channels

```bash
nix-channel --list
```

Update NIX channels (similar to *apt-get update*)

```bash
nix-channel --update
```

Determine nixpkgs platform 

```bash
bash $(nix-build '<nixpkgs>' -A gnu-config)/config.guess
```

## Necessary manual steps

Set httppasswd when iot pipeline enabled

```sh
sudo sh -c "echo -n 'sammy:' >> /etc/.htpasswd"
sudo sh -c "openssl passwd -apr1 >> /etc/.htpasswd"
```

Set wiki access passwd when wiki enabled

```sh
sudo sh -c "echo -n 'sammy:' >> /etc/.wikipasswd"
sudo sh -c "openssl passwd -apr1 >> /etc/.wikipasswd"
```

# NixOps - CheatSheet

Some useful `nixOps` commands:

Create fresh nixops deploy: 

```bash
nixops create -d [deploy-name]
```

List all available deployments

```bash
nixops list
```

Check status of deployment

```bash
nixops check -d [deploy-name]
```
