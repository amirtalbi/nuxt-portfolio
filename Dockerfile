FROM node:20-alpine as builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json
COPY package*.json ./

# Installer les dépendances
RUN npm ci

# Copier le code source
COPY . .

# Construire l'application
RUN npm run build

# Image de production
FROM node:20-alpine

# Installer dumb-init pour la gestion des signaux
RUN apk add --no-cache dumb-init

# Définir le répertoire de travail
WORKDIR /app

# Créer un utilisateur non-root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nuxt -u 1001

# Copier les fichiers nécessaires depuis le builder
COPY --from=builder --chown=nuxt:nodejs /app/.output ./

# Passer à l'utilisateur non-root
USER nuxt

# Exposer le port
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Variables d'environnement pour la production
ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

# Commande de démarrage
CMD ["dumb-init", "node", "server/index.mjs"]
