#!/bin/bash

echo "🚀 Préparation du VPS pour le déploiement"
echo "========================================"

# Mise à jour du système
echo "📦 Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installation des outils essentiels
echo "🔧 Installation des outils..."
sudo apt install -y curl wget git nano htop ufw fail2ban

# Installation de Docker si pas déjà installé
if ! command -v docker &> /dev/null; then
    echo "🐳 Installation de Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# Installation de Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "🔗 Installation de Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Configuration du firewall
echo "🔥 Configuration du firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# Création d'un utilisateur pour l'application (optionnel mais recommandé)
if ! id "portfolio" &>/dev/null; then
    echo "👤 Création de l'utilisateur portfolio..."
    sudo adduser --disabled-password --gecos "" portfolio
    sudo usermod -aG docker portfolio
fi

# Création des répertoires
echo "📁 Création des répertoires..."
sudo mkdir -p /home/portfolio/app
sudo chown -R portfolio:portfolio /home/portfolio/app

echo "✅ VPS préparé avec succès !"
echo ""
echo "🔑 Prochaines étapes :"
echo "1. Redémarrez votre session SSH pour appliquer les groupes Docker"
echo "2. Clonez votre projet dans /home/portfolio/app"
echo "3. Configurez vos variables d'environnement"
echo "4. Lancez le déploiement"
