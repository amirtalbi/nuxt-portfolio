# 🚀 Guide de Déploiement VPS avec Traefik

## Prérequis

✅ VPS Ubuntu/Debian avec accès SSH root  
✅ Nom de domaine (.nc.me pour les étudiants)  
✅ Adresse email valide  

## 1. Préparation du VPS

```bash
# Se connecter au VPS
ssh root@IP_DE_VOTRE_VPS

# Cloner votre projet
git clone https://github.com/votre-username/portfolio.git
cd portfolio

# Préparer le VPS (Docker, firewall, etc.)
./scripts/prepare-vps.sh
```

## 2. Configuration DNS chez NC.ME

Dans votre panneau de gestion DNS :

| Type  | Nom     | Valeur          | TTL |
|-------|---------|-----------------|-----|
| A     | @       | IP_DE_VOTRE_VPS | 300 |
| A     | www     | IP_DE_VOTRE_VPS | 300 |
| A     | traefik | IP_DE_VOTRE_VPS | 300 |
| A     | project1| IP_DE_VOTRE_VPS | 300 |
| A     | project2| IP_DE_VOTRE_VPS | 300 |

⏰ **Attendre 5-10 minutes** pour la propagation DNS

## 3. Configuration des variables d'environnement

```bash
# Backend
cp backend/.env.example backend/.env
nano backend/.env
```

Configurez :
```env
EMAIL_USER=votre.email@gmail.com
EMAIL_PASS=votre_mot_de_passe_app
FRONTEND_URL=https://votre-domaine.nc.me
NODE_ENV=production
```

## 4. Déploiement automatisé

```bash
# Exécuter le déploiement
./scripts/deploy-vps-traefik.sh
```

Le script vous demandera :
- 🌐 Votre nom de domaine
- 📧 Votre email pour Let's Encrypt

## 5. Vérification du déploiement

### Services actifs
```bash
docker compose -f docker-compose.traefik.yml ps
```

### Logs en temps réel
```bash
# Tous les services
docker compose -f docker-compose.traefik.yml logs -f

# Service spécifique
docker compose -f docker-compose.traefik.yml logs -f traefik
docker compose -f docker-compose.traefik.yml logs -f portfolio-frontend
```

### Test des endpoints
```bash
# Portfolio principal
curl -I https://votre-domaine.nc.me

# Traefik dashboard
curl -I https://traefik.votre-domaine.nc.me

# API backend
curl -I https://votre-domaine.nc.me/api/health
```

## 6. URLs d'accès

Une fois déployé, vos services seront accessibles sur :

- 🏠 **Portfolio principal** : https://votre-domaine.nc.me
- 🔧 **Traefik Dashboard** : https://traefik.votre-domaine.nc.me
- 🎯 **Project1** : https://project1.votre-domaine.nc.me
- 🎯 **Project2** : https://project2.votre-domaine.nc.me
- 🔗 **API Backend** : https://votre-domaine.nc.me/api/

## 7. Gestion des projets

### Ajouter un nouveau projet

1. **Créer le sous-domaine DNS**
2. **Ajouter dans docker-compose.traefik.yml** :
```yaml
  new-project:
    build: ./path-to-project
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.new-project.rule=Host(`new-project.votre-domaine.nc.me`)"
      - "traefik.http.routers.new-project.entrypoints=websecure"
      - "traefik.http.routers.new-project.tls.certresolver=letsencrypt"
```

3. **Redéployer** :
```bash
docker compose -f docker-compose.traefik.yml up -d new-project
```

## 8. Commandes utiles

### Redémarrage complet
```bash
docker compose -f docker-compose.traefik.yml down
docker compose -f docker-compose.traefik.yml up -d
```

### Reconstruction des images
```bash
docker compose -f docker-compose.traefik.yml up --build -d
```

### Nettoyage
```bash
docker system prune -f
docker volume prune -f
```

### Sauvegarder les certificats SSL
```bash
cp -r traefik/data /backup/ssl-certificates-$(date +%Y%m%d)
```

## 9. Monitoring et maintenance

### Surveiller les ressources
```bash
# CPU et mémoire
docker stats

# Espace disque
df -h
```

### Logs des certificats SSL
```bash
docker compose -f docker-compose.traefik.yml logs traefik | grep acme
```

### Renouvellement automatique SSL
Les certificats Let's Encrypt se renouvellent automatiquement avec Traefik.

## 10. Dépannage

### Problème de certificat SSL
```bash
# Supprimer et regénérer
rm traefik/data/acme.json
touch traefik/data/acme.json
chmod 600 traefik/data/acme.json
docker compose -f docker-compose.traefik.yml restart traefik
```

### Service non accessible
```bash
# Vérifier les routes Traefik
curl -s http://traefik.votre-domaine.nc.me:8080/api/http/routers | jq

# Vérifier les conteneurs
docker ps
docker logs nom-du-conteneur
```

### Problème de DNS
```bash
# Vérifier la propagation DNS
nslookup votre-domaine.nc.me
dig votre-domaine.nc.me
```

## 11. Sécurité

