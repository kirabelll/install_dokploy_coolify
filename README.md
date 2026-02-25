
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

## 📋 Prerequisites

- Ubuntu 24.04 LTS server
- Root or sudo access
- Minimum 2GB RAM recommended
- 20GB+ available disk space
- Internet connection for downloading packages

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

- Change default passwords immediately
- Configure SSL certificates for production use
- Set up regular backups
- Keep the platform updated
- Use strong authentication methods

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

Both scripts automatically install and configure:

- **Docker Engine** - Container runtime
- **Docker Compose** - Multi-container orchestration
- **Required dependencies** - curl, git, unzip, etc.
- **Firewall rules** - Basic security configuration
- **Platform software** - The respective self-hosting platform

## ⚠️ Important Notes

- **Backup your data** before running these scripts
- **Review firewall settings** after installation
- **These scripts are designed for Ubuntu 24.04** - other versions may require modifications
- **Run with sudo privileges** as system-level changes are required
- **Ensure adequate server resources** for your expected workload

## 🤝 Contributing

Feel free to submit issues, fork the repository, and create pull requests for improvements.

## 📄 License

These installation scripts are provided as-is for educational and deployment purposes. Please refer to the respective platform licenses for usage terms.
