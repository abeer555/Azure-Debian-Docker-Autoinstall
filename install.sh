#!/bin/bash

# Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker repository
echo "Setting up Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
echo "Updating package index..."
sudo apt update

# Install Docker Engine
echo "Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Verify Docker is running
echo "Checking Docker status..."
sudo systemctl status docker

# Start Docker if it's not running
if ! sudo systemctl is-active --quiet docker; then
    echo "Starting Docker..."
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Test Docker installation
echo "Running a test container..."
sudo docker run hello-world

# Optional: Add user to Docker group
echo "Adding user to Docker group (optional)..."
sudo usermod -aG docker $USER

echo "Docker installation complete. Please log out and back in for group changes to take effect (if applicable)."
