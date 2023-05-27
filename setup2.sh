#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 1. Install PHP 8.1
printf "${GREEN}Installing PHP 8.1...${NC}\n"
sudo add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get install -y php8.1 php8.1-cli php8.1-fpm php8.1-mbstring php8.1-xml php8.1-zip php8.1-curl > /dev/null 2>&1

# 2. Install PHP Composer
printf "${GREEN}Installing PHP Composer...${NC}\n"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1

# 3. Install Laravel CLI
printf "${GREEN}Installing Laravel CLI...${NC}\n"
if ! command -v laravel &> /dev/null
then
    composer global require laravel/installer > /dev/null 2>&1
fi

# 4. Install Node.js and required global packages (yarn, typescript, prettier)
printf "${GREEN}Installing Node.js and required global packages...${NC}\n"
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>&1
sudo apt-get install -y nodejs > /dev/null 2>&1
sudo npm install -g yarn typescript prettier > /dev/null 2>&1

# 5. Install ZSH
printf "${GREEN}Installing ZSH...${NC}\n"
if ! command -v zsh &> /dev/null
then
    sudo apt-get install -y zsh > /dev/null 2>&1
fi

# 7. Install Oh My Zsh if not already installed
printf "${GREEN}Installing Oh My Zsh...${NC}\n"
if [ ! -d "$HOME/.oh-my-zsh" ]
then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
fi

# 8. Install Zsh plugins
printf "${GREEN}Installing Zsh plugins...${NC}\n"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]
then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting > /dev/null 2>&1
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]
then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions > /dev/null 2>&1
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]
then
    git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions > /dev/null 2>&1
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-artisan" ]
then
    git clone https://github.com/jessarcher/zsh-artisan.git $ZSH_CUSTOM/plugins/zsh-artisan > /dev/null 2>&1
fi

# 9. Source .zshrc
printf "${GREEN}Sourcing .zshrc...${NC}\n"
source ~/.zshrc > /dev/null 2>&1
