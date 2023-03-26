#!/bin/bash

# 1. Update and upgrade packages
sudo apt update -y
sudo apt upgrade -y

# 2. Install zsh if not already installed
if [ -z "$(command -v zsh)" ]; then
  sudo apt install zsh -y
fi

# 3. Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. Add plugins
# a. git
sed -i 's/plugins=(git)/plugins=(git composer zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' ~/.zshrc

# b. composer
if [ ! -f ~/.zsh/composer.zsh ]; then
  curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/composer/composer.plugin.zsh --output ~/.zsh/composer.zsh
fi

# c. zsh-syntax-highlighting
if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

# d. zsh-autosuggestions
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
fi

# e. zsh-completions
if [ ! -d ~/.zsh/zsh-completions ]; then
  git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions
fi

# 5. Add PPA for PHP and install PHP 8.2 with extensions
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install php8.2 php8.2-common php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-curl php8.2-gd php8.2-imagick php8.2-cli php8.2-dev php8.2-imap php8.2-mbstring php8.2-opcache php8.2-soap php8.2-zip -y

git config --global user.name "Supra Codes"
git config --global user.email "dev@supra.codes"
