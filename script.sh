#!/bin/bash

# Actualiza el sistema
sudo apt update && sudo apt upgrade -y

# Instalación de herramientas básicas
sudo apt install -y curl wget git gnupg lsb-release ca-certificates software-properties-common apt-transport-https

# Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install -y

# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt --fix-broken install -y

# Warp Terminal
wget https://winstall.app/api/public/download/deb/warp-terminal
sudo dpkg -i warp-terminal.deb
sudo apt --fix-broken install -y

# Docker y Docker Desktop
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://desktop.docker.com/linux/main/amd64/docker-desktop-<version>.deb" -o docker-desktop.deb
sudo dpkg -i docker-desktop.deb
sudo apt --fix-broken install -y
sudo groupadd docker
sudo usermod -aG docker $USER

# nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts

# Configuración de pnpm con corepack
corepack enable
corepack prepare pnpm@latest --activate

# OBS Studio
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update
sudo apt install -y obs-studio

# Logseq
wget https://github.com/logseq/logseq/releases/download/<latest_version>/Logseq-linux-x64-<version>.AppImage
chmod +x Logseq-linux-x64-<version>.AppImage
sudo mv Logseq-linux-x64-<version>.AppImage /usr/local/bin/logseq

# Spotify
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install -y spotify-client

# Oracle VM VirtualBox
sudo apt update
sudo apt install -y virtualbox

# GitHub CLI
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh -y

# VLC
sudo apt install -y vlc

# Limpiar archivos innecesarios
sudo apt autoremove -y
sudo apt clean

echo "Instalación y configuración completa. ¡Disfruta tu máquina Debian!"
