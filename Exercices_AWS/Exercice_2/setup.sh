#!/bin/bash

# Ajout du dépôt universe sinon erreur
sudo add-apt-repository universe -y

# Maj des paquets
sudo apt-get update -y

# Installation des outils
sudo apt-get install -y htop git jq
