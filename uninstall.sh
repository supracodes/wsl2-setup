#!/bin/bash

sudo -v

config=$(cat config.json)

function uninstall_php_and_extensions() {
    php_version=$(echo $config | jq -r '.apt.packages.additions.php.version')

    installed_php=$(sudo apt list --installed | grep "php$php_version")

    while IFS= read -r line; do
        package=$(echo "$line" | cut -d '/' -f 1)
        sudo apt remove "$package" -y
    done <<<"$installed_php"
}

function uninstall_composer() {
    sudo apt remove composer -y

    if [ -d ~/.config/composer ]; then
        sudo rm -r ~/.config/composer
    fi
}

function remove_src_files() {
    dirs=(
        ~/.zsh
        ~/.zshrc
        ~/.oh-my-zsh
    )

    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            sudo rm -r "$dir"
        fi
    done
}

#
uninstall_php_and_extensions

#
uninstall_composer

#
remove_src_files
