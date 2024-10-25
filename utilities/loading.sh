#!/usr/bin/env bash

# This is licensed under the GNU GPL v3.0 license
# Created by: github.com/pavel-hrdina
# Description: Display a loading animation using Braille characters
# Version: 0.0.1

set -euo pipefail

# Constants
readonly VERSION="0.0.1"
readonly DURATION=5  # Duration in seconds
readonly INTERVAL=0.1  # Animation interval

# Colors
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Braille characters for the spinning animation
readonly BRAILLE_CHARS=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

# Function to cleanup and restore cursor
cleanup() {
    tput cnorm  # Show cursor
    echo -e "\n"
    exit 0
}

# Function to show loading animation
show_loading() {
    local message=$1
    local end_time=$((SECONDS + DURATION))
    local i=0

    # Hide cursor
    tput civis

    while [ $SECONDS -lt $end_time ]; do
        printf "\r${BLUE}${BRAILLE_CHARS[$i]}${NC} %s " "$message"
        i=$(((i + 1) % ${#BRAILLE_CHARS[@]}))
        sleep $INTERVAL
    done
}

# Set up trap for cleanup
trap cleanup EXIT INT TERM

# Main execution
main() {
    show_loading "Loading..."
}

main "$@"