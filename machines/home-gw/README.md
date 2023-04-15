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
> nixos-rebuild dry-build --flake .#rpi
> nixos-rebuild switch --flake .#rpi
```

Build on the non nixos machine:

```sh
nix build .#nixosConfigurations.rpi.config.system.build.toplevel -L
```


