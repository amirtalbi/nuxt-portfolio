#!/bin/bash

echo "🎯 Ajout d'un nouveau projet au portfolio"
echo "========================================"

# Demander les informations du projet
read -p "📝 Nom du projet (ex: auth-api): " PROJECT_NAME
read -p "🌐 Sous-domaine (ex: auth-api): " SUBDOMAIN
read -p "🐳 Image Docker (ex: ghcr.io/username/auth-api:latest): " DOCKER_IMAGE
read -p "🔌 Port interne (ex: 3000): " INTERNAL_PORT

if [ -z "$PROJECT_NAME" ] || [ -z "$SUBDOMAIN" ] || [ -z "$DOCKER_IMAGE" ] || [ -z "$INTERNAL_PORT" ]; then
    echo "❌ Tous les champs sont requis"
    exit 1
fi

# Générer la configuration Docker Compose
PROJECT_CONFIG="
  # Projet: $PROJECT_NAME
  $PROJECT_NAME:
    image: $DOCKER_IMAGE
    container_name: portfolio-$PROJECT_NAME
    networks:
      - traefik-network
    labels:
      # Configuration Traefik pour $PROJECT_NAME
      - \"traefik.enable=true\"
      - \"traefik.docker.network=traefik-network\"
      
      # Router pour $PROJECT_NAME
      - \"traefik.http.routers.$PROJECT_NAME.rule=Host(\\\`$SUBDOMAIN.\${DOMAIN:-localhost}\\\`)\"
      - \"traefik.http.routers.$PROJECT_NAME.entrypoints=websecure\"
      - \"traefik.http.routers.$PROJECT_NAME.tls.certresolver=letsencrypt\"
      - \"traefik.http.routers.$PROJECT_NAME.service=$PROJECT_NAME\"
      - \"traefik.http.services.$PROJECT_NAME.loadbalancer.server.port=$INTERNAL_PORT\"
    restart: unless-stopped
"

echo "📁 Configuration générée pour $PROJECT_NAME:"
echo "$PROJECT_CONFIG"
echo ""
echo "📋 Étapes pour ajouter ce projet :"
echo ""
echo "1. 🐳 Ajoutez cette configuration à docker-compose.registry.yml:"
echo "$PROJECT_CONFIG"
echo ""
echo "2. 🌐 Ajoutez le sous-domaine DNS:"
echo "   Type: A"
echo "   Nom: $SUBDOMAIN"
echo "   Valeur: IP_DE_VOTRE_VPS"
echo ""
echo "3. 🚀 Redéployez:"
echo "   ./scripts/deploy-registry.sh votre-domaine.com"
echo ""
echo "4. 🎉 Votre projet sera accessible sur:"
echo "   https://$SUBDOMAIN.votre-domaine.com"

# Proposer d'ajouter automatiquement
read -p "🤖 Voulez-vous que j'ajoute automatiquement cette configuration ? (y/N): " AUTO_ADD

if [ "$AUTO_ADD" = "y" ] || [ "$AUTO_ADD" = "Y" ]; then
    # Backup du fichier original
    cp docker-compose.registry.yml docker-compose.registry.yml.backup
    
    # Ajouter la configuration avant la section networks
    sed -i.tmp "/^networks:/i\\
$PROJECT_CONFIG
" docker-compose.registry.yml
    
    rm docker-compose.registry.yml.tmp
    
    echo "✅ Configuration ajoutée à docker-compose.registry.yml"
    echo "💾 Backup sauvé: docker-compose.registry.yml.backup"
    echo ""
    echo "🚀 Redéployez maintenant avec:"
    echo "   ./scripts/deploy-registry.sh votre-domaine.com"
fi
