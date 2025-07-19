#!/bin/bash

# Script pour ajouter un nouveau projet au portfolio avec Traefik
echo "🚀 Ajout d'un nouveau projet au portfolio..."

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Récupération des informations du projet
read -p "Nom du projet (ex: mon-super-projet): " PROJECT_NAME
read -p "Type de projet (static/node/react/vue/other): " PROJECT_TYPE
read -p "Port du projet (ex: 3000, 8080): " PROJECT_PORT

# Validation
if [ -z "$PROJECT_NAME" ]; then
    echo "Erreur: Le nom du projet est requis"
    exit 1
fi

if [ -z "$PROJECT_PORT" ]; then
    PROJECT_PORT=80
fi

# Création du dossier du projet
print_step "Création du dossier projects/$PROJECT_NAME..."
mkdir -p "projects/$PROJECT_NAME"

# Configuration selon le type de projet
case $PROJECT_TYPE in
    "static")
        print_step "Configuration d'un projet statique..."
        cat > "projects/$PROJECT_NAME/index.html" << EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$PROJECT_NAME - Portfolio</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #6B73FF, #000DFF);
            color: white;
            margin: 0;
            padding: 2rem;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: rgba(255,255,255,0.1);
            padding: 3rem;
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }
        h1 { font-size: 3rem; margin-bottom: 1rem; }
        p { font-size: 1.2rem; opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 $PROJECT_NAME</h1>
        <p>Nouveau projet ajouté au portfolio</p>
        <a href="/" style="color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 1rem 2rem; border-radius: 30px; display: inline-block; margin-top: 2rem;">🏠 Retour au Portfolio</a>
    </div>
</body>
</html>
EOF
        DOCKER_CONFIG="
  $PROJECT_NAME:
    image: nginx:alpine
    container_name: portfolio-$PROJECT_NAME
    volumes:
      - ./projects/$PROJECT_NAME:/usr/share/nginx/html:ro
    networks:
      - traefik-network
    labels:
      - \"traefik.enable=true\"
      - \"traefik.docker.network=traefik-network\"
      - \"traefik.http.routers.$PROJECT_NAME.rule=Host(\\\`$PROJECT_NAME.\\\${DOMAIN:-localhost}\\\`)\"
      - \"traefik.http.routers.$PROJECT_NAME.entrypoints=websecure\"
      - \"traefik.http.routers.$PROJECT_NAME.tls.certresolver=letsencrypt\"
      - \"traefik.http.routers.$PROJECT_NAME.service=$PROJECT_NAME\"
      - \"traefik.http.services.$PROJECT_NAME.loadbalancer.server.port=80\"
    restart: unless-stopped"
        ;;
        
    "node")
        print_step "Configuration d'un projet Node.js..."
        cat > "projects/$PROJECT_NAME/package.json" << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Projet $PROJECT_NAME du portfolio",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

        cat > "projects/$PROJECT_NAME/server.js" << EOF
const express = require('express');
const app = express();
const PORT = process.env.PORT || $PROJECT_PORT;

app.get('/', (req, res) => {
    res.send(\`
        <html>
        <head>
            <title>$PROJECT_NAME</title>
            <style>
                body { font-family: Arial; background: linear-gradient(135deg, #667eea, #764ba2); color: white; margin: 0; padding: 2rem; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
                .container { text-align: center; background: rgba(255,255,255,0.1); padding: 3rem; border-radius: 20px; backdrop-filter: blur(10px); }
                h1 { font-size: 3rem; margin-bottom: 1rem; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>⚡ $PROJECT_NAME</h1>
                <p>Application Node.js en cours d'exécution</p>
                <a href="/" style="color: white; background: rgba(255,255,255,0.2); padding: 1rem 2rem; border-radius: 30px; text-decoration: none; display: inline-block; margin-top: 2rem;">🏠 Portfolio</a>
            </div>
        </body>
        </html>
    \`);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(\`🚀 $PROJECT_NAME démarré sur le port \${PORT}\`);
});
EOF

        DOCKER_CONFIG="
  $PROJECT_NAME:
    build:
      context: ./projects/$PROJECT_NAME
      dockerfile: Dockerfile
    container_name: portfolio-$PROJECT_NAME
    environment:
      - PORT=$PROJECT_PORT
    networks:
      - traefik-network
    labels:
      - \"traefik.enable=true\"
      - \"traefik.docker.network=traefik-network\"
      - \"traefik.http.routers.$PROJECT_NAME.rule=Host(\\\`$PROJECT_NAME.\\\${DOMAIN:-localhost}\\\`)\"
      - \"traefik.http.routers.$PROJECT_NAME.entrypoints=websecure\"
      - \"traefik.http.routers.$PROJECT_NAME.tls.certresolver=letsencrypt\"
      - \"traefik.http.routers.$PROJECT_NAME.service=$PROJECT_NAME\"
      - \"traefik.http.services.$PROJECT_NAME.loadbalancer.server.port=$PROJECT_PORT\"
    restart: unless-stopped"

        # Création du Dockerfile
        cat > "projects/$PROJECT_NAME/Dockerfile" << EOF
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE $PROJECT_PORT
CMD ["npm", "start"]
EOF
        ;;
        
    *)
        print_warning "Type de projet non reconnu, création d'un projet statique par défaut..."
        PROJECT_TYPE="static"
        # Réutilise la configuration statique
        ;;
esac

print_success "Structure du projet créée"

# Ajout de la configuration Docker Compose
print_step "Ajout de la configuration Docker Compose..."

# Backup du fichier docker-compose.traefik.yml
cp docker-compose.traefik.yml docker-compose.traefik.yml.backup

# Ajout du nouveau service avant la section networks
sed -i '' "/^networks:/i\\
$DOCKER_CONFIG
" docker-compose.traefik.yml

print_success "Configuration Docker ajoutée"

# Installation des dépendances si Node.js
if [ "$PROJECT_TYPE" = "node" ]; then
    print_step "Installation des dépendances Node.js..."
    cd "projects/$PROJECT_NAME"
    npm install
    cd ../..
    print_success "Dépendances installées"
fi

# Mise à jour du fichier .env.traefik
print_step "Mise à jour de la configuration..."
echo "PROJECT_${PROJECT_NAME^^}_NAME=$PROJECT_NAME" >> .env.traefik

print_success "Projet $PROJECT_NAME ajouté avec succès !"

echo
print_warning "Prochaines étapes:"
echo "1. Configurez votre DNS: A $PROJECT_NAME.votre-domaine.nc.me -> IP_VPS"
echo "2. Redémarrez les services: docker-compose -f docker-compose.traefik.yml up -d"
echo "3. Visitez: https://$PROJECT_NAME.votre-domaine.nc.me"
echo
echo "Commandes utiles:"
echo "  Redémarrage:  docker-compose -f docker-compose.traefik.yml restart $PROJECT_NAME"
echo "  Logs:         docker-compose -f docker-compose.traefik.yml logs -f $PROJECT_NAME"
