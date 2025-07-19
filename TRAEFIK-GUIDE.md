# Portfolio avec Traefik - Gestion Multi-Projets

Ce guide vous explique comment utiliser Traefik pour héberger votre portfolio principal sur votre domaine racine et vos projets sur des sous-domaines.

## 🏗️ Architecture

```
votre-domaine.nc.me           → Portfolio principal (Nuxt.js)
api.votre-domaine.nc.me       → API Backend (Express.js)
project1.votre-domaine.nc.me  → Projet 1 (Site statique)
project2.votre-domaine.nc.me  → Projet 2 (App Node.js)
traefik.votre-domaine.nc.me   → Dashboard Traefik (optionnel)
```

## 🚀 Installation et Configuration

### 1. Configuration initiale

1. **Éditez le fichier `.env.traefik`** :
   ```bash
   DOMAIN=votre-domaine.nc.me
   EMAIL=votre-email@gmail.com
   ```

2. **Configurez vos DNS** chez nc.me :
   ```
   Type  Nom       Valeur
   A     @         IP_DE_VOTRE_VPS
   A     api       IP_DE_VOTRE_VPS
   A     project1  IP_DE_VOTRE_VPS
   A     project2  IP_DE_VOTRE_VPS
   A     traefik   IP_DE_VOTRE_VPS
   A     *         IP_DE_VOTRE_VPS (wildcard pour futurs projets)
   ```

### 2. Déploiement

```bash
# Setup automatique
./scripts/setup-traefik.sh

# Ou manuellement
docker network create traefik-network
docker-compose -f docker-compose.traefik.yml --env-file .env.traefik up -d
```

## 📁 Structure des Projets

```
portfolio/
├── projects/
│   ├── project1/           # Site statique
│   │   └── index.html
│   ├── project2/           # App Node.js
│   │   ├── package.json
│   │   ├── server.js
│   │   └── Dockerfile
│   └── nouveau-projet/     # Futurs projets
├── docker-compose.traefik.yml
├── .env.traefik
└── scripts/
    ├── setup-traefik.sh
    └── add-project.sh
```

## ➕ Ajouter un Nouveau Projet

### Méthode automatique
```bash
./scripts/add-project.sh
```

### Méthode manuelle

1. **Créez le dossier du projet** :
   ```bash
   mkdir projects/mon-projet
   ```

2. **Ajoutez le contenu du projet** dans `projects/mon-projet/`

3. **Ajoutez la configuration Docker** dans `docker-compose.traefik.yml` :
   ```yaml
   mon-projet:
     # Configuration selon le type de projet
     image: nginx:alpine  # Pour un site statique
     # OU
     build: ./projects/mon-projet  # Pour une app custom
     
     container_name: portfolio-mon-projet
     networks:
       - traefik-network
     labels:
       - "traefik.enable=true"
       - "traefik.docker.network=traefik-network"
       - "traefik.http.routers.mon-projet.rule=Host(`mon-projet.${DOMAIN}`)"
       - "traefik.http.routers.mon-projet.entrypoints=websecure"
       - "traefik.http.routers.mon-projet.tls.certresolver=letsencrypt"
       - "traefik.http.services.mon-projet.loadbalancer.server.port=80"
   ```

4. **Redémarrez les services** :
   ```bash
   docker-compose -f docker-compose.traefik.yml up -d
   ```

## 🔧 Types de Projets Supportés

### Site Statique (HTML/CSS/JS)
```yaml
mon-site:
  image: nginx:alpine
  volumes:
    - ./projects/mon-site:/usr/share/nginx/html:ro
  # ... labels Traefik
```

### Application Node.js
```yaml
mon-app:
  build: ./projects/mon-app
  environment:
    - PORT=3000
  # ... labels Traefik
```

### Application React/Vue (build statique)
```yaml
mon-spa:
  image: nginx:alpine
  volumes:
    - ./projects/mon-spa/dist:/usr/share/nginx/html:ro
  # ... labels Traefik
```

### Application avec Base de Données
```yaml
mon-app-db:
  build: ./projects/mon-app-db
  depends_on:
    - postgres
  environment:
    - DATABASE_URL=postgresql://user:pass@postgres:5432/db
  # ... labels Traefik

postgres:
  image: postgres:14
  environment:
    - POSTGRES_DB=db
    - POSTGRES_USER=user
    - POSTGRES_PASSWORD=pass
  volumes:
    - postgres_data:/var/lib/postgresql/data
```

## 🛠️ Commandes Utiles

### Gestion des services
```bash
# Démarrer tous les services
docker-compose -f docker-compose.traefik.yml up -d

# Voir les logs
docker-compose -f docker-compose.traefik.yml logs -f

# Redémarrer un service spécifique
docker-compose -f docker-compose.traefik.yml restart mon-projet

# Arrêter tous les services
docker-compose -f docker-compose.traefik.yml down
```

### Debug et monitoring
```bash
# Voir l'état des containers
docker-compose -f docker-compose.traefik.yml ps

# Inspecter un container
docker inspect portfolio-mon-projet

# Accéder à un container
docker exec -it portfolio-mon-projet sh

# Voir les certificats SSL
docker exec portfolio-traefik cat /acme.json
```

## 🔒 Sécurité et SSL

### Certificats automatiques
Traefik gère automatiquement :
- ✅ Génération des certificats Let's Encrypt
- ✅ Renouvellement automatique
- ✅ Redirection HTTP → HTTPS
- ✅ HSTS et headers de sécurité

### Dashboard Traefik
Accessible sur `https://traefik.votre-domaine.nc.me`
- Utilisateur : `admin`
- Mot de passe : configuré lors du setup

### Rate Limiting
Rate limiting automatique configuré pour l'API :
- 10 requêtes maximum en burst
- Protection DDoS basique

## 🚨 Dépannage

### Problème de certificat
```bash
# Forcer le renouvellement
docker exec portfolio-traefik rm /acme.json
docker-compose -f docker-compose.traefik.yml restart traefik
```

### Service inaccessible
```bash
# Vérifier les logs
docker-compose -f docker-compose.traefik.yml logs mon-projet

# Vérifier le réseau
docker network inspect traefik-network

# Tester en local
curl -H "Host: mon-projet.votre-domaine.nc.me" http://localhost
```

### DNS non résolu
```bash
# Tester la résolution DNS
nslookup mon-projet.votre-domaine.nc.me
dig mon-projet.votre-domaine.nc.me
```

## 📊 Monitoring et Performance

### Métriques Traefik
Configurez Prometheus/Grafana pour monitoring avancé :
```yaml
# Ajout dans docker-compose.traefik.yml
- "--metrics.prometheus=true"
- "--metrics.prometheus.buckets=0.1,0.3,1.2,5.0"
```

### Health Checks
Tous les services incluent des health checks automatiques pour :
- Détection de pannes
- Redémarrage automatique
- Load balancing intelligent

## 🎯 Exemples d'Usage

1. **Portfolio d'agence** : Chaque client sur son sous-domaine
2. **Projets étudiants** : Un sous-domaine par projet/matière
3. **Démonstrations** : Versions de test vs production
4. **API microservices** : Séparation des services par domaine

## 📞 Support

En cas de problème :
1. Vérifiez les logs : `docker-compose logs -f`
2. Testez la connectivité réseau
3. Vérifiez la configuration DNS
4. Consultez le dashboard Traefik pour l'état des services
