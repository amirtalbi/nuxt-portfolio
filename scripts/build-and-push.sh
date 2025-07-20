#!/bin/bash

echo "🚀 Build et Push des images Docker vers GitHub Registry"
echo "====================================================="

# Variables
REGISTRY="ghcr.io"
REPO="amirtalbi/nuxt-portfolio"
FRONTEND_TAG="frontend-latest"
BACKEND_TAG="backend-latest"

# Vérifier que l'utilisateur est connecté à GitHub
echo "🔐 Vérification de l'authentification GitHub..."
if ! docker info | grep -q "Username"; then
    echo "⚠️  Connectez-vous à GitHub Registry:"
    echo "   echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u amirtalbi --password-stdin"
    read -p "Appuyez sur Entrée après vous être connecté..."
fi

# Build du frontend
echo "🏗️  Build du frontend..."
docker build -t ${REGISTRY}/${REPO}:${FRONTEND_TAG} .

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du build du frontend"
    exit 1
fi

# Build du backend
echo "🏗️  Build du backend..."
docker build -t ${REGISTRY}/${REPO}:${BACKEND_TAG} ./backend

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors du build du backend"
    exit 1
fi

# Push des images
echo "📤 Push du frontend..."
docker push ${REGISTRY}/${REPO}:${FRONTEND_TAG}

echo "📤 Push du backend..."
docker push ${REGISTRY}/${REPO}:${BACKEND_TAG}

echo ""
echo "✅ Images construites et publiées avec succès !"
echo ""
echo "🏷️  Images disponibles :"
echo "   Frontend: ${REGISTRY}/${REPO}:${FRONTEND_TAG}"
echo "   Backend:  ${REGISTRY}/${REPO}:${BACKEND_TAG}"
echo ""
echo "🚀 Pour déployer, utilisez:"
echo "   docker compose -f docker-compose.registry.yml up -d"
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
