#!/bin/bash

# Change directory
cd /home/ubuntu

# Update and upgrade system packages as root
sudo apt update && sudo apt upgrade -y

# Add public key to authorized keys file 
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSkMc19m28614Rb3sGEXQUN+hk4xGiufU9NYbVXWGVrF1bq6dEnAD/VtwM6kDc8DnmYD7GJQVvXlDzvlWxdpBaJEzKziJ+PPzNVMPgPhd01cBWPv82+/Wu6MNKWZmi74TpgV3kktvfBecMl+jpSUMnwApdA8Tgy8eB0qELElFBu6cRz+f6Bo06GURXP6eAUbxjteaq3Jy8mV25AMnIrNziSyQ7JOUJ/CEvvOYkLFMWCF6eas8bCQ5SpF6wHoYo/iavMP4ChZaXF754OJ5jEIwhuMetBFXfnHmwkrEIInaF3APIBBCQWL5RC4sJA36yljZCGtzOi5Y2jq81GbnBXN3Dsjvo5h9ZblG4uWfEzA2Uyn0OQNDcrecH3liIpowtGAoq8NUQf89gGwuOvRzzILkeXQ8DKHtWBee5Oi/z7j9DGfv7hTjDBQkh28LbSu9RdtPRwcCweHwTLp4X3CYLwqsxrIP8tlGmrVoZZDhMfyy/bGslZp5Bod2wnOMlvGktkHs="

echo "$SSH_PUB_KEY" >> /home/ubuntu/.ssh/authorized_keys

# ************* Installing Node Exporter *****************************

# Install necessary packages as root
sudo apt-get update -y
sudo apt-get install -y wget

# Download and install Node Exporter as root
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.6.0.linux-amd64.tar.gz
sudo mv node_exporter-1.6.0.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.6.0.linux-amd64*

# Create a systemd service for Node Exporter to run as 'ubuntu'
cat <<EOL | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
User=ubuntu
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOL

# Start and enable Node Exporter as root
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Install additional repositories and Python packages
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.9 python3.9-venv python3.9-dev -y
sudo apt install software-properties-common build-essential libssl-dev libffi-dev git -y

# Clone the repository
git clone "https://github.com/tjwkura5/ecommerce_terraform_deployment.git" 

# Change ownership of the repository directory
# sudo chown -R ubuntu:ubuntu /home/ubuntu/ecommerce_terraform_deployment

# Move into the backend directory of the cloned repository
cd ecommerce_terraform_deployment/backend 

# Create and activate a Python virtual environment
python3.9 -m venv venv
source venv/bin/activate

# Upgrade pip and install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Replace the ALLOWED_HOSTS with the private IP address in the Django settings
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = [\"$(hostname -I | awk '{print $1}')\"]/g" my_project/settings.py

# Update Django settings with database password and RDS endpoint
sed -i "s/'PASSWORD': '.*'/'PASSWORD': '${db_password}'/" my_project/settings.py
sed -i "s/'HOST': '.*'/'HOST': '${rds_endpoint}'/" my_project/settings.py

# Run Django database migrations
# python manage.py makemigrations account
# python manage.py makemigrations payments
# python manage.py makemigrations product
# python manage.py migrate auth --database=sqlite
# python manage.py migrate --database=sqlite
# python manage.py migrate payments --database=sqlite
# python manage.py showmigrations --database=sqlite
# python manage.py dumpdata --database=sqlite > datadump.json

# python manage.py migrate

# Migrate data from SQLite to RDS
# python manage.py dumpdata --database=sqlite --natural-foreign --natural-primary -e contenttypes -e auth.Permission --indent 4 > datadump.json
# python manage.py loaddata datadump.json

# Start the Django application
# python manage.py runserver 0.0.0.0:8000
# nohup python manage.py runserver 0.0.0.0:8000 &

# python manage.py dumpdata --database=sqlite -e contenttypes -e auth.Permission --indent 4 > datadump.json