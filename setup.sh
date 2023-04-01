#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

sudo apt install golang python3 pip -y

sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

sudo apt-get install -y php8.2 php8.2-cli \
  php8.2-common \
  php8.2-bcmath \
  php8.2-opcache \
  php8.2-mysql \
  php8.2-pgsql \
  php8.2-sqlite3 \
  php8.2-mbstring \
  php8.2-zip \
  php8.2-curl \
  php8.2-dom \
  php8.2-xml \
  php8.2-fpm

sudo update-alternatives --set php /usr/bin/php8.2

echo "PHP 8.2 and its plugins installed successfully."

if ! command -v composer &> /dev/null
then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  sudo mv composer.phar /usr/bin/composer
  echo "Composer installed successfully"
else
  echo "Composer is already installed"
fi

echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc && source ~/.bashrc

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

if grep -q "plugins=(git)" ~/.zshrc; then
  echo "git plugin is already added"
else
  echo "Adding git plugin..."
fi

if grep -q "plugins=(composer)" ~/.zshrc; then
  echo "composer plugin is already added"
else
  echo "Adding composer plugin..."
fi

if [ "$(echo $SHELL)" = "/usr/bin/zsh" ]; then
  echo "Default shell is already set to zsh"
else
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    fi

    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
    fi

    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git $HOME/.oh-my-zsh/plugins/zsh-completions
    fi

    if grep -q "zsh-syntax-highlighting" $HOME/.zshrc && grep -q "zsh-autosuggestions" $HOME/.zshrc && grep -q "zsh-completions" $HOME/.zshrc; then
    echo "Zsh plugins are already added to .zshrc"
    else
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' $HOME/.zshrc
    echo "Zsh plugins added to .zshrc"
    fi

    source $HOME/.zshrc

  else
    echo "Oh My Zsh is already installed"
  fi
fi
