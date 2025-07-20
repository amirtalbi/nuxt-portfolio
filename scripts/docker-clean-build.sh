#!/bin/bash

echo "🧹 Nettoyage et optimisation Docker"
echo "=================================="

# Arrêter tous les conteneurs
echo "🛑 Arrêt des conteneurs..."
docker compose -f docker-compose.traefik.yml down

# Nettoyer les images et caches Docker
echo "🗑️  Nettoyage des images inutilisées..."
docker system prune -f

# Supprimer les volumes node_modules si ils existent
echo "📦 Nettoyage des volumes node_modules..."
docker volume ls -q | grep node_modules | xargs -r docker volume rm

# Nettoyer le cache npm local (sur macOS)
echo "🧹 Nettoyage du cache npm local..."
rm -rf node_modules package-lock.json
rm -rf backend/node_modules backend/package-lock.json
rm -rf .nuxt .output

# Réinstaller les dépendances localement (pour le cache)
echo "📦 Réinstallation des dépendances..."
npm install
cd backend && npm install && cd ..

# Build avec cache
echo "🏗️  Construction optimisée..."
docker compose -f docker-compose.traefik.yml build --no-cache --pull

echo ""
echo "✅ Nettoyage terminé !"
echo "🚀 Vous pouvez maintenant lancer: docker compose -f docker-compose.traefik.yml up -d"
