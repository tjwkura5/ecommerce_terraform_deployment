#!/bin/bash

# Update and upgrade system packages
sudo apt update 

# Add public key to authorized keys file
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSkMc19m28614Rb3sGEXQUN+hk4xGiufU9NYbVXWGVrF1bq6dEnAD/VtwM6kDc8DnmYD7GJQVvXlDzvlWxdpBaJEzKziJ+PPzNVMPgPhd01cBWPv82+/Wu6MNKWZmi74TpgV3kktvfBecMl+jpSUMnwApdA8Tgy8eB0qELElFBu6cRz+f6Bo06GURXP6eAUbxjteaq3Jy8mV25AMnIrNziSyQ7JOUJ/CEvvOYkLFMWCF6eas8bCQ5SpF6wHoYo/iavMP4ChZaXF754OJ5jEIwhuMetBFXfnHmwkrEIInaF3APIBBCQWL5RC4sJA36yljZCGtzOi5Y2jq81GbnBXN3Dsjvo5h9ZblG4uWfEzA2Uyn0OQNDcrecH3liIpowtGAoq8NUQf89gGwuOvRzzILkeXQ8DKHtWBee5Oi/z7j9DGfv7hTjDBQkh28LbSu9RdtPRwcCweHwTLp4X3CYLwqsxrIP8tlGmrVoZZDhMfyy/bGslZp5Bod2wnOMlvGktkHs="

echo "$SSH_PUB_KEY" >> /home/ubuntu/.ssh/authorized_keys

# Install git and curl for downloading Node.js setup
sudo apt install -y git curl

# Download and install Node.js (includes npm)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs 

sleep 60 

# Verify installations
node -v
npm -v

# Set npm to install with legacy OpenSSL provider
export NODE_OPTIONS=--openssl-legacy-provider

# Set up the Node.js application
# Clone the GitHub repository
git clone "https://github.com/tjwkura5/ecommerce_terraform_deployment.git"

# Change ownership of the repository directory
# sudo chown -R ubuntu:ubuntu /home/ubuntu/ecommerce_terraform_deployment

# Move into the frontend directory of the repository
cd ecommerce_terraform_deployment/frontend

# Replace the placeholder with the private IP of the backend EC2 instance in package.json
sed -i "s|http://private_ec2_ip:8000|http://${BACKEND_PRIVATE_IP}:8000|" package.json

# Install application dependencies
npm i

# Start the Node.js application
# Uncomment below to run in the background
# nohup npm start &

# Start application in the foreground (for testing)
npm start
