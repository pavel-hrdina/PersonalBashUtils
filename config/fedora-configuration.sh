#!/usr/bin/env bash

# This is licensed under the GNU GPL v3.0 license
# Created by: github.com/pavel-hrdina
# Description: Will configure Redhat based systems, to have my preferred settings and tooling installed.
# Usage: bash fedora-configuration.sh
# Version: 0.0.1

set -e

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

while :
do
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
      -*)
          echo "Error: Unknown option: $1" >&2
          exit 1
          ;;
      *)  # No more options
          display_help
          ;;
    esac
done