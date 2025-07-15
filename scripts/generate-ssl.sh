#!/bin/bash

# Script pour générer des certificats SSL auto-signés pour le développement local

# Créer le répertoire SSL s'il n'existe pas
mkdir -p nginx/ssl

# Générer la clé privée
openssl genrsa -out nginx/ssl/key.pem 2048

# Générer le certificat auto-signé
openssl req -new -x509 -key nginx/ssl/key.pem -out nginx/ssl/cert.pem -days 365 -subj "/C=FR/ST=Paris/L=Paris/O=Portfolio/OU=Development/CN=localhost"

echo "✅ Certificats SSL générés avec succès !"
echo "📁 Certificats créés dans nginx/ssl/"
echo "🔒 Le certificat est valide pour 365 jours"
echo ""
echo "⚠️  ATTENTION: Ces certificats sont auto-signés et ne doivent être utilisés qu'en développement !"
echo "    Votre navigateur affichera un avertissement de sécurité que vous devrez accepter."
