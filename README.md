
# Self-Hosting Platform Installers

This repository contains automated installation scripts for popular self-hosting platforms on Ubuntu servers. These tools help you deploy your own cloud infrastructure alternatives.

## 🚀 Available Platforms

### Dokploy
An open-source alternative to Vercel, Netlify, and Heroku that simplifies application deployment and management.

**Features:**
- Deploy applications from Git repositories
- Built-in database support (PostgreSQL, MySQL, MongoDB, Redis)
- SSL certificate management
- Docker container orchestration
- Web-based dashboard

### Coolify
A self-hostable Heroku/Netlify/Vercel alternative that supports multiple deployment methods.

**Features:**
- Git-based deployments
- Multiple runtime support (Node.js, Python, PHP, etc.)
- Database management
- Automatic SSL certificates
- Resource monitoring
- Docker container orchestration

**Supported Systems:**
- **OS:** Debian-based, RedHat-based, SUSE-based, Arch Linux, Alpine Linux, Raspberry Pi OS 64-bit
- **Architecture:** AMD64, ARM64
- **Requirements:** 2 CPU cores, 2GB RAM, 30GB storage minimum

## 📋 Prerequisites

### For Dokploy
- Ubuntu 24.04 LTS server
- Root or sudo access
- Minimum 2GB RAM recommended
- 20GB+ available disk space
- Internet connection for downloading packages

### For Coolify
- **Supported OS:** Debian-based, RedHat-based, SUSE-based, Arch Linux, Alpine Linux, Raspberry Pi OS 64-bit
- **Architecture:** AMD64 or ARM64
- **Minimum Requirements:** 2 CPU cores, 2GB RAM, 30GB storage
- Root access (non-root users not fully supported)
- Internet connection for downloading packages

**Note:** Use a fresh server for Coolify to avoid conflicts with existing applications.

## 🛠️ Installation

### Install Dokploy

```bash
# Make the script executable
chmod +x ./install-dokploy.sh

# Run the installation
sudo ./install-dokploy.sh
```

**Access:** `http://YOUR_SERVER_IP:3000`

### Install Coolify

```bash
# Make the script executable
chmod +x ./install-coolify.sh

# Run the installation
sudo ./install-coolify.sh
```

**Access:** `http://YOUR_SERVER_IP:8000`

## 🔧 Post-Installation Steps

### For Both Platforms

1. **Log out and log back in** to apply Docker group permissions
2. **Configure your firewall** if needed:
   ```bash
   # For Dokploy
   sudo ufw allow 3000/tcp
   
   # For Coolify
   sudo ufw allow 8000/tcp
   ```
3. **Access the web interface** using your server's IP address
4. **Follow the setup wizard** to complete configuration

### Security Recommendations

- **Create admin account immediately** after Coolify installation (critical security step)
- Change default passwords immediately
- Configure SSL certificates for production use
- Set up regular backups
- Keep the platform updated
- Use strong authentication methods
- Configure firewall properly

## 📚 Documentation & Support

### Dokploy
- **Documentation:** [dokploy.com/docs](https://dokploy.com/docs)
- **GitHub:** [dokploy/dokploy](https://github.com/dokploy/dokploy)
- **Community:** [Discord](https://discord.gg/2tBnJ3jDJc)

### Coolify
- **Documentation:** [coolify.io/docs](https://coolify.io/docs)
- **GitHub:** [coollabsio/coolify](https://github.com/coollabsio/coolify)
- **Support:** [coolify.io/docs/contact](https://coolify.io/docs/contact)

## 🔍 What Gets Installed

### Dokploy Installation
- **Docker Engine** - Container runtime
- **Docker Compose** - Multi-container orchestration
- **Required dependencies** - curl, git, unzip, etc.
- **Firewall rules** - Basic security configuration
- **Dokploy platform** - The self-hosting platform

### Coolify Installation
- **Essential tools** - curl, wget, git, jq, openssl
- **Docker Engine (v24+)** - Latest container runtime with proper configuration
- **Docker daemon settings** - Optimized logging and performance
- **SSH key generation** - For server management
- **Coolify platform** - Complete self-hosting solution
- **Directory structure** - Organized at `/data/coolify`

## ⚠️ Important Notes

- **Backup your data** before running these scripts
- **Review firewall settings** after installation
- **For Coolify:** Immediately create admin account after installation to prevent unauthorized access
- **Docker via snap is not supported** for Coolify installations
- **Coolify requires Docker 24+** - the script will update if needed
- **Use fresh servers** when possible to avoid conflicts
- **Run with root privileges** as system-level changes are required
- **Ensure adequate server resources** for your expected workload
- **Non-LTS Ubuntu versions** require manual Coolify installation

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for improvements.

## 📄 License

These installation scripts are provided as-is for educational and deployment purposes. Please refer to the respective platform licenses for usage terms.
