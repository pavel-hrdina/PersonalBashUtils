#!/bin/bash
# This script is licensed under GNU GPL v3.0

# Author: Pavel Hrdina
# Description: This script downloads a file from a provided URL using curl, wget, or ftp.
# Usage: ./download-helper.sh <URL>
# Version: 0.1

# Check if URL is provided as an argument
if [ $# -eq 0 ]; then
    echo "Error: No URL provided."
    echo "Usage: $0 <URL>"
    echo "This script downloads a file from the provided URL."
    echo "It uses curl, wget, or ftp, whichever is available on the system."
    echo ""
    echo "Examples:"
    echo "  $0 https://example.com/file.zip"
    echo "  $0 http://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz"
    echo "  $0 ftp://ftp.example.com/pub/file.tar.gz"
    exit 1
fi

# Validate URL format (basic check)
if ! echo "$1" | grep -qE '^(https?|ftp):\/\/'; then
    echo "Error: Invalid URL format. Please provide a valid URL starting with http://, https://, or ftp://"
    exit 1
fi

url="$1"

# Check if curl is available
if command -v curl >/dev/null 2>&1; then
    # Pipe the output to awk to calculate and display the download size in GB
    curl -O "$url" --progress-bar | awk '
    /[0-9]/ {
        size = $2/1024/1024/1024;
        printf "\rDownloaded: %.2f GB", size;
    }'
elif command -v wget >/dev/null 2>&1; then
    # Pipe the output to awk to calculate and display the download size in GB
    wget "$url" -q --show-progress | awk '
    /[0-9]/ {
        size = $3/1024/1024/1024;
        printf "\rDownloaded: %.2f GB", size;
    }'
elif command -v ftp >/dev/null 2>&1; then
    # Pipe the output to awk to calculate and display the download size in GB
    ftp -o "$(basename "$url")" "$url" | awk '
    /[0-9]/ {
        size = $3/1024/1024/1024;
        printf "\rDownloaded: %.2f GB", size;
    }'
else
    echo "Error: Neither curl, wget, nor ftp is available. Unable to download the file."
    exit 1
fi
echo ""  # Add a newline after download completion

echo "File download complete."
