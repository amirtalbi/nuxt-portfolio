# Portfolio Nuxt.js

Un portfolio moderne et minimaliste construit avec Nuxt.js.

## 🚀 Fonctionnalités

- ✨ Interface moderne et responsive avec Nuxt.js
-  Configuration HTTPS prête pour la production
- 🐳 Déploiement Docker avec Traefik comme proxy reverse
- 🎨 Design avec Tailwind CSS et Nuxt UI
- 📱 Interface optimisée mobile et desktop

## 📋 Prérequis

- Node.js (≥18.0.0)
- npm (≥8.0.0)
- Docker et Docker Compose (pour le déploiement)

## 🛠️ Installation

### Mode Développement

```bash
# Cloner le projet
git clone <url-du-repo>
cd portfolio

# Installation des dépendances
npm install

# Démarrer le frontend
npm run dev
```

**Accès en développement :**
- Frontend : http://localhost:3000

### Mode Production (Docker)

```bash
# Configuration complète avec Docker
docker-compose up -d
```

**Accès en production :**
- Site principal : https://amirtalbi.me

## 🐳 Docker

### Commandes Docker utiles

```bash
# Démarrer les services
docker-compose up -d

# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down

# Redémarrer
docker-compose restart

# Reconstruire
docker-compose up --build -d
```

### Services Docker

- **nginx** : Proxy HTTPS (ports 80/443)
- **frontend** : Application Nuxt.js
- **backend** : API Express

## 📁 Structure du Projet

```
portfolio/
├── assets/              # Assets CSS et images
├── backend/             # Service Express
│   ├── server.js        # Serveur principal
│   ├── Dockerfile       # Docker backend
│   └── .env            # Variables d'environnement backend
├── composables/         # Composables Nuxt
├── nginx/              # Configuration Nginx
│   ├── nginx.conf      # Configuration proxy
│   └── ssl/           # Certificats SSL
├── pages/              # Pages Nuxt
├── public/             # Assets publics
├── scripts/            # Scripts de configuration
└── docker-compose.yml  # Orchestration Docker
```

## 🔧 API Endpoints

### `GET /api/health`
Health check du service backend

### `POST /api/contact`
Envoi d'un email de contact

**Body :**
```json
{
  "name": "Nom complet",
  "email": "email@example.com", 
  "message": "Message de contact"
}
```

**Response :**
```json
{
  "success": true,
  "message": "Email envoyé avec succès"
}
```

## 🛡️ Sécurité

- Rate limiting : 5 emails maximum par IP toutes les 15 minutes
- Validation des données côté client et serveur
- Headers de sécurité avec Helmet
- CORS configuré
- Certificats SSL (auto-signés pour le développement)

## 📧 Templates Email

### Email de notification (pour vous)
- Design moderne avec dégradés
- Informations complètes de contact
- Message formaté avec style
- Responsive design

### Email de confirmation (pour l'expéditeur)
- Confirmation de réception
- Rappel du message envoyé
- Signature professionnelle avec liens
- Design cohérent avec la marque

## 🔒 HTTPS

Le projet utilise des certificats SSL auto-signés générés automatiquement pour le développement. Votre navigateur affichera un avertissement de sécurité :

1. Cliquez sur **Avancé**
2. Puis **Continuer vers localhost**

Pour la production, remplacez les certificats dans `nginx/ssl/` par des certificats valides.

## 🚀 Déploiement

### Variables d'environnement de production

Créez un fichier `backend/.env` avec vos vraies valeurs :

```env
PORT=3001
FRONTEND_URL=https://votre-domaine.com
EMAIL_SERVICE=gmail
EMAIL_USER=votre-email@gmail.com
EMAIL_PASS=votre-app-password
OWNER_EMAIL=votre-email@gmail.com
```

### Nginx en production

Remplacez les certificats SSL auto-signés par des certificats valides (Let's Encrypt recommandé).

## 🐛 Dépannage

### Erreur CORS lors de l'envoi d'emails

Si vous rencontrez une erreur CORS, voici les étapes de résolution :

1. **Vérifiez la configuration backend** (`backend/.env`) :
   ```env
   # En développement
   FRONTEND_URL=http://localhost:3000
   
   # En production
   FRONTEND_URL=https://votre-domaine.com
   ```

2. **Vérifiez la configuration frontend** (`.env`) :
   ```env
   # En développement
   API_URL=http://localhost:3001
   ```

3. **Redémarrez le backend** :
   ```bash
   cd backend
   npm run dev
   ```

4. **Utilisez le script de diagnostic** :
   ```bash
   ./scripts/debug-cors.sh
   ```

5. **Videz le cache du navigateur** : `Cmd+Shift+R` (Mac) ou `Ctrl+Shift+R` (PC)

### Email ne s'envoie pas
- Vérifiez la configuration dans `backend/.env`
- Vérifiez que l'App Password Gmail est correct
- Consultez les logs : `docker-compose logs backend`

### Erreur CORS
- Vérifiez que `FRONTEND_URL` est correct dans `backend/.env`
- En développement : `http://localhost:3000`
- En production : `https://localhost` ou votre domaine

### Certificat SSL
- Les certificats auto-signés sont normaux en développement
- Acceptez l'avertissement de sécurité dans votre navigateur
- Regénérez les certificats : `./scripts/generate-ssl.sh`

## 📝 Scripts Disponibles

### Frontend (Nuxt.js)
```bash
npm run dev          # Mode développement
npm run build        # Build de production
npm run preview      # Aperçu du build
```

### Backend (Express)
```bash
npm start           # Mode production
npm run dev         # Mode développement avec nodemon
```

### Configuration
```bash
./scripts/dev-setup.sh     # Configuration développement
./scripts/setup.sh         # Configuration Docker/Production
./scripts/generate-ssl.sh  # Générer certificats SSL
```

## 🤝 Contribution

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👨‍💻 Auteur

**Amir Talbi** - Développeur Full Stack
- Portfolio : [Webinnov Paris](https://webinnov-paris.fr/)
- LinkedIn : [Amir Talbi](https://www.linkedin.com/in/amir-talbi)
- GitHub : [@amirtalbi](https://github.com/amirtalbi)
