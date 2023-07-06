#!/bin/bash

# Update system and install necessary dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y git curl wget unzip

# Check if PHP is already installed
if ! command -v php &> /dev/null; then
    # Install PHP 8.1 and 8.2 from the official PHP repository
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt update
    sudo apt install -y php8.1 php8.2
    echo "PHP 8.1 and 8.2 installed"
else
    echo "PHP already installed"
fi

# Check if Composer is already installed
if ! command -v composer &> /dev/null; then
    # Install Composer
    sudo apt install -y composer
    echo "Composer installed"
else
    echo "Composer already installed"
fi

# Check if NVM is already installed
if ! command -v nvm &> /dev/null; then
    # Install NVM and set up global packages
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    source ~/.bashrc
    nvm install --lts
    npm install --global yarn prettier typescript ts-node
    echo "NVM and global packages installed"
else
    echo "NVM already installed"
fi

# Check if Zsh is already installed
if ! command -v zsh &> /dev/null; then
    # Install Zsh
    sudo apt install -y zsh
    echo "Zsh installed"
else
    echo "Zsh already installed"
fi

# Check if Oh My Zsh is already installed
if [ ! -d ~/.oh-my-zsh ]; then
    # Install Oh My Zsh and additional plugins
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    sed -i 's/plugins=(git)/plugins=(git composer docker)/' ~/.zshrc
    echo "Oh My Zsh and additional plugins installed"
else
    echo "Oh My Zsh and additional plugins already installed"
fi

# Set Zsh as the default shell
if [[ $SHELL != "/usr/bin/zsh" ]]; then
    chsh -s $(which zsh)
    echo "Zsh set as the default shell"
else
    echo "Zsh is already the default shell"
fi

# Provide feedback on installation status
echo
echo "PHP versions installed:"
php --version
echo
echo "Composer installed:"
composer --version
echo
echo "Node.js and NPM installed:"
node --version
npm --version
echo
echo "Yarn installed:"
yarn --version
echo
echo "Zsh installed:"
zsh --version

# Instructions for setting up default shell
echo
echo "To set Zsh as the default shell, please log out and log back in."
