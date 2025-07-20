#!/bin/bash

echo "🔧 Correction du déploiement VPS"
echo "================================"

# Vérifier qu'on est sur le VPS
if [ ! -f "/etc/os-release" ]; then
    echo "❌ Ce script doit être exécuté sur le VPS"
    exit 1
fi

# Arrêter les services
echo "🛑 Arrêt des services..."
docker compose -f docker-compose.traefik.yml down 2>/dev/null || true

# Générer les package-lock.json manquants
echo "📦 Génération des fichiers package-lock.json..."

# Frontend
if [ ! -f "package-lock.json" ]; then
    echo "   Génération package-lock.json frontend..."
    # Utiliser une image Node temporaire pour générer le lock file
    docker run --rm -v $(pwd):/app -w /app node:20-alpine sh -c "npm install --package-lock-only"
fi

# Backend
if [ ! -f "backend/package-lock.json" ]; then
    echo "   Génération package-lock.json backend..."
    docker run --rm -v $(pwd)/backend:/app -w /app node:20-alpine sh -c "npm install --package-lock-only"
fi

# Vérifier que les fichiers .env existent
if [ ! -f "backend/.env" ]; then
    echo "⚠️  Création du fichier backend/.env..."
    cp backend/.env.example backend/.env
    echo "📝 IMPORTANT: Configurez backend/.env avec vos paramètres email !"
fi

# Créer le réseau Traefik
echo "🌐 Création du réseau Traefik..."
docker network create traefik-network 2>/dev/null || true

# Nettoyer les images pour forcer le rebuild
echo "🧹 Nettoyage des images existantes..."
docker image prune -f

# Construire et démarrer
echo "🏗️  Construction et démarrage..."
docker compose -f docker-compose.traefik.yml up --build -d

# Attendre le démarrage
echo "⏳ Attente du démarrage..."
sleep 30

# Vérifier le statut
echo "📊 Statut des services:"
docker compose -f docker-compose.traefik.yml ps

echo ""
echo "✅ Correction terminée !"
echo ""
echo "🌐 Vos services devraient être accessibles sur :"
echo "   📱 Portfolio: https://$(hostname -f || echo 'votre-domaine')"
echo "   🔧 Traefik: https://traefik.$(hostname -f || echo 'votre-domaine')"
echo ""
echo "📋 Commandes utiles :"
echo "   📊 Logs: docker compose -f docker-compose.traefik.yml logs -f"
echo "   🔄 Redémarrer: docker compose -f docker-compose.traefik.yml restart"
