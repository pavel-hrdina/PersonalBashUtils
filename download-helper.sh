#!/bin/bash
# This script is licensed under GNU GPL v3.0

# Author: Pavel Hrdina
# Description: This script downloads a file from a provided URL using curl, wget, or ftp.
# Usage: ./download-helper.sh <URL>
# Version: 0.2

# Check if URL is provided as an argument
if [[ $# -eq 0 ]]; then
  echo "Error: No URL provided."
  echo "Usage: $0 <URL>"
  echo "This script downloads a file from the provided URL."
  echo "It uses curl, wget, or ftp, whichever is available on the system."
  echo ""
  echo "Examples:"
  echo "  $0 https://example.com/file.zip"
  exit 1
fi

# Validate URL format (basic check)
if ! echo "$1" | grep -qE '^(https?|ftp)://'; then
  echo "Error: Invalid URL format. Please provide a valid URL starting with http://, https://, or ftp://"
  exit 1
fi

url="$1"
filename=$(basename "$url")

# Updated URL validation
if ! echo "$url" | grep -qE '^https?://'; then
  echo "Error: Invalid URL format. Please provide a valid URL starting with http:// or https://"
  exit 1
fi

download_file() {
  if command -v curl > /dev/null 2>&1; then
    echo "Downloading with curl..."
    curl -L -O "$url"
  elif command -v wget > /dev/null 2>&1; then
    echo "Downloading with wget..."
    wget "$url"
    else
       echo "Error: Neither curl nor wget is available. Unable to download the file."
       echo "Please install curl or wget and try again."
       exit 1
     fi
}

download_file

if [ -f "$filename" ]; then
  size=$(du -h "$filename" | cut -f1)
  echo "File download complete: $filename (Size: $size)"
else
  echo "Error: File download failed or file not found."
  exit 1
fi
