#!/bin/bash

# Request sudo password upfront
sudo -v

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Silent output using gum style command
silent_output() {
  if command_exists gum; then
    echo "$1" | gum style --foreground 212
  else
    echo "$1"
  fi
}

# Install gum if not already installed
install_gum() {
  if ! command_exists gum; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    silent_output "Installing gum..."
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
    sudo apt update && sudo apt install gum > /dev/null
  fi

  silent_output "Install gum complete."
}

# Update the system
update_system() {
  gum spin --spinner dot --title "Updating System..." -- sudo apt update -y
  gum spin --spinner dot --title "Upgrading System..." -- sudo apt upgrade -y

  silent_output "Update system complete."
}

# Install Zsh if not already installed
install_zsh() {
  if ! command_exists zsh; then
    gum spin --spinner dot --title "Installing Zsh..." -- sudo apt install -y zsh
  fi

  silent_output "Install Zsh complete."
}

# Install Oh My Zsh
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    gum spin --spinner dot --title "Installing Oh My Zsh..." -- sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<< 'y'
  fi

  plugins=(
    "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
    "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting"
    "zsh-completions:https://github.com/zsh-users/zsh-completions"
  )

  for plugin in "${plugins[@]}"; do
    IFS=':' read -r plugin_name plugin_url <<< "$plugin"
    plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin_name"
    if [ ! -d "$plugin_dir" ]; then
      gum spin --spinner dot --title "Installing $plugin_name..." -- git clone "$plugin_url" "$plugin_dir"
    fi
  done

  silent_output "Install Oh My Zsh complete."
}

# Install PHP if not already installed
install_php() {
  if ! command_exists php; then
    PHP_VERSION=$(gum choose --header "Choose PHP Version to be installed" --header.foreground "212" --header.margin="1 1" "7.4" "8.0" "8.1")
    gum spin --spinner dot --title "Installing PHP and its Extensions..." -- sudo apt install -y php$PHP_VERSION php$PHP_VERSION-{cli,common,opcache,mysql,sqlite3,pgsql,zip,fpm,mbstring,intl,dom,xml,xdebug,curl}
  fi

  silent_output "Install PHP complete."
}

# Install Composer if not already installed
install_composer() {
  if ! command_exists composer; then
    gum spin --spinner dot --title "Installing Composer..." -- sudo apt install -y composer
  fi

  silent_output "Install Composer complete."
}

# Set default shell to Zsh
set_default_shell() {
  current_shell=$(echo "$SHELL" | awk -F/ '{print $NF}')
  if [ "$current_shell" != "zsh" ]; then
    gum spin --spinner dot --title "Setting default shell to Zsh..." -- sudo chsh -s "$(command -v zsh)" "$USER"
  fi

  silent_output "Set default shell to Zsh complete."
}

# Main script

# Request sudo password upfront
sudo -v

# Check and install gum
install_gum

# Update the system
update_system

# Install Zsh
install_zsh

# Install Oh My Zsh
install_oh_my_zsh

# Install PHP packages
install_php

# Install Composer
install_composer

# Set default shell to Zsh
set_default_shell

# Display completion message
silent_output "Setup complete. Please insert the following plugins into your ~/.zshrc file:"
plugins=(
  "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
  "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting"
  "zsh-completions:https://github.com/zsh-users/zsh-completions"
)
for plugin in "${plugins[@]}"; do
  IFS=':' read -r plugin_name _ <<< "$plugin"
  echo "  - $plugin_name"
done
