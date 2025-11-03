#!/bin/bash

# Update the apt package list
sudo apt-get update -y

# Upgrade all installed packages to the latest version
sudo apt-get upgrade -y

# Install NGINX
sudo apt-get install -y nginx

# Start NGINX service
sudo systemctl start nginx

# Enable NGINX to start on boot
sudo systemctl enable nginx

# Confirm NGINX is installed and running
echo "NGINX has been installed and started successfully."

# Display the status of the NGINX service
sudo systemctl status nginx
