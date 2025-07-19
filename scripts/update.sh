#!/bin/bash

echo "🔄 Mise à jour rapide du Portfolio"
echo "================================="

# Vérifier qu'on est dans le bon répertoire
if [ ! -f "docker-compose.traefik.yml" ]; then
    echo "❌ Fichier docker-compose.traefik.yml introuvable"
    exit 1
fi

# Détecter la commande docker compose
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

echo "📥 Récupération des dernières modifications..."
git pull

echo "🏗️  Reconstruction et redémarrage des services..."
$DOCKER_COMPOSE -f docker-compose.traefik.yml up --build -d

echo "🧹 Nettoyage des images inutilisées..."
docker image prune -f

echo "📊 État des services :"
$DOCKER_COMPOSE -f docker-compose.traefik.yml ps

echo ""
echo "✅ Mise à jour terminée !"
echo "🌐 Votre portfolio est accessible sur vos domaines configurés"
