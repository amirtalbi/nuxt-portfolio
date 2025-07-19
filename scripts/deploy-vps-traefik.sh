#!/bin/bash

echo "🚀 Déploiement du Portfolio avec Traefik sur VPS"
echo "=============================================="

# Variables à configurer
DOMAIN=""
EMAIL=""
PROJECTS_SUBDOMAIN="projects"

# Demander les informations à l'utilisateur
if [ -z "$DOMAIN" ]; then
    read -p "🌐 Entrez votre nom de domaine (ex: monsite.nc.me): " DOMAIN
fi

if [ -z "$EMAIL" ]; then
    read -p "📧 Entrez votre email pour Let's Encrypt: " EMAIL
fi

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "❌ Le domaine et l'email sont requis"
    exit 1
fi

echo ""
echo "📝 Configuration avec:"
echo "   Domaine principal: $DOMAIN"
echo "   Email: $EMAIL"
echo "   Sous-domaines projets: project1.$DOMAIN, project2.$DOMAIN"
echo ""

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "docker-compose.traefik.yml" ]; then
    echo "❌ Fichier docker-compose.traefik.yml introuvable"
    echo "   Assurez-vous d'être dans le répertoire du projet"
    exit 1
fi

# Vérifier que Docker est installé et accessible
if ! command -v docker &> /dev/null || ! docker info &> /dev/null; then
    echo "❌ Docker n'est pas installé ou accessible"
    echo "   Exécutez d'abord: ./scripts/prepare-vps.sh"
    exit 1
fi

# Utiliser docker compose ou docker-compose selon la version
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Arrêter les services existants
echo "🛑 Arrêt des services existants..."
$DOCKER_COMPOSE -f docker-compose.traefik.yml down --remove-orphans 2>/dev/null || true

# Créer le réseau Traefik s'il n'existe pas
echo "🌐 Création du réseau Traefik..."
docker network create traefik 2>/dev/null || true

# Créer les répertoires nécessaires
echo "📁 Création des répertoires..."
mkdir -p traefik/data
mkdir -p traefik/logs
touch traefik/data/acme.json
chmod 600 traefik/data/acme.json

# Remplacer les variables dans les fichiers de configuration
echo "⚙️  Configuration des domaines..."

# Traefik configuration
sed -i "s/your-email@example.com/$EMAIL/g" traefik/traefik.yml
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" traefik/traefik.yml

# Docker Compose
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" docker-compose.traefik.yml
sed -i "s/your-email@example.com/$EMAIL/g" docker-compose.traefik.yml

# Backend environment
if [ -f "backend/.env" ]; then
    sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=https://$DOMAIN|g" backend/.env
else
    echo "⚠️  Fichier backend/.env non trouvé. Assurez-vous de le configurer."
fi

# Construire et démarrer les services
echo "🏗️  Construction et démarrage des services..."
$DOCKER_COMPOSE -f docker-compose.traefik.yml up --build -d

# Attendre que les services démarrent
echo "⏳ Attente du démarrage des services..."
sleep 30

# Vérifier le statut des services
echo "📊 Statut des services:"
$DOCKER_COMPOSE -f docker-compose.traefik.yml ps

# Test de connectivité
echo ""
echo "🔍 Test de connectivité..."

echo -n "Traefik Dashboard: "
if curl -s -k https://traefik.$DOMAIN > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

echo -n "Portfolio principal: "
if curl -s -k https://$DOMAIN > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

echo -n "Project1: "
if curl -s -k https://project1.$DOMAIN > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible (normal si pas encore configuré)"
fi

echo -n "Project2: "
if curl -s -k https://project2.$DOMAIN > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

echo ""
echo "🎉 Déploiement terminé !"
echo ""
echo "🌐 Vos services sont accessibles sur :"
echo "   📱 Portfolio: https://$DOMAIN"
echo "   🔧 Traefik Dashboard: https://traefik.$DOMAIN"
echo "   🎯 Project1: https://project1.$DOMAIN"
echo "   🎯 Project2: https://project2.$DOMAIN"
echo ""
echo "🔧 Commandes utiles :"
echo "   📊 Voir les logs: $DOCKER_COMPOSE -f docker-compose.traefik.yml logs -f"
echo "   🛑 Arrêter: $DOCKER_COMPOSE -f docker-compose.traefik.yml down"
echo "   🔄 Redémarrer: $DOCKER_COMPOSE -f docker-compose.traefik.yml restart"
echo "   🏗️  Reconstruire: $DOCKER_COMPOSE -f docker-compose.traefik.yml up --build -d"
echo ""
echo "⚠️  Notes importantes :"
echo "   🔒 Les certificats SSL sont générés automatiquement"
echo "   📧 Configurez backend/.env avec vos paramètres email"
echo "   🔥 Le firewall autorise les ports 80, 443 et SSH"
echo "   📊 Surveillez les logs pour détecter les problèmes"
echo ""
echo "🎯 Pour ajouter de nouveaux projets :"
echo "   1. Créez le sous-domaine DNS"
echo "   2. Ajoutez le service dans docker-compose.traefik.yml"
echo "   3. Redéployez avec la commande rebuild"
