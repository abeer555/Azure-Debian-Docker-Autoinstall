#!/bin/bash

# Script for automated installation of Docker on Debian (ARM64)

set -e

# Function to check if a command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Check if running on ARM64 architecture
if [ "$(uname -m)" != "aarch64" ]; then
    echo "This script is intended for ARM64 architecture. Exiting."
    exit 1
fi

# Detect Debian version
debian_version=$(lsb_release -cs)
if [ -z "$debian_version" ]; then
    echo "Unable to detect Debian version. Exiting."
    exit 1
fi

echo "Detected Debian version: $debian_version"

# Update package index
echo "Updating package index..."
apt-get update
check_success "Failed to update package index"

# Install required packages
echo "Installing required packages..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
check_success "Failed to install required packages"

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
check_success "Failed to add Docker's GPG key"

# Set up Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
check_success "Failed to set up Docker repository"

# Update package index (again)
echo "Updating package index..."
apt-get update
check_success "Failed to update package index"

# Install Docker
echo "Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
check_success "Failed to install Docker"

# Add current user to docker group
if [ -n "$SUDO_USER" ]; then
    echo "Adding user $SUDO_USER to docker group..."
    usermod -aG docker $SUDO_USER
    check_success "Failed to add user to docker group"
fi

# Enable and start Docker service
echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker
check_success "Failed to enable and start Docker service"

echo "Docker installation completed successfully!"
echo "You may need to log out and log back in for group changes to take effect."
