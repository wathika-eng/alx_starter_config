#!/bin/bash

# Define colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

# Function to install a package using apt-get
install_package() {
  sudo apt-get install -y "$1"
}

# Function to check if a command is available
is_command_available() {
  command -v "$1" >/dev/null 2>&1
}

# Function to evaluate a test
evaluate_test () {
  eval "$1" && printf "${GREEN}pass${NC}\n" || printf "${RED}fail${NC}\n"
}

# Function to evaluate a command
evaluate () {
  eval "$1"
}

# Function to print test results in a table format
print_table_results () {
  local result=$(evaluate_test "$2")
  printf "%-30s => [ %-6s ]\n" "$1" "$result"
}

# Function to print data row
print_data_row () {
  local result=$(evaluate "$2")
  printf "%-12s => [ %-6s ]\n" "$1" "$result"
}

# Function to print delimiter
delimiter () {
  printf "${BLUE}******************************************${NC}\n"
}

# Function to print validation header
validation_header () {
  printf "\n${CYAN}************ VALIDATING SETUP ************${NC}\n\n"
}

# Function to print configuration header
configuration_header () {
  printf "\n${CYAN}************* CONFIGURATION **************${NC}\n\n"
}

# Validation
validation_header
delimiter

# Check and install Visual Studio Code (VSCode)
if ! is_command_available "code"; then
  if is_command_available "snap"; then
    echo "Installing VSCode using snap..."
    sudo snap install code --classic
  else
    if ! is_command_available "wget"; then
      install_package "wget"
    fi
    echo "Installing VSCode from alternative source..."
    wget -O /tmp/code.deb https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg -i /tmp/code.deb
    sudo apt-get install -f
  fi
fi
print_table_results "Installed VSCode" "is_command_available 'code'"

# Check and install NVM
if ! is_command_available "nvm"; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  . ~/.nvm/nvm.sh
fi
print_table_results "Installed NVM" "is_command_available 'nvm'"

# Check and install Node
if ! is_command_available "node"; then
  nvm install node
fi
print_table_results "Installed Node" "is_command_available 'node'"

# Check and install Python
if ! is_command_available "python3"; then
  install_package "python3"
fi
print_table_results "Installed Python3" "is_command_available 'python3'"

# Check and install GCC
if ! is_command_available "gcc"; then
  install_package "gcc"
fi
print_table_results "Installed GCC" "is_command_available 'gcc'"

# Check and install pip
if ! is_command_available "pip"; then
  install_package "python3-pip"
fi
print_table_results "Installed pip" "is_command_available 'pip'"

# Check and install virtualenv
if ! is_command_available "virtualenv"; then
  install_package "virtualenv"
fi
print_table_results "Installed virtualenv" "is_command_available 'virtualenv'"

# Check and install MySQL
if ! is_command_available "mysql"; then
  install_package "mysql-server"
fi
print_table_results "Installed MySQL" "is_command_available 'mysql'"

# Enable ufw (Uncomplicated Firewall)
sudo ufw enable
sudo ufw allow 22
sudo ufw reload
print_table_results "Enabled ufw" "is_command_available 'ufw'"

# Check and install nginx
if ! is_command_available "nginx"; then
  install_package "nginx"
fi
print_table_results "Installed nginx" "is_command_available 'nginx'"

# Configuration
configuration_header
delimiter

# Github Configuration
print_table_results "Github user config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.name='"
print_table_results "Github email config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.email='"
echo "Github User Configuration:"
print_data_row "Name" "command -v git >/dev/null 2>&1 && git config user.name"
print_data_row "Email" "command -v git >/dev/null 2>&1 && git config user.email"
#echo "Made with ..."
delimiter

