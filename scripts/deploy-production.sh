#!/bin/bash

echo "🚀 Déploiement en production sur VPS"
echo "===================================="

# Variables à configurer
DOMAIN="votre-domaine.nc.me"
EMAIL="votre-email@gmail.com"

echo "📋 Configuration requise:"
echo "  - Domaine: $DOMAIN"
echo "  - Email: $EMAIL"
echo ""

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Installation..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installé. Redémarrez votre session SSH."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Installation..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Utiliser docker compose ou docker-compose selon la version
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Vérifier la configuration
echo "🔍 Vérification de la configuration..."

if [ ! -f "backend/.env" ]; then
    echo "❌ Fichier backend/.env manquant !"
    echo "📄 Créez le fichier avec vos paramètres email"
    exit 1
fi

# Remplacer le domaine dans les fichiers de configuration
echo "🔧 Configuration du domaine: $DOMAIN"

# Nginx
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" nginx/nginx.production.conf

# Docker Compose
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" docker-compose.production.yml
sed -i "s/votre-email@gmail.com/$EMAIL/g" docker-compose.production.yml

# Backend
sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=https://$DOMAIN|g" backend/.env

echo "✅ Configuration mise à jour"

# Créer les répertoires pour certbot
echo "📁 Création des répertoires..."
mkdir -p certbot/conf
mkdir -p certbot/www

# Arrêter les services existants
echo "🛑 Arrêt des services existants..."
$DOCKER_COMPOSE -f docker-compose.production.yml down

# Première étape : démarrer nginx sans SSL pour obtenir les certificats
echo "🔓 Démarrage temporaire pour Let's Encrypt..."

# Configuration nginx temporaire pour l'obtention des certificats
cat > nginx/nginx.temp.conf << EOF
events {
    worker_connections 1024;
}
http {
    server {
        listen 80;
        server_name $DOMAIN;
        
        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        
        location / {
            return 200 'Hello World!';
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Modifier temporairement docker-compose pour utiliser la config temporaire
cp docker-compose.production.yml docker-compose.temp.yml
sed -i 's|nginx.production.conf|nginx.temp.conf|g' docker-compose.temp.yml

# Démarrer nginx temporaire
echo "🚀 Démarrage nginx temporaire..."
$DOCKER_COMPOSE -f docker-compose.temp.yml up -d nginx

# Attendre que nginx démarre
sleep 5

# Obtenir les certificats SSL
echo "🔒 Obtention des certificats SSL..."
$DOCKER_COMPOSE -f docker-compose.temp.yml run --rm certbot

# Vérifier si les certificats ont été créés
if [ -f "certbot/conf/live/$DOMAIN/fullchain.pem" ]; then
    echo "✅ Certificats SSL obtenus avec succès !"
    
    # Arrêter nginx temporaire
    $DOCKER_COMPOSE -f docker-compose.temp.yml down
    
    # Nettoyer les fichiers temporaires
    rm nginx/nginx.temp.conf docker-compose.temp.yml
    
    # Démarrer la configuration complète
    echo "🚀 Démarrage de la configuration complète..."
    $DOCKER_COMPOSE -f docker-compose.production.yml up --build -d
    
    # Attendre que les services démarrent
    echo "⏳ Attente du démarrage des services..."
    sleep 15
    
    # Test de connectivité
    echo "🔍 Test de connectivité..."
    if curl -s -k https://$DOMAIN > /dev/null; then
        echo "✅ Site accessible sur https://$DOMAIN"
    else
        echo "❌ Site non accessible. Vérifiez les logs:"
        echo "   $DOCKER_COMPOSE -f docker-compose.production.yml logs"
    fi
    
else
    echo "❌ Échec de l'obtention des certificats SSL"
    echo "📋 Vérifiez que:"
    echo "   - Le domaine $DOMAIN pointe vers cette IP"
    echo "   - Les ports 80 et 443 sont ouverts"
    echo "   - Aucun autre service n'utilise ces ports"
    exit 1
fi

echo ""
echo "🎉 Déploiement terminé !"
echo ""
echo "📱 Votre site est maintenant accessible sur:"
echo "   🌐 https://$DOMAIN"
echo ""
echo "🔧 Commandes utiles:"
echo "   📊 Voir les logs: $DOCKER_COMPOSE -f docker-compose.production.yml logs -f"
echo "   🛑 Arrêter: $DOCKER_COMPOSE -f docker-compose.production.yml down"
echo "   🔄 Redémarrer: $DOCKER_COMPOSE -f docker-compose.production.yml restart"
echo "   🔒 Renouveler SSL: $DOCKER_COMPOSE -f docker-compose.production.yml run --rm certbot renew"
echo ""
echo "⚠️  Ajoutez cette tâche cron pour le renouvellement automatique SSL:"
echo "   0 12 * * * $DOCKER_COMPOSE -f $(pwd)/docker-compose.production.yml run --rm certbot renew --quiet"
