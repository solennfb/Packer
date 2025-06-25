#!/bin/bash

set -e

# MAJ les paquets
sudo apt-get update -y

# Installer Nginx
sudo apt-get install -y nginx

# Ajout HTML simple
echo "<h1>Hello from Packer AMI with Nginx!</h1>" | sudo tee /var/www/html/index.html

# Activer Nginx
sudo systemctl enable nginx
sudo systemctl start nginx
