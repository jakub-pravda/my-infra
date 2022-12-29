# Manual post-installation steps

Create wireguard keys for vpn connection 

```sh
umask 077
mkdir ~/wireguard-keys
wg genkey > ~/wireguard-keys/private
wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public
```