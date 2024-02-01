#!/bin/bash
NIX_INSTALLER_PATH=/tmp/nix-installer

function cleanup() {
    rm -rf $NIX_INSTALLER_PATH
}

trap cleanup EXIT

# Bootstrap script for non-nixos environent
echo "=== Bootstraping workstation ==="

# Check nix
echo "Checking if nix is installed..."

if ! command -v nix &> /dev/null
then
    echo "Nix could not be found. Installing..."
    curl -sL -o $NIX_INSTALLER_PATH https://install.determinate.systems/nix/nix-installer-x86_64-linux
    chmod +x $NIX_INSTALLER_PATH
    $NIX_INSTALLER_PATH install
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh    
else
    echo "Nix is installed"
fi

# Check home-manager
if ! command -v home-manager &> /dev/null
then
    echo "Home manager could not be found. Installing..."
    nix run home-manager/master -- init --switch
else
    echo "Home manager is installed"
fi

echo "Running home manager switch"
cd ../
nix develop --command bash -c "home-switch"
cd $OLDPWD || exit

echo "Setting zsh as degault shell"
NIX_PROFILE_ZSH_PATH=/home/$USER/.nix-profile/bin/zsh
ETC_SHELLS_PATH=/etc/shells

if ! grep -Fxq "$NIX_PROFILE_ZSH_PATH" "$ETC_SHELLS_PATH"
then
    echo "Adding nix profile zsh to $ETC_SHELLS_PATH"
    echo "$NIX_PROFILE_ZSH_PATH" | sudo tee -a "$ETC_SHELLS_PATH"
fi
sudo chsh -s "$NIX_PROFILE_ZSH_PATH" "$USER"

echo "Bootstrap complete!"