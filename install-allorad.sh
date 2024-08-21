#!/bin/bash

# Define the application name
APP_NAME="allorad"

# Fetch the latest version tag from GitHub API
VERSION=$(curl -s https://api.github.com/repos/allora-network/allora-chain/releases | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1)

# Define the base URL using the latest version
BASE_URL="https://github.com/allora-network/allora-chain/releases/download/$VERSION"

# Determine the operating system and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Construct the download URL
URL="${BASE_URL}/${APP_NAME}_${OS}_${ARCH}"

# Define the target directory
TARGET_DIR="$HOME/.local/bin"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Download the file to /tmp
wget -O "/tmp/${APP_NAME}" "$URL"

# Move the binary to the target directory
mv "/tmp/${APP_NAME}" "$TARGET_DIR"

# Change permissions to make it executable
chmod +x "$TARGET_DIR/$APP_NAME"

echo "Installation complete. The $APP_NAME version $VERSION is now available in $TARGET_DIR"
echo "To make $APP_NAME available from any terminal session, add the following line to your .bashrc or .zshrc:"
echo "export PATH=\"\$PATH:$TARGET_DIR\""
