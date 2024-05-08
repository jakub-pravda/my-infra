# Manual post-installation steps

Create wireguard keys for vpn connection 

```sh
umask 077
mkdir ~/wireguard-keys
wg genkey > ~/wireguard-keys/private
wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public
```

## Build

```sh
> nixos-rebuild dry-build --flake .#home-hub
> nixos-rebuild switch --flake .#home-hub
```

Build on the non nixos machine:

```sh
nix build .#nixosConfigurations.home-hub.config.system.build.toplevel -L
```


