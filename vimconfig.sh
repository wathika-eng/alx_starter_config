#!/bin/bash

# Check if sudo is available
if ! [ -x "$(command -v sudo)" ]; then
  echo "Error: sudo is not installed. Please install sudo or run this script as root."
  exit 1
fi

# Define the lines to be added to vimrc
read -r -d '' lines_to_add <<EOF
set tabstop=8 shiftwidth=8
set autoindent
set smartindent
set cindent
syntax enable
set number
EOF

# Check if the file exists before attempting to modify it
if [ -f /etc/vim/vimrc ]; then
    # Append lines to the vimrc file with sudo
    echo "$lines_to_add" | sudo tee -a /etc/vim/vimrc > /dev/null
    echo "Lines added to /etc/vim/vimrc successfully."
else
    echo "Error: Vim configuration file (/etc/vim/vimrc) not found."
    exit 1
fi

