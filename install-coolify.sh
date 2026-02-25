#!/bin/bash

# Coolify Installation Script for Ubuntu 24.04
# This script installs Coolify - an open-source alternative to Heroku/Netlify/Vercel

set -e

echo "🚀 Starting Coolify installation on Ubuntu 24.04..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Update system packages
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "🔧 Installing required dependencies..."
sudo apt install -y curl wget git

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker not found. Installing Docker..."
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    echo "✅ Docker installed successfully"
    rm get-docker.sh
else
    echo "✅ Docker is already installed"
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "🔧 Installing Docker Compose..."
    sudo apt install -y docker-compose-plugin
    echo "✅ Docker Compose installed successfully"
else
    echo "✅ Docker Compose is already installed"
fi

# Install Coolify
echo "🌟 Installing Coolify..."
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

echo ""
echo "🎉 Coolify installation completed!"
echo ""
echo "📋 Next steps:"
echo "1. If this is your first time installing Docker, you may need to log out and log back in"
echo "2. Access Coolify at: http://your-server-ip:8000"
echo "3. Follow the setup wizard to configure your Coolify instance"
echo ""
echo "📚 Documentation: https://coolify.io/docs"
echo "💬 Support: https://coolify.io/docs/contact"
echo ""
echo "⚠️  Important: Make sure to configure your firewall to allow access to port 8000"
echo "   sudo ufw allow 8000/tcp"
echo ""
