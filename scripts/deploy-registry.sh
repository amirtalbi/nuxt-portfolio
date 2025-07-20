#!/bin/bash

echo "🚀 Déploiement avec images du GitHub Container Registry"
echo "====================================================="

# Variables par défaut
DOMAIN="${1:-localhost}"
EMAIL="${2:-webinnov.paris@gmail.com}"

if [ "$DOMAIN" = "localhost" ]; then
    echo "💻 Déploiement en mode développement local"
    COMPOSE_FILE="docker-compose.registry.yml"
else
    echo "🌐 Déploiement en production pour: $DOMAIN"
    COMPOSE_FILE="docker-compose.registry.yml"
fi

# Vérifier que les variables d'environnement sont configurées
if [ ! -f ".env.registry" ]; then
    echo "📝 Création du fichier .env.registry..."
    cat > .env.registry << EOF
# Configuration pour le déploiement avec registre
DOMAIN=$DOMAIN
ACME_EMAIL=$EMAIL

# Configuration Email (à modifier avec vos valeurs)
EMAIL_SERVICE=gmail
EMAIL_USER=webinnov.paris@gmail.com
EMAIL_PASS=pyvv sudp eloy ysso
OWNER_EMAIL=webinnov.paris@gmail.com
EOF
    echo "⚠️  Modifiez .env.registry avec vos vraies valeurs email !"
fi

# Créer le réseau Traefik s'il n'existe pas
echo "🌐 Création du réseau Traefik..."
docker network create traefik-network 2>/dev/null || true

# Arrêter les services existants
echo "🛑 Arrêt des services existants..."
docker compose -f $COMPOSE_FILE down 2>/dev/null || true

# Pull des dernières images
echo "📥 Téléchargement des dernières images..."
docker compose -f $COMPOSE_FILE --env-file .env.registry pull

# Démarrer les services
echo "🚀 Démarrage des services..."
docker compose -f $COMPOSE_FILE --env-file .env.registry up -d

# Attendre que les services démarrent
echo "⏳ Attente du démarrage des services..."
sleep 15

# Afficher le statut
echo "📊 Statut des services:"
docker compose -f $COMPOSE_FILE ps

echo ""
echo "🎉 Déploiement terminé !"
echo ""
if [ "$DOMAIN" = "localhost" ]; then
    echo "🌐 Vos services sont accessibles sur :"
    echo "   📱 Portfolio: http://localhost"
    echo "   🔧 Traefik Dashboard: http://localhost:8080"
else
    echo "🌐 Vos services sont accessibles sur :"
    echo "   📱 Portfolio: https://$DOMAIN"
    echo "   🔧 Traefik Dashboard: https://traefik.$DOMAIN"
fi
echo ""
echo "📋 Commandes utiles :"
echo "   📊 Voir les logs: docker compose -f $COMPOSE_FILE logs -f"
echo "   🛑 Arrêter: docker compose -f $COMPOSE_FILE down"
echo "   🔄 Redémarrer: docker compose -f $COMPOSE_FILE restart"
echo "   📥 Mettre à jour: docker compose -f $COMPOSE_FILE pull && docker compose -f $COMPOSE_FILE up -d"
