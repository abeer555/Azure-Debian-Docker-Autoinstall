#!/bin/bash

# Test Docker installation

echo "Testing Docker installation..."

# Check Docker version
docker --version
if [ $? -ne 0 ]; then
  echo "Error: Docker is not installed or not in PATH"
  exit 1
fi

# Run a test container
echo "Running a test container..."
docker run --rm hello-world

if [ $? -eq 0 ]; then
  echo "Docker is installed and working correctly!"
else
  echo "Error: Failed to run test container"
  exit 1
fi
