#!/bin/bash
set -euo pipefail

NIX_INSTALLER_PATH=/tmp/nix-installer
GITHUB_REPO_URL=https://github.com/jakub-pravda/my-infra.git
SRC_REPO_PATH=~/Devel/repos/my-infra

function cleanup() {
    echo "Cleaning up..."
    # Remove my-infra repo if empty
    [ "$(ls -A $SRC_REPO_PATH)" ] || rm -rf $SRC_REPO_PATH
    rm -rf $NIX_INSTALLER_PATH
}

trap cleanup EXIT

function require() {
    if ! command -v $1 &> /dev/null
    then
        echo "Command $1 not found"
        return 1
    else
        echo "Command $1 is installed"
        return 0
    fi
}

function commandCannotBeInstalled() {
    echo "Command has to be installed manualy!"
    exit 1
}

function genSshKey() {
    if [ ! -f $1 ]; then
        echo "Generating ssh key..."
        ssh-keygen -t ed25519 -C "me@jakubpravda.net" -f $1
    fi
}

# Bootstrap script for non-nixos environent
echo "=== Bootstraping workstation ==="

# Check required commands
require "curl" || commandCannotBeInstalled

# Check nix
echo "Checking Nix"

function installNix() {
    echo "Installing nix..."
    curl -sL -o $NIX_INSTALLER_PATH https://install.determinate.systems/nix/nix-installer-x86_64-linux
    chmod +x $NIX_INSTALLER_PATH
    $NIX_INSTALLER_PATH install
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}
require "nix" || installNix

# Check if my-infra repo exists
if [ ! -d "$SRC_REPO_PATH" ]; then
    echo "Cloning my-infra repository..."
    mkdir -p $SRC_REPO_PATH
    nix-shell -p git --run "git clone $GITHUB_REPO_URL $SRC_REPO_PATH"
fi

# Check home-manager
echo "Checking Home-manager"

function installHomeManager() {
    echo "Installing home/manager..."
    cd $SRC_REPO_PATH/home || exit
    echo "Home manager could not be found. Installing..."
    nix run home-manager/master -- init --switch
}
require "home-manager" || installHomeManager

# Run home-manager switch
echo "Running home manager switch..."
cd $SRC_REPO_PATH || exit

# git needed for home manager switch
if require "git"; then
    nix develop --command bash -c "home-switch"
else
    # use nix git for home manager switch
    nix-shell -p git --run 'nix develop --command bash -c "home-switch"'
fi

echo "Setting zsh as degault shell"
NIX_PROFILE_ZSH_PATH=/home/$USER/.nix-profile/bin/zsh
ETC_SHELLS_PATH=/etc/shells

if ! grep -Fxq "$NIX_PROFILE_ZSH_PATH" "$ETC_SHELLS_PATH"
then
    echo "Adding nix profile zsh to $ETC_SHELLS_PATH"
    echo "$NIX_PROFILE_ZSH_PATH" | sudo tee -a "$ETC_SHELLS_PATH"
fi
sudo chsh -s "$NIX_PROFILE_ZSH_PATH" "$USER"

# Generate ssh key
genSshKey "id_ed25519_github"
genSshKey "id_ed25519_personal"

echo "Bootstrap complete!"