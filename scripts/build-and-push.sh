#!/bin/bash

echo "🏗️  Build et push des images vers GitHub Container Registry"
echo "=========================================================="

# Variables
REGISTRY="ghcr.io"
USERNAME="amirtalbi"
REPO_NAME="nuxt-portfolio"
VERSION="${1:-latest}"

# Vérifier que l'utilisateur est connecté à GitHub
if ! docker info | grep -q "Username"; then
    echo "📝 Connexion à GitHub Container Registry..."
    echo "Utilisez votre Personal Access Token comme mot de passe"
    docker login ghcr.io -u $USERNAME
fi

echo "🏗️  Construction de l'image Frontend..."
docker build -t $REGISTRY/$USERNAME/$REPO_NAME-frontend:$VERSION \
             -t $REGISTRY/$USERNAME/$REPO_NAME-frontend:latest \
             -f Dockerfile .

echo "🏗️  Construction de l'image Backend..."
docker build -t $REGISTRY/$USERNAME/$REPO_NAME-backend:$VERSION \
             -t $REGISTRY/$USERNAME/$REPO_NAME-backend:latest \
             -f backend/Dockerfile ./backend

echo "📤 Push de l'image Frontend..."
docker push $REGISTRY/$USERNAME/$REPO_NAME-frontend:$VERSION
docker push $REGISTRY/$USERNAME/$REPO_NAME-frontend:latest

echo "📤 Push de l'image Backend..."
docker push $REGISTRY/$USERNAME/$REPO_NAME-backend:$VERSION
docker push $REGISTRY/$USERNAME/$REPO_NAME-backend:latest

echo ""
echo "✅ Images publiées avec succès !"
echo ""
echo "🐳 Images disponibles :"
echo "   Frontend: $REGISTRY/$USERNAME/$REPO_NAME-frontend:latest"
echo "   Backend:  $REGISTRY/$USERNAME/$REPO_NAME-backend:latest"
echo ""
echo "🚀 Pour déployer, utilisez :"
echo "   ./scripts/deploy-registry.sh"
