#!/bin/bash

zsh ./installer-zsh.sh

# zshrc path
ZSHRC_PATH="$HOME/.zshrc"

# oh-my-zsh variables
OMZ_PATH="$HOME/.oh-my-zsh"
OMZ_PLUGINS=(
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-completions.git"
    "https://github.com/jessarcher/zsh-artisan.git"
)

# required packages
REQUIRED_PACKAGES=(
    "git"
    "curl"
    "zip"
    "wget"
)

# composer variables
COMPOSER_PATH="$HOME/.config/composer"
COMPOSER_GLOBAL_PATH="$COMPOSER_PATH/vendor/bin"
COMPOSER_REQUIRED_GLOBAL_PACKAGES=(
    "laravel/installer"
    "laravel/pint"
)

# request sudo access
sudo -v

# update the system
sudo apt update -y && sudo apt upgrade -y

# installing required packages
for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! dpkg -s $package >/dev/null 2>&1; then
        sudo apt install $package -y
    fi
done

# installing zsh
sudo apt install zsh -y

# installing oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<<y
fi

# installing plugins
for plugin in "${OMZ_PLUGINS[@]}"; do
    plugin_name=$(echo $plugin | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)

    if [ ! -d "$OMZ_PATH/custom/plugins/$plugin_name" ]; then
        echo "Installing $plugin_name plugin"
        git clone $plugin "$OMZ_PATH/custom/plugins/$plugin_name"
    fi
done

# installing powerlevel10k theme
if [ ! -d "$OMZ_PATH/custom/themes/powerlevel10k" ]; then
    echo "Installing theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# check if ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k directory exists
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    if [ -f ".p10k.zsh" ]; then
        cp .p10k.zsh $HOME/.p10k.zsh
    fi
fi

# installing ZSH
if [ -f "./install-fonts.sh" ]; then
    ./install-fonts.sh
fi

# Install fonts for PowerShell
if command -v pwsh.exe >/dev/null 2>&1; then
    if [ -f "./install-fonts.ps1" ]; then
        pwsh.exe -ExecutionPolicy Unrestricted ./install-fonts.ps1 FiraCode
    fi
fi

# install PHP 8.1 and its extensions
sudo apt install -y php8.1 php8.1-{bcmath,bz2,intl,gd,mbstring,mysql,zip,xml}

# install composer
sudo apt install -y composer

# append composer global path to zshrc if not exists
if ! grep -q "$COMPOSER_GLOBAL_PATH" "$ZSHRC_PATH"; then
    echo 'export PATH=$PATH:$COMPOSER_GLOBAL_PATH' >>$ZSHRC_PATH
fi

# install required composer packages globally
for package in "${COMPOSER_REQUIRED_GLOBAL_PACKAGES[@]}"; do
    if ! composer global show $package >/dev/null 2>&1; then
        composer global require $package
    fi
done

# install NVM if not installed
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

# append NVM_DIR to zshrc if not exists
if ! grep -q "NVM_DIR" "$ZSHRC_PATH"; then
    echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' >>$ZSHRC_PATH
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>$ZSHRC_PATH
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >>$ZSHRC_PATH
fi

# install Golang
sudo apt install -y golang

# install Python 3
sudo apt install -y python3 python3-pip
