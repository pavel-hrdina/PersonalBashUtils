#!/usr/bin/env bash

# This is licensed under the GNU GPL v3.0 license
# Created by: github.com/pavel-hrdina
# Description: Will configure Redhat based systems, to have my preferred settings and tooling installed.
# Usage: bash fedora-configuration.sh
# Version: 0.0.1

set -euo pipefail

##############################################
# System configuration functions definitions #
##############################################

# Check if a command exists
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

# System maintenance and chores functions definitions taken from
# https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
user_can_sudo() {
  # Check if sudo is installed
    command_exists sudo || return 1
    # Termux can't run sudo, so we can detect it and exit the function early.
    if [ -n "${PREFIX-}" ] && [[ "$PREFIX" == *com.termux* ]]; then
        return 1
    fi
    # The following command has 3 parts:
    #
    # 1. Run `sudo` with `-v`. Does the following:
    #    • with privilege: asks for a password immediately.
    #    • without privilege: exits with error code 1 and prints the message:
    #      Sorry, user <username> may not run sudo on <hostname>
    #
    # 2. Pass `-n` to `sudo` to tell it to not ask for a password. If the
    #    password is not required, the command will finish with exit code 0.
    #    If one is required, sudo will exit with error code 1 and print the
    #    message:
    #    sudo: a password is required
    #
    # 3. Check for the words "may not run sudo" in the output to really tell
    #    whether the user has privileges or not. For that we have to make sure
    #    to run `sudo` in the default locale (with `LANG=`) so that the message
    #    stays consistent regardless of the user's locale.
    #
    ! LANG= sudo -n -v 2>&1 | grep -q "You need to be able to run as sudo, please make sure you have the correct permissions."
}

update_system() {
    echo  "Starting system update"
    sudo dnf update -y
}

# TODO: Add required dependencies
install_dependencies() {
    sudo dnf install -y git
}

# download bashrc from my dotfiles
download_bashrc() {
    curl -o ~/.bashrc https://raw.githubusercontent.com/pavel-hrdina/dotfiles/refs/heads/master/bash/.bashrc
}

# TODO: make a universal function that will install all the dotfiles from my repo that I want to use, this will also
# include the bashrc file

# TODO: Add a function that configures gnome if it is installed

# A little hack check if session is tty
if [ -t 1 ]; then
    is_tty() {
      true
    }
else
    is_tty() {
      false
    }
fi

# Define display-help helper function
display_help() {
    echo "Usage: $0 [option...]" >&2
    echo
    echo "   -h, --help          Display help"
    echo "   -v, --version       Display version"
    echo "   -i  --install       Start installation"
    echo
    # echo some stuff here for the -a or --add-options
    exit 1
}

############################################
# Main function and argument parsing logic #
############################################

while :
do
    # check if there are no arguments, display help if true
    if [ -z "${1-}" ]; then
       display_help
    fi
    case "$1" in
      -h | --help)
          display_help  # Call your function
          ;;
      --) # End of all options
          shift
          break
          ;;
      -v | --version)
          echo "Version: 0.0.1" >&2
          exit 0
          ;;
      -i | --install)
          # exit the loop and continue with the rest of the script
          break
          ;;
      -*)
          echo "Error: Unknown option: $1" >&2
          exit 1
          ;;
    esac
done


main() {
    # Check if the user can sudo
    user_can_sudo

    update_system
    install_dependencies
}

main
