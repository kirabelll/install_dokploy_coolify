#!/usr/bin/env bash

set -e

echo "========================================="
echo "   Dokploy Auto Installer - Ubuntu Server"
echo "========================================="

# Update system

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing required packages..."
sudo apt install -y curl git unzip ca-certificates gnupg lsb-release ufw

# Remove old docker

echo "Removing old docker versions..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# Add docker repo

echo "Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable docker

sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group

sudo usermod -aG docker $USER

# Firewall rules

echo "Configuring firewall..."
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 3000
sudo ufw --force enable

# Install Dokploy

echo "Installing Dokploy..."
curl -sSL https://dokploy.com/install.sh | bash

echo "========================================="
echo "Installation Complete!"
echo "Open in browser: http://YOUR_SERVER_IP:3000"
echo "Logout and login again for docker permissions"
echo "========================================="