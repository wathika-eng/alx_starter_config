#!/bin/env bash


# ANSI color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing and updating packages...${NC}"
# Function to check and install packages using apt
install_package() {
    if ! command -v "$1" &>/dev/null; then
        echo "$1 is not installed. Installing..."
        sudo apt-get update
        sudo apt-get install -y "$1"

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "$1 has been successfully installed."
        else
            echo "Failed to install $1. Please check the installation logs."
            exit 1
        fi
    else
        echo "$1 is already installed."
    fi
}

# Update apt repository
echo "Updating apt repository..."
sudo apt-get update

# Install Git if not installed
install_package git

#Install Make if not installed
install_package make
# Install ShellCheck
install_package shellcheck

# Check and install gcc
install_package gcc

# Check and install valgrind
install_package valgrind

# Install wget if not installed
install_package wget

# Install curl if not installed
install_package curl

# Install Python venv
install_package python3-venv

# Create a virtual environment in ~/.venv
echo "Creating virtual environment..."
if [ ! -d "$HOME/.venv" ]; then
    python3 -m venv "$HOME/.venv"
    echo "Virtual environment created at ~/.venv"
else
    echo "Virtual environment already exists at ~/.venv"
fi

# Activate the virtual environment and install black inside it
echo "Activating virtual environment and installing black..."
source "$HOME/.venv/bin/activate" && pip install black

# Script to source the virtual environment in ~/.bashrc
echo "Setting up virtual environment activation in ~/.bashrc..."
if ! grep -q 'source "$HOME/.venv/bin/activate"' "$HOME/.bashrc"; then
    echo 'source "$HOME/.venv/bin/activate"' >> "$HOME/.bashrc"
    echo "Added activation script to ~/.bashrc"
else
    echo "Activation script already exists in ~/.bashrc"
fi

# Install NVM for Node.js version management
# echo "Installing NVM (Node Version Manager)..."
# wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# # Set up NVM environment variables
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# # Install Node.js version 20.1 using NVM
# echo "Installing Node.js version 21.5..."
# nvm install node 21.5

# # Activate the installed Node.js version
# echo "Activating Node.js version 21.5..."
# nvm use 21.5

echo "Installing Node JS ..."
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Installing Betty..."
# Check if Betty is installed
if command -v betty &>/dev/null; then
    echo "Betty is already installed."
else
    # Get betty from GitHub
    echo "Betty is not installed. Installing..."

    # Clone betty repository
    git clone https://github.com/alx-tools/Betty.git
    cd Betty || exit 1

    # Run the install.sh file with sudo privileges
    sudo ./install.sh

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "Betty has been successfully installed."
    else
        echo "Failed to install Betty. Please check the installation logs."
        exit 1
    fi
fi

echo -e "\033[0;32mExiting the terminal...\033[0m"
sleep 2 # Wait for 2 seconds before closing the terminal

# Open a new terminal window
gnome-terminal --working-directory="$HOME" &>/dev/null
