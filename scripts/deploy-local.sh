#!/bin/bash

echo "🚀 Déploiement complet de l'application Portfolio"
echo "================================================"

# Vérifier qu'on est dans le bon répertoire
if [ ! -f "docker-compose.traefik.yml" ]; then
    echo "❌ Fichier docker-compose.traefik.yml introuvable"
    echo "   Assurez-vous d'être dans le répertoire du projet"
    exit 1
fi

# Arrêter tous les conteneurs et nettoyer
echo "🛑 Arrêt des services et nettoyage..."
docker compose -f docker-compose.traefik.yml down --remove-orphans
docker system prune -f

# Supprimer les images existantes pour forcer le rebuild
echo "🗑️  Suppression des images existantes..."
docker images | grep portfolio | awk '{print $3}' | xargs -r docker rmi -f

# S'assurer que les fichiers package-lock.json existent
echo "📦 Vérification des dépendances..."
if [ ! -f "package-lock.json" ]; then
    echo "   Génération du package-lock.json frontend..."
    npm install --package-lock-only
fi

if [ ! -f "backend/package-lock.json" ]; then
    echo "   Génération du package-lock.json backend..."
    cd backend && npm install --package-lock-only && cd ..
fi

# Créer le réseau Traefik s'il n'existe pas
echo "🌐 Création du réseau Traefik..."
docker network create traefik 2>/dev/null || true

# Build depuis zéro
echo "🏗️  Construction des images Docker..."
docker compose -f docker-compose.traefik.yml build --no-cache --progress=plain

# Vérifier que le build a réussi
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du build Docker"
    exit 1
fi

# Démarrer les services
echo "🚀 Démarrage des services..."
docker compose -f docker-compose.traefik.yml up -d

# Attendre que les services démarrent
echo "⏳ Attente du démarrage des services..."
sleep 15

# Afficher le statut
echo "📊 Statut des services:"
docker compose -f docker-compose.traefik.yml ps

echo ""
echo "🎉 Déploiement terminé !"
echo ""
echo "🌐 Vos services devraient être accessibles sur :"
echo "   📱 Portfolio: http://localhost (ou votre domaine configuré)"
echo "   🔧 Traefik Dashboard: http://localhost:8080"
echo ""
echo "📋 Commandes utiles :"
echo "   📊 Voir les logs: docker compose -f docker-compose.traefik.yml logs -f"
echo "   🛑 Arrêter: docker compose -f docker-compose.traefik.yml down"
echo "   🔄 Redémarrer: docker compose -f docker-compose.traefik.yml restart"
echo ""
echo "🐛 En cas de problème :"
echo "   📋 Logs détaillés: docker compose -f docker-compose.traefik.yml logs"
echo "   🔍 Statut des conteneurs: docker ps -a"
