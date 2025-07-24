#!/bin/bash

# Script pour reconstruire et redéployer l'application avec les assets

echo "🔨 Reconstruction de l'image Docker avec les assets..."

# Arrêter les conteneurs existants
docker-compose down

# Reconstruire l'image frontend
docker build -t ghcr.io/amirtalbi/front-portfolio:latest .

# Optionnel : pousser vers le registry
# docker push ghcr.io/amirtalbi/front-portfolio:latest

# Redémarrer les services
docker-compose up -d

echo "✅ Redéploiement terminé!"
echo "🌐 Vérifiez que vos assets sont disponibles à:"
echo "   - https://votre-domaine.com/amir-talbi-cv.pdf"
echo "   - https://votre-domaine.com/assets/webinnov.png"
echo "   - https://votre-domaine.com/assets/go-memories.png"
