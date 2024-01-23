# Home configuration

Home-manager configuration for workstation deployment.

## Manual steps

It's hard (or even impossible) to set system configuration on non-nixos machine, so some manual steps are necessary.

### Change default shell (Fedora)

I'm using `zsh` as my default shell, you can't set default shell with home-manager at it requires root privileges, so we need to set it manually.

* Add your shell to the `/etc/shells`
* Change default shell with `sudo chsh -s ~/.nix-profile/bin/zsh <user>`


