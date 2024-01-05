#!/bin/env bash

# Define the lines to be added to vimrc
lines_to_add="set tabstop=8 shiftwidth=8
set autoindent
set smartindent
set cindent
syntax enable
set number"

# Check if the file exists before attempting to modify it
if [ -f /etc/vim/vimrc ]; then
    # Append lines to the vimrc file with sudo
    echo -e "$lines_to_add" | sudo tee -a /etc/vim/vimrc > /dev/null
    echo "Lines added to /etc/vim/vimrc successfully."
else
    echo "Error: Vim configuration file (/etc/vim/vimrc) not found."
    exit 1
fi
