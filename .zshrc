#!/usr/bin/bash

CONFIG_PATH="$HOME/.config/supra"

source $CONFIG_PATH/variables
source $CONFIG_PATH/paths
source $CONFIG_PATH/aliases

# oh my zsh config
plugins=()

source $ZSH/oh-my-zsh.sh
source $CONFIG_PATH/extras
