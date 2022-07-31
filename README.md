# NixOs - CheatSheet

List NixOs system generations

```bash
nix-env --list-generations --profile /nix/var/nix/profiles/system
```

## Installation

Install package

```bash
$ nix-env -i hello
```

List generations 

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