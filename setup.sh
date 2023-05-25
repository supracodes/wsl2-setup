#!/bin/bash

sudo apt update -y && sudo apt upgrade -y

sudo apt-get install -y php8.1 php8.1-cli \
  php8.1-common \
  php8.1-bcmath \
  php8.1-opcache \
  php8.1-mysql \
  php8.1-pgsql \
  php8.1-sqlite3 \
  php8.1-mbstring \
  php8.1-zip \
  php8.1-curl \
  php8.1-dom \
  php8.1-xml \
  php8.1-fpm

sudo update-alternatives --set php /usr/bin/php8.1

echo "Installing NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install --lts

echo "PHP 8.1 and its plugins installed successfully."

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

echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.zshrc

sudo apt install zsh -y

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<< y
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

chsh -s $(which zsh)

[ "$(basename "$SHELL")" != "zsh" ] && chsh -s "$(which zsh)" && echo "Shell changed to Zsh." || echo "The current shell is already Zsh."

source ~/.zshrc
