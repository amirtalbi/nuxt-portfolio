# Déploiement sur VPS avec nom de domaine

Guide complet pour déployer votre portfolio sur un VPS avec votre nom de domaine nc.me.

## 🌐 1. Configuration DNS chez nc.me

1. Connectez-vous à votre panneau de contrôle nc.me
2. Allez dans la section DNS
3. Configurez les enregistrements suivants :

```
Type    Nom     Valeur              TTL
A       @       IP_DE_VOTRE_VPS    3600
A       www     IP_DE_VOTRE_VPS    3600
```

## 🖥️ 2. Préparation du VPS

### Connexion SSH et mise à jour
```bash
ssh root@IP_DE_VOTRE_VPS

# Mise à jour du système
apt update && apt upgrade -y

# Installation des outils de base
apt install -y curl wget git nano ufw
```

### Configuration du firewall
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
