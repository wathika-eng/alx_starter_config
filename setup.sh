#!/bin/bash

#sourced from https://raw.githubusercontent.com/learn-co-curriculum/flatiron-manual-setup-validator/master/wsl-phase-0-manual-setup-validator-with-py.sh

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

## 4. git
# https://stackoverflow.com/questions/12254076/how-do-i-show-my-global-git-config
print_table_results "Installed git" "command -v git >/dev/null 2>&1 && git version | grep -q 'git version'"
delimiter

## Student Configuration
configuration_header
delimiter

## 5. github
print_table_results "Github user config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.name='"
print_table_results "Github email config" "command -v git >/dev/null 2>&1 && git config --list | grep -q 'user.email='"
echo "Github User Configuration:"
print_data_row "Name" "command -v git >/dev/null 2>&1 && git config user.name"
print_data_row "Email" "command -v git >/dev/null 2>&1 && git config user.email"
#echo "Made with ..."
delimiter
