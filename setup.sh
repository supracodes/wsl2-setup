#!/bin/bash

# 1. Update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

# Add the ondrej/php repository
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

# Install PHP and plugins
sudo apt-get install -y php8.2 php8.2-cli php8.2-common php8.2-json php8.2-opcache php8.2-mysql php8.2-mbstring php8.2-zip php8.2-fpm
echo "PHP 8.2 and its plugins installed successfully."

# check if composer is already installed
if ! command -v composer &> /dev/null
then
    # download and install composer globally
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv /usr/bin/composer
    echo "Composer installed successfully"
else
    echo "Composer is already installed"
fi

# 5. Add plugins
# a. git
if grep -q "plugins=(git)" ~/.zshrc; then
  echo "git plugin is already added"
else
  echo "Adding git plugin..."
fi

# b. composer
if grep -q "plugins=(composer)" ~/.zshrc; then
  echo "composer plugin is already added"
else
  echo "Adding composer plugin..."
fi

# c. zsh-syntax-highlighting
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  echo "zsh-syntax-highlighting plugin is already installed"
else
  echo "Installing zsh-syntax-highlighting plugin..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# d. zsh-autosuggestions
if [ -d ~/.oh-my-zsh/custom/lugins/zsh-autosuggestions ]; then
  echo "zsh-autosuggestions plugin is already installed"
else
  echo "Installing zsh-autosuggestions plugin..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# e. zsh-completions
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
  echo "zsh-completions plugin is already installed"
else
  echo "Installing zsh-completions plugin..."
  git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
fi

# 6. Install Docker and Docker Compose if not already installed
if [ -z "$(command -v docker)" ]; then
  echo "Installing Docker..."
  sudo apt install docker.io -y
else
  echo "Docker is already installed"
fi

if [ -z "$(command -v docker-compose)" ]; then
  echo "Installing Docker Compose..."
  sudo apt install docker-compose -y
else
  echo "Docker Compose is already installed"
fi

#
plugins="git composer zsh-syntax-highlighting zsh-autosuggestions zsh-completions"
sed -i "s/plugins=(.*)/plugins=($plugins)/" ~/.zshrc

source ~/.zshrc
