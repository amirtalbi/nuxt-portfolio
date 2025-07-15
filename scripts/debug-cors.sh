#!/bin/bash

echo "🔍 Diagnostic CORS - Portfolio"
echo "=============================="

# Vérifier si le backend est en cours d'exécution
echo "1. Vérification du backend..."
if curl -s http://localhost:3001/api/health > /dev/null; then
    echo "✅ Backend accessible sur http://localhost:3001"
else
    echo "❌ Backend non accessible sur http://localhost:3001"
    echo "   Démarrez le backend avec: cd backend && npm run dev"
    exit 1
fi

# Test du endpoint health
echo ""
echo "2. Test du endpoint health..."
HEALTH_RESPONSE=$(curl -s http://localhost:3001/api/health)
echo "Réponse: $HEALTH_RESPONSE"

# Test CORS avec curl
echo ""
echo "3. Test CORS depuis localhost:3000..."
CORS_TEST=$(curl -s -H "Origin: http://localhost:3000" \
                  -H "Access-Control-Request-Method: POST" \
                  -H "Access-Control-Request-Headers: Content-Type" \
                  -X OPTIONS \
                  http://localhost:3001/api/contact \
                  -v 2>&1)

if echo "$CORS_TEST" | grep -q "Access-Control-Allow-Origin"; then
    echo "✅ CORS configuré correctement"
else
    echo "❌ Problème CORS détecté"
    echo "Réponse complète:"
    echo "$CORS_TEST"
fi

# Vérifier la configuration
echo ""
echo "4. Configuration actuelle..."
echo "Backend .env FRONTEND_URL:"
if [ -f "backend/.env" ]; then
    grep "FRONTEND_URL" backend/.env
else
    echo "❌ Fichier backend/.env non trouvé"
fi

echo ""
echo "Frontend .env API_URL:"
if [ -f ".env" ]; then
    grep "API_URL" .env
else
    echo "❌ Fichier .env non trouvé"
fi

echo ""
echo "🎯 Solutions possibles:"
echo "1. Redémarrer le backend: cd backend && npm run dev"
echo "2. Vérifier que FRONTEND_URL=http://localhost:3000 dans backend/.env"
echo "3. Vérifier que API_URL=http://localhost:3001 dans .env"
echo "4. Vider le cache du navigateur (Cmd+Shift+R sur Mac)"
