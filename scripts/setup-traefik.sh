#!/bin/bash

# Script de setup Traefik pour le portfolio
echo "🚀 Configuration de Traefik pour le portfolio..."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction d'affichage
print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérification des prérequis
print_step "Vérification des prérequis..."

if ! command -v docker &> /dev/null; then
    print_error "Docker n'est pas installé"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose n'est pas installé"
    exit 1
fi

print_success "Docker et Docker Compose sont installés"

# Création du réseau Traefik
print_step "Création du réseau Traefik..."
docker network create traefik-network 2>/dev/null || print_warning "Le réseau traefik-network existe déjà"

# Configuration des variables d'environnement
print_step "Configuration des variables d'environnement..."

if [ ! -f .env.traefik ]; then
    print_error "Le fichier .env.traefik n'existe pas"
    exit 1
fi

# Lecture du domaine depuis .env.traefik
DOMAIN=$(grep "^DOMAIN=" .env.traefik | cut -d'=' -f2)
EMAIL=$(grep "^EMAIL=" .env.traefik | cut -d'=' -f2)

if [ -z "$DOMAIN" ] || [ "$DOMAIN" = "votre-domaine.nc.me" ]; then
    print_warning "Veuillez configurer votre domaine dans .env.traefik"
    read -p "Entrez votre domaine (ex: monsite.nc.me): " DOMAIN
    sed -i '' "s/DOMAIN=.*/DOMAIN=$DOMAIN/" .env.traefik
fi

if [ -z "$EMAIL" ] || [ "$EMAIL" = "votre-email@gmail.com" ]; then
    print_warning "Veuillez configurer votre email dans .env.traefik"
    read -p "Entrez votre email pour Let's Encrypt: " EMAIL
    sed -i '' "s/EMAIL=.*/EMAIL=$EMAIL/" .env.traefik
fi

print_success "Variables d'environnement configurées"

# Génération du hash pour le dashboard Traefik
print_step "Configuration du dashboard Traefik..."
read -s -p "Entrez un mot de passe pour le dashboard Traefik: " DASHBOARD_PASSWORD
echo
DASHBOARD_HASH=$(docker run --rm httpd:2.4-alpine htpasswd -nbB admin "$DASHBOARD_PASSWORD" | tr -d '\n')
sed -i '' "s|traefik.http.middlewares.auth.basicauth.users=.*|traefik.http.middlewares.auth.basicauth.users=$DASHBOARD_HASH|" docker-compose.traefik.yml

print_success "Dashboard Traefik configuré"

# Création des dossiers pour les projets
print_step "Création de la structure des projets..."
mkdir -p projects/project1 projects/project2
print_success "Structure des projets créée"

# Installation des dépendances pour project2
if [ -f projects/project2/package.json ]; then
    print_step "Installation des dépendances Node.js pour project2..."
    cd projects/project2
    npm install --production
    cd ../..
    print_success "Dépendances installées"
fi

# Arrêt des anciens services
print_step "Arrêt des anciens services..."
docker-compose down 2>/dev/null || true
docker-compose -f docker-compose.production.yml down 2>/dev/null || true

# Démarrage avec Traefik
print_step "Démarrage des services avec Traefik..."
export DOMAIN EMAIL
docker-compose -f docker-compose.traefik.yml --env-file .env.traefik up -d

# Vérification du démarrage
print_step "Vérification du démarrage des services..."
sleep 10

# Test des services
services=("traefik" "frontend" "backend")
for service in "${services[@]}"; do
    if docker-compose -f docker-compose.traefik.yml ps | grep -q "$service.*Up"; then
        print_success "Service $service démarré"
    else
        print_error "Échec du démarrage du service $service"
        docker-compose -f docker-compose.traefik.yml logs $service
    fi
done

# Affichage des URLs
print_step "Services déployés avec succès !"
echo
echo "🌐 URLs disponibles:"
echo "   Portfolio principal: https://$DOMAIN"
echo "   API Backend:        https://api.$DOMAIN"
echo "   Projet 1:           https://project1.$DOMAIN"
echo "   Projet 2:           https://project2.$DOMAIN"
echo "   Dashboard Traefik:  https://traefik.$DOMAIN"
echo
echo "📋 Commandes utiles:"
echo "   Logs:               docker-compose -f docker-compose.traefik.yml logs -f"
echo "   Redémarrage:        docker-compose -f docker-compose.traefik.yml restart"
echo "   Arrêt:              docker-compose -f docker-compose.traefik.yml down"
echo
print_success "Configuration Traefik terminée !"

# Configuration DNS
print_warning "N'oubliez pas de configurer vos enregistrements DNS:"
echo "   A    $DOMAIN           -> IP_DE_VOTRE_VPS"
echo "   A    api.$DOMAIN       -> IP_DE_VOTRE_VPS"
echo "   A    project1.$DOMAIN  -> IP_DE_VOTRE_VPS"
echo "   A    project2.$DOMAIN  -> IP_DE_VOTRE_VPS"
echo "   A    traefik.$DOMAIN   -> IP_DE_VOTRE_VPS"
