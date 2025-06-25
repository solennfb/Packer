#!/bin/bash

set -e

echo "ENV is $ENV"
echo "NODE_VERSION is $NODE_VERSION"

# Ajouter le repo universe et les autres a installer
sudo add-apt-repository universe -y
sudo apt-get update -y
sudo apt-get install -y curl nodejs npm

# Installer n
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
chmod +x n
sudo mv n /usr/local/bin/n

# Changer la version de Node selon l'env
if [ "$ENV" = "dev" ] || [ "$ENV" = "staging" ]; then
  echo "Installing Node $NODE_VERSION"
  sudo n "$NODE_VERSION"
else
  echo "Installing Node LTS"
  sudo n lts
fi

# Vérif
node -v
