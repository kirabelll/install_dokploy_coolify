#!/bin/bash

# Coolify Installation Script for Ubuntu 24.04
# This script installs Coolify - an open-source alternative to Heroku/Netlify/Vercel
# Run this script as: sudo ./install-coolify.sh

set -e

echo "🚀 Starting Coolify installation on Ubuntu 24.04..."

# Check if running with sudo
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run with sudo privileges."
   echo "Usage: sudo ./install-coolify.sh"
   exit 1
fi

# Get the actual user who ran sudo
ACTUAL_USER=${SUDO_USER:-$USER}
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)

# Update system packages
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install required dependencies
echo "🔧 Installing required dependencies..."
apt install -y curl wget git

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker not found. Installing Docker..."
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    
    # Add actual user to docker group
    usermod -aG docker $ACTUAL_USER
    
    # Start and enable Docker service
    systemctl start docker
    systemctl enable docker
    
    echo "✅ Docker installed successfully"
    rm get-docker.sh
else
    echo "✅ Docker is already installed"
    # Ensure user is in docker group
    usermod -aG docker $ACTUAL_USER
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "🔧 Installing Docker Compose..."
    apt install -y docker-compose-plugin
    echo "✅ Docker Compose installed successfully"
else
    echo "✅ Docker Compose is already installed"
fi

# Install Coolify (run as actual user, not root)
echo "🌟 Installing Coolify..."
sudo -u $ACTUAL_USER bash -c 'curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash'

echo ""
echo "🎉 Coolify installation completed!"
echo ""
echo "📋 Next steps:"
echo "1. Log out and log back in for Docker group changes to take effect"
echo "2. Access Coolify at: http://your-server-ip:8000"
echo "3. Follow the setup wizard to configure your Coolify instance"
echo ""
echo "📚 Documentation: https://coolify.io/docs"
echo "💬 Support: https://coolify.io/docs/contact"
echo ""
echo "⚠️  Important: Configure your firewall to allow access to port 8000"
echo "   ufw allow 8000/tcp"
echo ""
echo "🔄 To apply Docker group changes immediately, run:"
echo "   newgrp docker"
echo ""