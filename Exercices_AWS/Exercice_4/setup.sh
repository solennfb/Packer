#!/bin/bash

set -e

# MAJ des paquets
sudo apt-get update -y

# Installer Nginx
sudo apt-get install -y nginx

# Créer page HTML
echo "<h1>Hello from Packer AMI with Nginx!</h1>" | sudo tee /var/www/html/index.html

# Activer et démarrer Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# 🔍 Vérification de la configuration Nginx
echo "verif cong nginx"
sudo nginx -t

# 📊 Vérification du status du service
echo "verif statut srvice"
sudo systemctl status nginx | grep -q "active (running)"

# 🌐 Healthcheck HTTP (boucle avec timeout)
echo "Check http"
for i in {1..10}; do
  if curl -s http://localhost | grep -q "Hello from Packer"; then
    echo "Nginx ok sur le port 80"
    exit 0
  fi
  echo "Attente de Nginx($i/10)"
  sleep 2
done

echo "pas de réponse de Nginx"
exit 1
