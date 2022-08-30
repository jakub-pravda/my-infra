# General

Run nixos test/switch, whatever:

```sh
sudo nixos-rebuild test -I nixos-config=/home/jacfal/my-infra/cml/configuration.nix
```

# Manual post-installation steps

Create `.htpasswd` for nginx http basic auth

```sh
sudo sh -c "echo -n 'sammy:' >> /etc/nginx/.htpasswd"
sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd"
```