FROM node:20-alpine

# Installer dumb-init pour la gestion des signaux
RUN apk add --no-cache dumb-init

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json
COPY package*.json ./

# Installer les dépendances
RUN npm install --omit=dev --ignore-scripts --no-audit

# Copier le code source
COPY . .

# Créer un utilisateur non-root pour la sécurité
RUN addgroup -g 1001 -S nodejs && \
    adduser -S backend -u 1001

# Changer le propriétaire du répertoire
RUN chown -R backend:nodejs /app
USER backend

# Exposer le port
EXPOSE 3001

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3001/api/health || exit 1

# Variables d'environnement
ENV NODE_ENV=production
ENV PORT=3001

# Commande de démarrage
CMD ["dumb-init", "node", "server.js"]
