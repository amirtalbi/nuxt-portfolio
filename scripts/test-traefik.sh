#!/bin/bash

# Script de test pour la configuration Traefik
echo "🧪 Test de la configuration Traefik..."

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✅ PASS]${NC} $1"
}

print_fail() {
    echo -e "${RED}[❌ FAIL]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️  WARN]${NC} $1"
}

# Lecture de la configuration
if [ ! -f .env.traefik ]; then
    print_fail "Fichier .env.traefik non trouvé"
    exit 1
fi

DOMAIN=$(grep "^DOMAIN=" .env.traefik | cut -d'=' -f2)
if [ -z "$DOMAIN" ] || [ "$DOMAIN" = "votre-domaine.nc.me" ]; then
    print_warning "Domaine non configuré dans .env.traefik"
    DOMAIN="localhost"
fi

# Test 1: Vérification des containers
print_test "Vérification des containers Docker..."
if docker-compose -f docker-compose.traefik.yml ps | grep -q "Up"; then
    print_success "Containers en cours d'exécution"
else
    print_fail "Aucun container n'est démarré"
    echo "Démarrez les services avec: docker-compose -f docker-compose.traefik.yml up -d"
    exit 1
fi

# Test 2: Vérification du réseau Traefik
print_test "Vérification du réseau Traefik..."
if docker network ls | grep -q "traefik-network"; then
    print_success "Réseau traefik-network existe"
else
    print_fail "Réseau traefik-network manquant"
    echo "Créez le réseau avec: docker network create traefik-network"
fi

# Test 3: Test de connectivité locale
print_test "Test de connectivité locale..."

# Test Traefik
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/rawdata | grep -q "200"; then
    print_success "Dashboard Traefik accessible (localhost:8080)"
else
    print_warning "Dashboard Traefik non accessible sur localhost:8080"
fi

# Test Frontend (via Traefik)
if curl -s -o /dev/null -w "%{http_code}" -H "Host: $DOMAIN" http://localhost | grep -q "200\|301\|302"; then
    print_success "Frontend accessible via Traefik"
else
    print_fail "Frontend non accessible via Traefik"
fi

# Test API (via Traefik)
if curl -s -o /dev/null -w "%{http_code}" -H "Host: api.$DOMAIN" http://localhost/api/health | grep -q "200"; then
    print_success "API accessible via Traefik"
else
    print_fail "API non accessible via Traefik"
fi

# Test 4: Vérification des certificats SSL (si domaine réel)
if [ "$DOMAIN" != "localhost" ]; then
    print_test "Vérification des certificats SSL..."
    
    if curl -s -k "https://$DOMAIN" | grep -q "html\|DOCTYPE"; then
        print_success "Site principal HTTPS accessible"
    else
        print_warning "Site principal HTTPS non accessible (certificat en cours de génération?)"
    fi
    
    # Test de la résolution DNS
    if nslookup "$DOMAIN" > /dev/null 2>&1; then
        print_success "DNS résolu pour $DOMAIN"
    else
        print_fail "DNS non résolu pour $DOMAIN"
        echo "Vérifiez votre configuration DNS chez nc.me"
    fi
fi

# Test 5: Vérification des projets d'exemple
print_test "Vérification des projets d'exemple..."

if [ -f "projects/project1/index.html" ]; then
    print_success "Projet 1 (statique) configuré"
    if curl -s -o /dev/null -w "%{http_code}" -H "Host: project1.$DOMAIN" http://localhost | grep -q "200\|301\|302"; then
        print_success "Projet 1 accessible via Traefik"
    else
        print_fail "Projet 1 non accessible via Traefik"
    fi
else
    print_warning "Projet 1 non configuré"
fi

if [ -f "projects/project2/server.js" ]; then
    print_success "Projet 2 (Node.js) configuré"
    if curl -s -o /dev/null -w "%{http_code}" -H "Host: project2.$DOMAIN" http://localhost | grep -q "200\|301\|302"; then
        print_success "Projet 2 accessible via Traefik"
    else
        print_fail "Projet 2 non accessible via Traefik"
    fi
else
    print_warning "Projet 2 non configuré"
fi

# Test 6: Vérification des logs
print_test "Vérification des logs d'erreur..."
ERROR_COUNT=$(docker-compose -f docker-compose.traefik.yml logs --tail=100 2>&1 | grep -i "error\|failed\|exception" | wc -l)
if [ "$ERROR_COUNT" -eq 0 ]; then
    print_success "Aucune erreur critique dans les logs"
else
    print_warning "$ERROR_COUNT erreurs trouvées dans les logs récents"
    echo "Consultez les logs avec: docker-compose -f docker-compose.traefik.yml logs"
fi

# Test 7: Test de performance
print_test "Test de performance basique..."
RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" -H "Host: $DOMAIN" http://localhost)
if (( $(echo "$RESPONSE_TIME < 2.0" | bc -l) )); then
    print_success "Temps de réponse acceptable (${RESPONSE_TIME}s)"
else
    print_warning "Temps de réponse élevé (${RESPONSE_TIME}s)"
fi

echo
echo "📋 Résumé des URLs disponibles:"
echo "   Portfolio principal: https://$DOMAIN"
echo "   API Backend:        https://api.$DOMAIN"
echo "   Projet 1:           https://project1.$DOMAIN"
echo "   Projet 2:           https://project2.$DOMAIN"
echo "   Dashboard Traefik:  https://traefik.$DOMAIN"
echo "   Dashboard local:    http://localhost:8080"

echo
echo "🔧 Commandes de dépannage utiles:"
echo "   Logs temps réel:    docker-compose -f docker-compose.traefik.yml logs -f"
echo "   État des services:  docker-compose -f docker-compose.traefik.yml ps"
echo "   Redémarrage:        docker-compose -f docker-compose.traefik.yml restart"
echo "   Test manuel:        curl -H 'Host: $DOMAIN' http://localhost"

print_success "Tests terminés !"