### Firewall configuré automatiquement
- ✅ Port 22 (SSH)
- ✅ Port 80 (HTTP - redirigé vers HTTPS)
- ✅ Port 443 (HTTPS)
- ❌ Tous les autres ports fermés

### Bonnes pratiques appliquées
- 🔒 HTTPS obligatoire (redirection automatique)
- 🛡️ Headers de sécurité (Helmet.js)
- 🚦 Rate limiting sur l'API
- 📧 CORS configuré strictement
- 🔐 Mots de passe d'application Gmail

---

💡 **Support** : En cas de problème, vérifiez d'abord les logs avec la commande `docker compose logs`
```bash
# Configurer UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable
```

### Création d'un utilisateur non-root (optionnel mais recommandé)
```bash
adduser portfolio
usermod -aG sudo portfolio
su - portfolio
```

## 📁 3. Déploiement du code

### Cloner le projet
```bash
git clone https://github.com/votre-username/nuxt-portfolio.git
cd nuxt-portfolio
```

### Configuration pour la production
```bash
# Copier l'exemple de configuration
cp backend/.env.production.example backend/.env.production

# Éditer la configuration
nano backend/.env.production
```

Configurez vos variables d'environnement :
```env
PORT=3001
FRONTEND_URL=https://votre-domaine.nc.me
EMAIL_SERVICE=gmail
EMAIL_USER=votre-email@gmail.com
EMAIL_PASS=votre-app-password-gmail
OWNER_EMAIL=votre-email@gmail.com
```

## 🚀 4. Déploiement automatique

Exécutez le script de déploiement :
```bash
./scripts/deploy-prod.sh
```

Le script va :
1. Installer Docker si nécessaire
2. Configurer les certificats SSL Let's Encrypt
3. Démarrer tous les services
4. Configurer le renouvellement automatique des certificats

## 🔧 5. Commandes utiles

### Gestion des services Docker
```bash
# Voir les logs
docker-compose -f docker-compose.prod.yml logs -f

# Arrêter les services
docker-compose -f docker-compose.prod.yml down

# Redémarrer
docker-compose -f docker-compose.prod.yml restart

# Reconstruire et redéployer
docker-compose -f docker-compose.prod.yml up --build -d
```

### Surveillance et maintenance
```bash
# Vérifier l'état des services
docker-compose -f docker-compose.prod.yml ps

# Voir l'utilisation des ressources
docker stats

# Nettoyer les images inutilisées
docker system prune -a
```

## 🔒 6. Sécurité

### Configuration SSH sécurisée
```bash
# Éditer la configuration SSH
sudo nano /etc/ssh/sshd_config

# Ajouter/modifier ces lignes :
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes

# Redémarrer SSH
sudo systemctl restart ssh
```

### Surveillance des logs
```bash
# Logs nginx
docker-compose -f docker-compose.prod.yml logs nginx

# Logs backend
docker-compose -f docker-compose.prod.yml logs backend

# Logs système
tail -f /var/log/syslog
```

## 🔄 7. Renouvellement des certificats SSL

Les certificats Let's Encrypt sont automatiquement renouvelés via cron.

Pour vérifier :
```bash
# Voir les tâches cron
crontab -l

# Tester le renouvellement manuellement
docker-compose -f docker-compose.prod.yml run --rm certbot renew --dry-run
```

## 📊 8. Monitoring et alertes

### Installation de outils de monitoring (optionnel)
```bash
# Installer htop pour surveiller les ressources
sudo apt install htop

# Installer fail2ban pour la sécurité
sudo apt install fail2ban
```

### Configuration de fail2ban
```bash
sudo nano /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
```

## 🐛 9. Dépannage

### Problèmes courants

**Le site n'est pas accessible :**
1. Vérifiez que les DNS pointent vers votre VPS : `nslookup votre-domaine.nc.me`
2. Vérifiez que les services Docker tournent : `docker-compose -f docker-compose.prod.yml ps`
3. Vérifiez les logs : `docker-compose -f docker-compose.prod.yml logs`

**Certificats SSL non générés :**
1. Vérifiez que votre domaine pointe vers le VPS
2. Assurez-vous que les ports 80 et 443 sont ouverts
3. Relancez la génération : `docker-compose -f docker-compose.prod.yml run --rm certbot`

**Emails ne s'envoient pas :**
1. Vérifiez la configuration dans `backend/.env.production`
2. Testez l'API : `curl -X POST https://votre-domaine.nc.me/api/contact`
3. Vérifiez les logs du backend

## 🔄 10. Mise à jour du code

Pour mettre à jour votre portfolio :

```bash
# Récupérer les dernières modifications
git pull origin main

# Reconstruire et redéployer
docker-compose -f docker-compose.prod.yml up --build -d

# Vérifier que tout fonctionne
docker-compose -f docker-compose.prod.yml ps
```

## 📞 11. Support

Si vous rencontrez des problèmes :

1. Vérifiez les logs détaillés
2. Consultez la documentation Docker
3. Vérifiez la configuration DNS
4. Testez la connectivité réseau

Votre portfolio sera accessible sur :
- https://votre-domaine.nc.me
- https://www.votre-domaine.nc.me
