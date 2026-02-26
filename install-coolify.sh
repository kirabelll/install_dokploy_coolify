#!/bin/bash

# Coolify Installation Script
# This script installs Coolify - an open-source alternative to Heroku/Netlify/Vercel
# Based on official Coolify documentation: https://coolify.io/docs/get-started/installation
# 
# Supported OS: Debian-based, RedHat-based, SUSE-based, Arch Linux, Alpine Linux, Raspberry Pi OS 64-bit
# Supported Architectures: AMD64, ARM64
# Minimum Requirements: 2 CPU cores, 2GB RAM, 30GB storage
#
# Run this script as: sudo ./install-coolify.sh

set -e

echo "========================================="
echo "   Coolify Auto Installer"
echo "========================================="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root or with sudo privileges."
   echo "Usage: sudo ./install-coolify.sh"
   exit 1
fi

# Detect OS and architecture
echo "🔍 Detecting system information..."
OS_ID=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
OS_VERSION=$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"' || echo "unknown")
ARCH=$(uname -m)

echo "   OS: $OS_ID $OS_VERSION"
echo "   Architecture: $ARCH"

# Check architecture support
if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    echo "❌ Unsupported architecture: $ARCH"
    echo "   Coolify supports AMD64 and ARM64 only"
    exit 1
fi

# Check minimum requirements
echo "⚠️  Minimum requirements: 2 CPU cores, 2GB RAM, 30GB storage"
echo "   Please ensure your server meets these requirements"

# Check for snap Docker installation (not supported)
if command -v snap &> /dev/null && snap list docker &> /dev/null 2>&1; then
    echo "❌ Docker installed via snap is not supported!"
    echo "   Please remove snap Docker and use the official Docker installation"
    exit 1
fi

# Update system packages
echo "📦 Updating system packages..."
if command -v apt &> /dev/null; then
    apt update && apt upgrade -y
    # Install essential tools for Debian-based systems
    apt install -y curl wget git jq openssl
elif command -v yum &> /dev/null; then
    yum update -y
    yum install -y curl wget git jq openssl
elif command -v dnf &> /dev/null; then
    dnf update -y
    dnf install -y curl wget git jq openssl
elif command -v zypper &> /dev/null; then
    zypper refresh && zypper update -y
    zypper install -y curl wget git jq openssl
elif command -v pacman &> /dev/null; then
    pacman -Syu --noconfirm
    pacman -S --noconfirm curl wget git jq openssl
elif command -v apk &> /dev/null; then
    apk update && apk upgrade
    apk add curl wget git jq openssl
else
    echo "⚠️  Could not detect package manager. Please ensure curl, wget, git, jq, and openssl are installed."
fi

# Check if Docker is installed and version
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
    DOCKER_MAJOR=$(echo $DOCKER_VERSION | cut -d. -f1)
    
    if [[ $DOCKER_MAJOR -lt 24 ]]; then
        echo "⚠️  Docker version $DOCKER_VERSION detected. Coolify requires Docker 24+."
        echo "   Updating Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
    else
        echo "✅ Docker $DOCKER_VERSION is already installed and compatible"
    fi
else
    echo "🐳 Installing Docker Engine (version 24+)..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Start and enable Docker service
echo "🔧 Configuring Docker service..."
systemctl start docker
systemctl enable docker

# Configure Docker daemon settings
echo "⚙️  Configuring Docker daemon..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Restart Docker to apply configuration
systemctl restart docker

# Install Coolify using official installer
echo "🌟 Installing Coolify..."
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

echo ""
echo "========================================="
echo "🎉 Coolify Installation Completed!"
echo "========================================="
echo ""
echo "📋 Next Steps:"
echo "1. Access Coolify at: http://$(curl -s ifconfig.me):8000"
echo "   (Replace with your server's IP if the above doesn't work)"
echo ""
echo "2. 🚨 IMPORTANT: Create your admin account IMMEDIATELY!"
echo "   If someone else accesses the registration page first,"
echo "   they could gain full control of your server."
echo ""
echo "3. Configure your firewall (if needed):"
echo "   ufw allow 8000/tcp"
echo ""
echo "📚 Resources:"
echo "• Documentation: https://coolify.io/docs"
echo "• Discord Support: https://coolify.io/discord"
echo "• GitHub: https://github.com/coollabsio/coolify"
echo ""
echo "💡 Tips:"
echo "• Use a fresh server for best results"
echo "• Minimum 2GB RAM, 2 CPU cores recommended"
echo "• Monitor resource usage if running builds on same server"
echo "• Consider enabling swap space for better performance"
echo ""
echo "⚠️  Security Reminders:"
echo "• Change default passwords immediately"
echo "• Configure SSL certificates for production"
echo "• Set up regular backups"
echo "• Keep Coolify updated"
echo ""
echo "🔧 Troubleshooting:"
echo "• If you can't access Coolify, check firewall settings"
echo "• For Raspberry Pi: use private IP address"
echo "• Join Discord for community support"
echo ""
echo "========================================="