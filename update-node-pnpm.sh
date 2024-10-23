#!/bin/bash

# Function to check if nvm is installed
check_nvm() {
    if ! command -v nvm &> /dev/null; then
        echo "nvm (Node Version Manager) is not installed. Please install it first."
        exit 1
    fi
}

# Function to check if corepack is enabled
check_corepack() {
    if ! command -v corepack &> /dev/null; then
        echo "corepack is not installed. Please install Node.js with corepack support."
        exit 1
    fi
}

# Function to update pnpm with corepack
update_pnpm_with_corepack() {
    echo "Updating pnpm to the latest version using corepack..."
    corepack prepare pnpm@latest --activate
}

# Function to update pnpm for both Node versions
update_pnpm() {
    echo "Updating pnpm for the latest LTS version..."
    nvm use --lts
    corepack prepare pnpm@latest --activate

    echo "Updating pnpm for the latest version..."
    nvm use node
    corepack prepare pnpm@latest --activate
}

# Check if nvm is installed
check_nvm

# Check if corepack is enabled
check_corepack

# Remove existing Node.js versions
echo "Removing all existing Node.js versions..."
nvm uninstall --lts
nvm uninstall node

# Install the latest LTS version of Node.js
echo "Installing the latest LTS version of Node.js..."
nvm install --lts

# Install the latest version of Node.js
echo "Installing the latest version of Node.js..."
nvm install node

# Update pnpm using corepack for both versions
update_pnpm

# Check installed versions
echo "Node.js LTS version: $(nvm run --lts --version)"
echo "Node.js latest version: $(nvm run node --version)"
echo "pnpm version for LTS: $(nvm run --lts pnpm -v)"
echo "pnpm version for latest: $(nvm run node pnpm -v)"

echo "Update completed successfully!"
