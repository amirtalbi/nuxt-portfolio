#!/bin/bash

# Script de build robuste pour Netlify
set -e

echo "🚀 Début du build Netlify"

# Vérifier les versions
echo "📦 Node version: $(node --version)"
echo "📦 NPM version: $(npm --version)"

# Nettoyer le cache si nécessaire
echo "🧹 Nettoyage du cache..."
npm cache clean --force 2>/dev/null || true

# Installation des dépendances
echo "📥 Installation des dépendances..."
npm ci --prefer-offline --no-audit

# Build du projet
echo "🏗️ Build du projet..."
npm run build

# Vérification du build
echo "✅ Vérification du dossier de sortie..."
if [ -d ".output/public" ]; then
    echo "✅ Build réussi ! Dossier .output/public créé."
    ls -la .output/public/
else
    echo "❌ Erreur : Dossier .output/public non trouvé."
    echo "Contenu du dossier .output:"
    ls -la .output/ 2>/dev/null || echo "Dossier .output n'existe pas"
    exit 1
fi

echo "🎉 Build terminé avec succès !"
