#!/bin/zsh

# request sudo access permissions
sudo -v

# update system
update_system() {
    sudo apt update -y && sudo apt upgrade -y
}

copy_config() {
    # remove existing .zshrc
    if [ -f $HOME/.zshrc ]; then
        sudo mv $HOME/.zshrc $HOME/.zshrc-supra-backup
    fi

    # copying .zshrc
    sudo cp .zshrc "$HOME"

    # copying config dir
    if [ ! -d $HOME/.config ]; then
        mkdir -p $HOME/.config
    fi

    sudo cp -r ./supra $HOME/.config

    . $HOME/.zshrc
}

# install required package
install_required_package() {
    sudo apt install -y zsh \
        curl \
        wget \
        zip \
        unzip \
        neovim
}

# installing PHP
install_php() {
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
}

# install composer
install_composer() {
    sudo apt install -y composer

    # install global composer package
    composer global require laravel/installer
    composer global require laravel/pint
}

# install NodeJS and Npm
install_nodejs() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    . $HOME/.zshrc

    nvm install --lts
    npm install -g yarn prettier typescript eslint
}

install_additions() {
    # install golang
    sudo apt install -y golang

    # install python3
    sudo apt install -y python
}

install_plugin() {
    url=$1
    name=$2

    if [ ! -d $HOME/.oh-my-zsh/custom/plugins/$name ]; then
        git clone $url $HOME/.oh-my-zsh/custom/plugins/$name
    fi

    omz plugin enable $name
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    copy_config

    . $HOME/.zshrc

    install_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting
    install_plugin https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
    install_plugin https://github.com/zsh-users/zsh-completions zsh-completions
    install_plugin https://github.com/jessarcher/zsh-artisan.git zsh-artisan
}

# update system
update_system

# update system
install_required_package

# install NodeJS
install_nodejs

# install Oh My Zsh
install_oh_my_zsh

# install PHP
install_php

# install composer
install_composer

# install additions
install_additions

# make zsh default shell
chsh -s $(which zsh)
