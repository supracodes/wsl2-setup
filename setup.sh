#!/bin/bash

# 1. Update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

# 2. Install zsh if not already installed
if [ -z "$(command -v zsh)" ]; then
  sudo apt install zsh -y
else
  echo "zsh is already installed"
fi

# 3. Install Oh My Zsh if not already installed
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed"
fi

# 4. Add plugins
# a. git
if grep -q "plugins=(git composer zsh-syntax-highlighting zsh-autosuggestions zsh-completions)" ~/.zshrc; then
  echo "git plugin is already added"
else
  sed -i 's/plugins=(git)/plugins=(git composer zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' ~/.zshrc
fi

# b. composer
if [ ! -f ~/.zsh/composer.zsh ]; then
  curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/composer/composer.plugin.zsh --output ~/.zsh/composer.zsh
else
  echo "composer plugin is already installed"
fi

# c. zsh-syntax-highlighting
if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
else
  echo "zsh-syntax-highlighting plugin is already installed"
fi

# d. zsh-autosuggestions
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
else
  echo "zsh-autosuggestions plugin is already installed"
fi

# e. zsh-completions
if [ ! -d ~/.zsh/zsh-completions ]; then
  git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
else
  echo "zsh-completions plugin is already installed"
fi

# 5. Install Docker if not already installed
if [ -z "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker $USER
  rm -f get-docker.sh
else
  echo "Docker is already installed"
fi

# 6. Add PPA for PHP and install PHP 8.2 with extensions
if ! grep -q "ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
  sudo add-apt-repository ppa:ondrej/php -y
  sudo apt update -y
else
  echo "PPA for PHP is already added"
fi

if [ -z "$(command -v php8.2)" ]; then
  sudo apt install php8.2 php8.2-common php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-curl php8.2-gd php8.2-imagick php8.2-cli php8.2-dev php8.2-imap php8.2-mbstring php8.2-opcache php8.2-soap php8.2-zip -y
else
  echo "PHP 8.2 is already installed"
fi

# Configure git
git config --global user.name "Supra Codes"
git config --global user.email "dev@supra.codes"
