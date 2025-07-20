#!/bin/bash

echo "⚡ Déploiement rapide de l'application"
echo "====================================="

# Arrêter les services
echo "🛑 Arrêt des services..."
docker compose -f docker-compose.traefik.yml down

# Construire et démarrer
echo "🏗️  Build et démarrage..."
docker compose -f docker-compose.traefik.yml up --build -d

# Attendre un peu
sleep 10

# Afficher le statut
echo "📊 Statut:"
docker compose -f docker-compose.traefik.yml ps

echo ""
echo "✅ Application déployée !"
echo "🌐 Accessible sur: http://localhost"
echo "📋 Logs: docker compose -f docker-compose.traefik.yml logs -f"
