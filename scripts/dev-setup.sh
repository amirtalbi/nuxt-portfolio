#!/bin/bash

echo "🚀 Démarrage en mode développement"
echo "=================================="

# Vérifier si Node.js est installé
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Configuration des variables d'environnement
if [ ! -f .env ]; then
    echo "📄 Création du fichier .env..."
    cp .env.example .env
fi

if [ ! -f backend/.env ]; then
    echo "📄 Création du fichier backend/.env..."
    cp backend/.env.example backend/.env
    echo ""
    echo "⚠️  IMPORTANT: Configurez vos paramètres email dans backend/.env"
    echo "   📧 EMAIL_USER=votre-email@gmail.com"
    echo "   🔐 EMAIL_PASS=votre-app-password-gmail (pas votre mot de passe principal !)"
    echo "   📬 OWNER_EMAIL=votre-email-de-reception@gmail.com"
    echo ""
    echo "💡 Pour Gmail:"
    echo "   1. Activez l'authentification à deux facteurs"
    echo "   2. Allez dans Paramètres > Sécurité > Mots de passe d'application"
    echo "   3. Générez un 'App Password' pour cette application"
    echo "   4. Utilisez ce mot de passe dans EMAIL_PASS"
    echo ""
    read -p "Appuyez sur Entrée pour continuer..."
fi

# Installation des dépendances du frontend
echo "📦 Installation des dépendances du frontend..."
npm install

# Installation des dépendances du backend
echo "📦 Installation des dépendances du backend..."
cd backend
npm install
cd ..

echo ""
echo "🎉 Configuration terminée !"
echo ""
echo "🚀 Pour démarrer en mode développement:"
echo ""
echo "Terminal 1 - Backend:"
echo "  cd backend && npm run dev"
echo ""
echo "Terminal 2 - Frontend:"
echo "  npm run dev"
echo ""
echo "📱 Accès en développement:"
echo "   🌐 Frontend: http://localhost:3000"
echo "   🔧 Backend API: http://localhost:3001"
echo "   🩺 Health check: http://localhost:3001/api/health"
echo ""
echo "🐳 Pour utiliser Docker (production-like):"
echo "   ./scripts/setup.sh"
echo ""
echo "⚠️  N'oubliez pas de configurer backend/.env avec vos paramètres email !"
