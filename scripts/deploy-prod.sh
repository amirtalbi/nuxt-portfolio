#!/bin/bash

echo "🚀 Déploiement en production sur VPS"
echo "==================================="

# Vérifier si nous sommes sur un serveur
if [ -z "$SSH_CONNECTION" ] && [ -z "$SSH_CLIENT" ]; then
    echo "⚠️  Ce script est conçu pour être exécuté sur un VPS"
    echo "💡 Pour le développement local, utilisez ./scripts/setup.sh"
    read -p "Continuer quand même ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Variables à configurer
read -p "🌐 Entrez votre nom de domaine (ex: monsite.nc.me): " DOMAIN
read -p "📧 Entrez votre email pour Let's Encrypt: " EMAIL

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "❌ Le domaine et l'email sont requis"
    exit 1
fi

echo ""
echo "📝 Configuration avec:"
echo "   Domaine: $DOMAIN"
echo "   Email: $EMAIL"
echo ""

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Installation..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installé. Redémarrez votre session puis relancez ce script."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Installation..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Configurer le domaine dans les fichiers
echo "⚙️  Configuration du domaine..."

# Remplacer dans nginx.prod.conf
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" nginx/nginx.prod.conf

# Remplacer dans docker-compose.prod.yml
sed -i "s/votre-email@gmail.com/$EMAIL/g" docker-compose.prod.yml
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" docker-compose.prod.yml

# Configurer le backend
if [ ! -f backend/.env.production ]; then
    echo "📄 Création du fichier backend/.env.production..."
    cp backend/.env.production.example backend/.env.production
fi

# Remplacer l'URL du frontend
sed -i "s/votre-domaine.nc.me/$DOMAIN/g" backend/.env.production

echo ""
echo "⚠️  IMPORTANT: Configurez vos paramètres email dans backend/.env.production"
echo "   📧 EMAIL_USER=votre-email@gmail.com"
echo "   🔐 EMAIL_PASS=votre-app-password-gmail"
echo "   📬 OWNER_EMAIL=votre-email-de-reception@gmail.com"
echo ""
read -p "Appuyez sur Entrée après avoir configuré backend/.env.production..."

# Utiliser docker compose ou docker-compose selon la version
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Arrêter les services existants
echo "🛑 Arrêt des services existants..."
$DOCKER_COMPOSE -f docker-compose.prod.yml down

# Construire et démarrer les services
echo "🏗️  Construction et démarrage des services..."
$DOCKER_COMPOSE -f docker-compose.prod.yml up --build -d

# Attendre que les services soient prêts
echo ""
echo "⏳ Attente du démarrage des services..."
sleep 15

# Générer les certificats SSL Let's Encrypt
echo "🔒 Génération des certificats SSL Let's Encrypt..."
$DOCKER_COMPOSE -f docker-compose.prod.yml run --rm certbot

# Redémarrer nginx pour charger les nouveaux certificats
echo "🔄 Redémarrage de nginx avec les certificats SSL..."
$DOCKER_COMPOSE -f docker-compose.prod.yml restart nginx

# Vérifier le statut des services
echo ""
echo "📊 Statut des services:"
$DOCKER_COMPOSE -f docker-compose.prod.yml ps

# Test de connectivité
echo ""
echo "🔍 Test de connectivité..."

echo -n "Backend API: "
if curl -s http://localhost:3001/api/health > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

echo -n "Frontend HTTP: "
if curl -s http://localhost > /dev/null; then
    echo "✅ OK (redirige vers HTTPS)"
else
    echo "❌ Non accessible"
fi

echo -n "Frontend HTTPS: "
if curl -s -k https://localhost > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

# Configuration du renouvellement automatique des certificats
echo ""
echo "🔄 Configuration du renouvellement automatique des certificats..."
(crontab -l 2>/dev/null; echo "0 12 * * * $DOCKER_COMPOSE -f $(pwd)/docker-compose.prod.yml run --rm certbot renew && $DOCKER_COMPOSE -f $(pwd)/docker-compose.prod.yml restart nginx") | crontab -

echo ""
echo "🎉 Déploiement terminé !"
echo ""
echo "🌐 Votre site est accessible sur:"
echo "   https://$DOMAIN"
echo "   https://www.$DOMAIN"
echo ""
echo "🔧 Commandes utiles:"
echo "   📊 Voir les logs: $DOCKER_COMPOSE -f docker-compose.prod.yml logs -f"
echo "   🛑 Arrêter: $DOCKER_COMPOSE -f docker-compose.prod.yml down"
echo "   🔄 Redémarrer: $DOCKER_COMPOSE -f docker-compose.prod.yml restart"
echo "   🏗️  Reconstruire: $DOCKER_COMPOSE -f docker-compose.prod.yml up --build -d"
echo ""
echo "🔒 Certificats SSL:"
echo "   ✅ Certificats Let's Encrypt configurés"
echo "   🔄 Renouvellement automatique configuré (cron)"
echo ""
echo "⚠️  Points importants:"
echo "   📧 Vérifiez la configuration email dans backend/.env.production"
echo "   🔥 Configurez votre firewall (ports 80, 443, 22)"
echo "   🔒 Désactivez l'authentification par mot de passe SSH"
echo "   📊 Surveillez les logs: $DOCKER_COMPOSE -f docker-compose.prod.yml logs -f"
