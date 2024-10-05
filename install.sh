#!/bin/bash

# Script for automated installation of Docker on Debian (amd64)

set -e

# Function to check if a command was successful
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Check if running on amd64 architecture
if [ "$(uname -m)" != "x86_64" ]; then
    echo "This script is intended for amd64 architecture. Exiting."
    exit 1
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Remove old versions of Docker
echo "Removing old Docker packages..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove $pkg -y
done
check_success "Failed to remove old Docker packages"

# Download Docker packages
echo "Downloading Docker packages..."
DOCKER_PACKAGES=(
    "containerd.io_1.7.22-1_amd64.deb"
    "docker-buildx-plugin_0.17.1-1~debian.12~bookworm_amd64.deb"
    "docker-ce-cli_27.3.1-1~debian.12~bookworm_amd64.deb"
    "docker-ce-rootless-extras_27.3.1-1~debian.12~bookworm_amd64.deb"
    "docker-ce_27.3.1-1~debian.12~bookworm_amd64.deb"
    "docker-compose-plugin_2.29.7-1~debian.12~bookworm_amd64.deb"
)
for package in "${DOCKER_PACKAGES[@]}"; do
    wget "https://download.docker.com/linux/debian/dists/bookworm/pool/stable/amd64/$package"
    check_success "Failed to download $package"
done

# Install Docker packages
echo "Installing Docker packages..."
sudo dpkg -i *.deb
check_success "Failed to install Docker packages"

# Clean up downloaded .deb files
echo "Cleaning up..."
rm *.deb
check_success "Failed to remove .deb files"

echo "Docker installation completed successfully!"
echo "You may need to log out and log back in for group changes to take effect."