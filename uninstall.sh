#!/bin/bash

sudo -v
config=$(cat config.json)

uninstall_php_and_extensions() {
    php_version=$(echo $config | jq -r '.apt.packages.additions.php.version')

    installed_php=$(sudo apt list --installed | grep "php$php_version")

    while IFS= read -r line; do
        sudo apt remove $line -y
    done <<<"$installed_php"

    sudo apt remove composer -y
    sudo rm -r ~/.config/composer
}

remove_src_files() {
    sudo rm -r ~/.zsh ~/.zshrc ~/.oh-my-zsh
}

#
uninstall_php_and_extensions

#
remove_src_files
