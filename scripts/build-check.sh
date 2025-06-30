#!/bin/bash
echo "🔍 Diagnostic du build Netlify"
echo "================================"

echo "📦 Version Node:"
node --version

echo "📦 Version NPM:"
npm --version

echo "📁 Contenu du répertoire:"
ls -la

echo "🔧 Installation des dépendances:"
npm ci

echo "🏗️ Génération du site:"
npm run generate

echo "📁 Vérification du dossier de sortie:"
if [ -d ".output/public" ]; then
    echo "✅ Dossier .output/public existe"
    echo "📋 Contenu:"
    ls -la .output/public
else
    echo "❌ Dossier .output/public n'existe pas"
    echo "📋 Contenu du dossier .output:"
    ls -la .output 2>/dev/null || echo "Le dossier .output n'existe pas"
fi

echo "🎉 Diagnostic terminé"
