#!/bin/sh

# request sudo access permissions
sudo -v

# update system
sudo apt update -y && sudo apt upgrade -y

# install required package
sudo apt install -y zsh \
    curl \
    wget \
    zip \
    unzip \
    neovim

# installing PHP
sudo apt install -y php8.1 \
    php8.1-bcmath \
    php8.1-curl \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-xml \
    php8.1-zip \
    php8.1-sqlite3 \
    php8.1-pgsql \
    php8.1-intl \
    php8.1-redis \
    php8.1-xdebug

# install composer
sudo apt install -y composer

# install global composer package
composer global require laravel/installer
composer global require laravel/pint

# install golang
sudo apt install -y golang

# install python3
sudo apt install -y python

# copying .zshrc
sudo cp ./.zshrc $HOME

# copying config dir
sudo cp ./supra $HOME/.config

# install NodeJS and Npm
sudo cp -r ./components/.nvm $HOME
nvm install --lts

# install global npm package
npm install -g yarn prettier typescript eslint

# copying components
sudo cp -r ./components/.oh-my-zsh $HOME

# make zsh default shell
chsh -s $(which zsh)
