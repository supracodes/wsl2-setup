#!/bin/bash

# My personal setup script for installing and configuring the Ubuntu 22.04

# exit if not running Ubuntu 22.04
if [ ! -f /etc/os-release ]; then
    exit 1
fi

# if figlet is not installed, install it
if ! command -v figlet &>/dev/null; then
    sudo apt install figlet -y
fi

# if zsh is not installed, install it
if ! command -v zsh &>/dev/null; then
    sudo apt install zsh -y
fi

echo "Supra Billionaire" | figlet -f slant

source ./installer.zsh
