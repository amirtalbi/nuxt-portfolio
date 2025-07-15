#!/bin/bash

echo "🚀 Configuration du portfolio avec Docker"
echo "========================================"

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Génération des certificats SSL
echo ""
echo "🔒 Génération des certificats SSL..."
./scripts/generate-ssl.sh

# Configuration des variables d'environnement
echo ""
echo "⚙️  Configuration des variables d'environnement..."

# Frontend
if [ ! -f .env ]; then
    echo "📄 Création du fichier .env pour le frontend..."
    cp .env.example .env
    echo "✅ Fichier .env créé. Vous pouvez le modifier si nécessaire."
else
    echo "✅ Fichier .env déjà existant."
fi

# Backend
if [ ! -f backend/.env ]; then
    echo "📄 Création du fichier backend/.env..."
    cp backend/.env.example backend/.env
    echo ""
    echo "⚠️  IMPORTANT: Configurez vos paramètres email dans backend/.env"
    echo "   - EMAIL_USER: votre adresse email"
    echo "   - EMAIL_PASS: votre mot de passe d'application"
    echo "   - OWNER_EMAIL: l'email qui recevra les messages"
    echo ""
    echo "📖 Pour Gmail:"
    echo "   1. Activez l'authentification à deux facteurs"
    echo "   2. Générez un 'App Password' dans les paramètres de sécurité"
    echo "   3. Utilisez ce mot de passe dans EMAIL_PASS"
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
else
    echo "✅ Fichier backend/.env déjà existant."
fi

# Build et démarrage des services
echo ""
echo "🏗️  Construction et démarrage des services Docker..."
echo ""

# Utiliser docker compose ou docker-compose selon la version
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Arrêter les services existants
echo "🛑 Arrêt des services existants..."
$DOCKER_COMPOSE down

# Construire et démarrer les services
echo "🚀 Démarrage des services..."
$DOCKER_COMPOSE up --build -d

# Attendre que les services soient prêts
echo ""
echo "⏳ Attente du démarrage des services..."
sleep 10

# Vérifier le statut des services
echo ""
echo "📊 Statut des services:"
$DOCKER_COMPOSE ps

# Test de connectivité
echo ""
echo "🔍 Test de connectivité..."

echo -n "Backend API: "
if curl -s http://localhost:3001/api/health > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

echo -n "Frontend: "
if curl -s -k https://localhost > /dev/null; then
    echo "✅ OK"
else
    echo "❌ Non accessible"
fi

echo ""
echo "🎉 Configuration terminée !"
echo ""
echo "📱 Accès aux services:"
echo "   🔒 Frontend (HTTPS): https://localhost:443"
echo "   🔄 Frontend (HTTP): http://localhost:80 (redirige vers HTTPS)"
echo "   🔧 API Backend: http://localhost:3001 (accès direct pour debug)"
echo ""
echo "🌐 URL principale: https://localhost"
echo ""
echo "🔧 Commandes utiles:"
echo "   📊 Voir les logs: $DOCKER_COMPOSE logs -f"
echo "   🛑 Arrêter: $DOCKER_COMPOSE down"
echo "   🔄 Redémarrer: $DOCKER_COMPOSE restart"
echo "   🏗️  Reconstruire: $DOCKER_COMPOSE up --build -d"
echo ""
echo "⚠️  IMPORTANT: N'oubliez pas de configurer vos paramètres email dans backend/.env"
echo "   📧 EMAIL_USER=votre-email@gmail.com"
echo "   🔐 EMAIL_PASS=votre-app-password-gmail"
echo "   📬 OWNER_EMAIL=votre-email-de-reception@gmail.com"
echo ""
echo "🔒 Certificats SSL:"
echo "   ✅ Certificats auto-signés générés pour le développement"
echo "   ⚠️  Votre navigateur affichera un avertissement de sécurité"
echo "   💡 Cliquez sur 'Avancé' puis 'Continuer vers localhost' pour accéder au site"
