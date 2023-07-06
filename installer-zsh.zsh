#!/usr/bin/env zsh

# request sudo permissions
sudo -v

# # updating
# sudo apt update -y && sudo apt upgrade -y

# install jq for json parsing
if ! command -v jq &>/dev/null; then
    sudo apt install jq -y
fi

# exit if config.json does not exist
if [ ! -f config.json ]; then
    exit 1
fi

zshrc_path="$HOME/.zshrc"
paths_rc="$HOME/.zsh/paths"
variables_rc="$HOME/.zsh/variables"
aliases_rc="$HOME/.zsh/aliases"
extras_rc="$HOME/.zsh/extras"

# get config.json
config=$(cat config.json)
required_packages=$(echo $config | jq '.apt.packages.required')
php_version=$(echo $config | jq '.apt.packages.additions.php.version')
php_extensions=$(echo $config | jq '.apt.packages.additions.php.extensions')
composer_packages=$(echo $config | jq '.apt.packages.additions.composer.packages')

# check if path exists in PATH
path_exists() {
    local path_to_check=$1
    local IFS=':'

    for path in $PATH; do
        if [ "$path" = "$path_to_check" ]; then
            return 0
        fi
    done

    return 1
}

function copyRcFiles() {
    if [ -f "$zshrc_path" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc-backup"
    fi

    cp ./config/zshrc $zshrc_path

    . $zshrc_path

    if [ ! -d "$HOME/.zsh" ]; then
        mkdir -p $HOME/.zsh
    fi

    cp -n "./config/paths" "$paths_rc"
    cp -n "./config/variables" "$variables_rc"
    cp -n "./config/aliases" "$aliases_rc"
    cp -n "./config/extras" "$extras_rc"
}

# install required packages
function install_required_packages() {
    for package in $(echo "$required_packages" | jq -r '.[]'); do
        sudo apt install $package -y
    done
}

# install php packages
function install_php_packages() {
    sudo apt install "php$php_version" -y
    for extension in $(echo "$php_extensions" | jq -r '.[]'); do
        sudo apt install "php$php_version-$extension" -y
    done
}

# install composer
function install_composer() {
    sudo apt install composer -y
    composer_bin_dir=$(composer global config bin-dir --absolute -q)

    # append composer path to zshrc if not exists
    if ! path_exists "$composer_bin_dir"; then
        echo "export PATH=\"$composer_bin_dir:\$PATH\"" >>$paths_rc
    fi

    # append composer allow superuser to zshrc if not exists
    if [ -z "$COMPOSER_ALLOW_SUPERUSER" ]; then
        echo "export COMPOSER_ALLOW_SUPERUSER=1" >>$variables_rc
    fi

    # load zshrc
    . $zshrc_path

    # install composer packages
    for package in $(echo "$composer_packages" | jq -r '.[]'); do
        composer global require $package
    done
}

# Install plugins
install_omz_plugins() {
    . $zshrc_path

    plugins=$(echo "$config" | jq -r '.oh_my_zsh.plugins[]')

    for plugin in $plugins; do
        name=$(echo "$plugin" | jq -r '.name')
        installed=$(omz plugin list | grep -c "$name")

        if [ "$installed" -eq 0 ]; then
            url=$(echo "$plugin" | jq -r '.url')
            git clone "$url" "$ZSH_CUSTOM/plugins/$name"

            if type omz >/dev/null 2>&1; then
                omz plugin enable "$name"
            fi
        fi
    done
}

# install oh-my-zsh
function install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<<"y"
    fi
}

echo "Copying config files..."
copyRcFiles

echo "Installing required packages..."
install_required_packages

echo "Installing PHP packages..."
install_composer

echo "Insntalling Oh My Zsh..."
install_oh_my_zsh

echo "Installing Oh My Zsh plugins..."
install_omz_plugins
