#!/bin/bash

# Coolify Automatic Installation Script for Ubuntu 24.04
# This script fully automates Coolify installation with no user interaction required
# Run this script as: sudo ./install-coolify.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

print_header "========================================="
print_header "   Coolify Automatic Installer"
print_header "========================================="

# Check if running with sudo
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run with sudo privileges."
   echo "Usage: sudo ./install-coolify.sh"
   exit 1
fi

# Get the actual user who ran sudo
ACTUAL_USER=${SUDO_USER:-$USER}
ACTUAL_HOME=$(eval echo ~$ACTUAL_USER)

print_status "Starting automatic Coolify installation..."
print_status "Target user: $ACTUAL_USER"

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Update system packages
print_status "Updating system packages..."
apt update -y
apt upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Install required dependencies
print_status "Installing required dependencies..."
apt install -y curl wget git unzip ca-certificates gnupg lsb-release ufw

# Configure firewall automatically
print_status "Configuring firewall..."
ufw --force reset
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP
ufw allow 443/tcp  # HTTPS
ufw allow 8000/tcp # Coolify
ufw --force enable

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_status "Docker not found. Installing Docker..."
    
    # Remove old Docker versions
    apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    
    # Add Docker repository
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Start and enable Docker service
    systemctl start docker
    systemctl enable docker
    
    print_status "Docker installed successfully"
else
    print_status "Docker is already installed"
fi

# Add user to docker group
usermod -aG docker $ACTUAL_USER

# Install Coolify automatically
print_status "Installing Coolify..."
sudo -u $ACTUAL_USER bash -c 'curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash'

# Get server IP for display
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "YOUR_SERVER_IP")

echo ""
print_header "🎉 Coolify installation completed successfully!"
echo ""
echo -e "${CYAN}📋 Access Information:${NC}"
echo "   External URL: http://$SERVER_IP:8000"
echo "   Local URL: http://localhost:8000"
echo ""
echo -e "${CYAN}📚 Resources:${NC}"
echo "   Documentation: https://coolify.io/docs"
echo "   GitHub: https://github.com/coollabsio/coolify"
echo "   Support: https://coolify.io/docs/contact"
echo ""
echo -e "${CYAN}🔧 Automatic Configuration Applied:${NC}"
echo "   ✅ System packages updated"
echo "   ✅ Docker installed and configured"
echo "   ✅ Firewall configured (ports 22, 80, 443, 8000)"
echo "   ✅ User added to docker group"
echo "   ✅ Coolify installed and ready"
echo ""
print_header "� Final Step:"
echo "Log out and log back in, then access Coolify at the URL above"
echo "Or run: newgrp docker && docker ps"
echo ""
print_warning "For production use, configure SSL certificates and secure authentication!"
echo ""