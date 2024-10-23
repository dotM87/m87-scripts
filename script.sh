#!/bin/bash

# Function to confirm installation
confirm_installation() {
    echo "Do you want to install $1? (y/n)"
    read -r response
    while true; do
        if [[ "$response" == "y" ]]; then
            return 0
        elif [[ "$response" == "n" ]]; then
            return 1
        else
            echo "Invalid choice. Please enter a valid option."
        fi
    done
}

# Update the system
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Install basic tools
echo "Installing basic tools..."
sudo apt install -y curl wget git gnupg lsb-release ca-certificates software-properties-common apt-transport-https

# NeoFetch
if confirm_installation "NeoFetch"; then
    sudo apt install -y neofetch
fi

# Google Chrome
if confirm_installation "Google Chrome"; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt --fix-broken install -y
fi

# Visual Studio Code
if confirm_installation "Visual Studio Code"; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
fi

# Discord
if confirm_installation "Discord"; then
    wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo dpkg -i discord.deb
    sudo apt --fix-broken install -y
fi

# Warp Terminal
if confirm_installation "Warp Terminal"; then
    wget https://winstall.app/api/public/download/deb/warp-terminal
    sudo dpkg -i warp-terminal.deb
    sudo apt --fix-broken install -y
fi

# Docker and Docker Desktop
if confirm_installation "Docker and Docker Desktop"; then
    sudo apt install qemu-system qemu-user-static
    modprobe kvm
    if [[ "$cpu_vendor" == "GenuineIntel" ]]; then
      modprobe kvm-intel
    elif [[ "$cpu_vendor" == "AuthenticAMD" ]]; then
      modprobe kvm-amd
    fi
    kvm-ok
    lsmod | grep kvm
    ls -al /dev/kvm
    sudo usermod -aG kvm $USER
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo curl -L "https://desktop.docker.com/linux/main/amd64/docker-desktop-<version>.deb" -o docker-desktop.deb
    sudo dpkg -i docker-desktop.deb
    sudo apt --fix-broken install -y
    sudo groupadd docker
    sudo usermod -aG docker $USER
fi

# nvm (Node Version Manager)
if confirm_installation "nvm and Node.js"; then
    # Install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    source ~/.bashrc
    # Install Node.js
    while true; do
        echo "Which version of Node.js would you like to install? (1) LTS or (2) Latest"
        read -r node_version_choice

        if [[ "$node_version_choice" == "1" ]]; then
            nvm install --lts
            nvm use --lts
            echo "LTS version of Node.js installed."
            break
        elif [[ "$node_version_choice" == "2" ]]; then
            nvm install node
            nvm use node
            echo "Latest version of Node.js installed."
            break
        else
            echo "Invalid choice. Please enter 1 for LTS or 2 for Latest."
        fi
    done
fi

# Configure pnpm with corepack
if confirm_installation "pnpm with corepack"; then
    corepack enable
    corepack prepare pnpm@latest --activate
fi

# Oracle VM VirtualBox
if confirm_installation "Oracle VM VirtualBox"; then
    sudo apt update
    sudo apt install -y virtualbox
fi

# GitHub CLI
if confirm_installation "GitHub CLI"; then
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo apt-add-repository https://cli.github.com/packages
    sudo apt update
    sudo apt install gh -y
fi

# Postman
if confirm_installation "Postman"; then
    wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux.tar.gz
    sudo tar -xzf postman-linux.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/bin/postman

    # Create desktop entry
    echo "[Desktop Entry]
Name=Postman
Exec=/usr/bin/postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Type=Application
Categories=Development;
Comment=Postman is a collaboration platform for API development." | sudo tee ~/.local/share/applications/postman.desktop
fi

# OBS Studio
if confirm_installation "OBS Studio"; then
    sudo add-apt-repository ppa:obsproject/obs-studio
    sudo apt update
    sudo apt install -y obs-studio
fi

# Logseq
if confirm_installation "Logseq"; then
    wget https://github.com/logseq/logseq/releases/download/<latest_version>/Logseq-linux-x64-<version>.AppImage
    chmod +x Logseq-linux-x64-<version>.AppImage
    sudo mv Logseq-linux-x64-<version>.AppImage /usr/local/bin/logseq

    # Create a desktop entry
    echo "[Desktop Entry]
Name=Logseq
Exec=/opt/logseq/Logseq
Icon=/opt/logseq/resources/app/icon.png
Type=Application
Categories=Utility;
Comment=Logseq is a privacy-first, open-source knowledge base." | sudo tee ~/.local/share/applications/logseq.desktop
fi

# Spotify
if confirm_installation "Spotify"; then
    curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install -y spotify-client
fi

# VLC
if confirm_installation "VLC"; then
    sudo apt install -y vlc
fi

# Clean up unnecessary files
echo "Cleaning up unnecessary files..."
sudo apt autoremove -y
sudo apt clean

echo "Installation and configuration complete. ;D"
