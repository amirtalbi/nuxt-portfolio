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
echo "🏗️ Génération statique du projet..."
npm run generate

# Vérification du build
echo "✅ Vérification du dossier de sortie..."
if [ -d "dist" ]; then
    echo "✅ Build réussi ! Dossier dist créé."
    ls -la dist/
else
    echo "❌ Erreur : Dossier dist non trouvé."
    echo "Contenu du répertoire actuel:"
    ls -la .
    exit 1
fi

echo "🎉 Build terminé avec succès !"
