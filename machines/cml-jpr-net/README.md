# General

Run nixos test/switch, whatever:

```sh
sudo nixos-rebuild switch --flake .#vpsfree
```

Build on the non nixos machine:

```sh
nix build .#nixosConfigurations.vpsfree.config.system.build.toplevel -L
```

# Manual post-installation steps

Create `.wikipasswd` for nginx wiki access

```sh
sudo sh -c "echo -n 'sammy:' >> /etc/nginx/.wikipasswd"     # user (sammy for this cmd)
sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.wikipasswd" # password
```

Create wireguard keys for vpn connection 

```sh
umask 077
mkdir ~/wireguard-keys
wg genkey > ~/wireguard-keys/private
wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public
```