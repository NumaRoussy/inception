# Documentation Utilisateur — Inception

## 1. Services fournis par l'infrastructure
Cette pile (stack) déploie un site web WordPress sécurisé à l'aide de trois conteneurs isolés[cite: 1, 5] :
* **NGINX** : Serveur web servant de point d'entrée unique à l'infrastructure, accessible uniquement via le port `443` (HTTPS avec protocoles TLSv1.2 et TLSv1.3)[cite: 1, 5, 6].
* **WordPress (PHP-FPM)** : Système de gestion de contenu (CMS) qui exécute le code PHP du site sur le port interne `9000`[cite: 1, 3, 5].
* **MariaDB** : Serveur de base de données relationnelle qui stocke les contenus et les utilisateurs du site sur le port interne `3306`[cite: 1, 3, 5].

## 2. Démarrer et arrêter le projet
Toutes les commandes s'exécutent depuis la racine du dépôt via le `Makefile`[cite: 1, 3] :
* **Démarrer le projet** : `make` (construit les images et lance les conteneurs en arrière-plan).
* **Arrêter le projet** : `make down` (arrête et supprime les conteneurs ainsi que le réseau sans effacer les données).
* **Redémarrer à zéro** : `make re` (supprime tout, y compris les volumes de données, et reconstruit l'infrastructure)[cite: 3].

## 3. Accéder au site web et au panneau d'administration
Pour accéder au site depuis la machine hôte sans utiliser les droits `sudo` :
* **Connaître l'IP de la VM** : `ip a` (repérer l'adresse sur l'interface `enp0s8`, par ex. `192.168.56.101`)[cite: 2, 6, 7].
* **Ouvrir le proxy SOCKS** : `ssh -D 9050 nroussy@192.168.56.101 -N` (puis configurer Firefox avec le proxy SOCKS v5 sur l'hôte `127.0.0.1`, port `9050`, en cochant « Déporter la résolution DNS lors de l'utilisation de SOCKS v5 »)[cite: 3, 7].
* **Accès au site web** : [https://nroussy.42.fr](https://nroussy.42.fr) (accepter l'avertissement lié au certificat TLS auto-signé)[cite: 3, 5].
* **Accès au panneau d'administration** : [https://nroussy.42.fr/wp-login.php](https://nroussy.42.fr/wp-login.php)[cite: 3].

## 4. Localiser et gérer les identifiants (Credentials)
Pour des raisons de sécurité, aucun mot de passe n'est présent dans les `Dockerfile` ni suivi par Git :
* **Configuration générale (`srcs/.env`)** : Contient le nom de domaine (`DOMAIN_NAME=nroussy.42.fr`), le nom de la base et les identifiants des deux utilisateurs WordPress (dont l'administrateur `nroussy`, qui ne contient pas le mot « admin »)[cite: 1, 3].
* **Mots de passe (`secrets/`)** : Les mots de passe sont stockés localement à la racine dans le dossier `secrets/` (`db_password.txt`, `db_root_password.txt`, `credentials.txt` / `wp_admin_password.txt`)[cite: 1, 3, 9].

## 5. Vérifier le bon fonctionnement des services
* **Vérifier l'état des conteneurs (alternative à `docker ps`)** : `docker compose -p srcs ps` (ou `make status`)[cite: 3, 4].
* **Tester la connexion HTTPS** : `curl -k https://nroussy.42.fr`[cite: 3, 6].
* **Consulter les journaux (logs)** : `make logs`[cite: 3].
