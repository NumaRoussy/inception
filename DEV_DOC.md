# Documentation Développeur — Inception

## 1. Mise en place de l'environnement depuis zéro
### Prérequis
* Une machine virtuelle sous Debian 12 équipée de `docker`, du plugin `docker compose`, de `make` et de `git`.
* Les dossiers de stockage créés sur l'hôte : `/home/nroussy/data/mariadb` et `/home/nroussy/data/wordpress`[cite: 1, 3, 6].

### Configuration et Secrets
1. **Fichier `.env`** : Créer le fichier `srcs/.env` (à partir de `srcs/.env.example`) pour définir le domaine `nroussy.42.fr` ainsi que les variables de configuration MySQL et WordPress.
2. **Dossier `secrets/`** : Créer le dossier `secrets/` à la racine du dépôt et y placer les fichiers contenant les mots de passe (`db_password.txt`, `db_root_password.txt`, `credentials.txt`)[cite: 1, 9].

## 2. Construction et lancement (Makefile & Docker Compose)
Le `Makefile` pilote `srcs/docker-compose.yml` avec l'option `-f`[cite: 1, 3] :
* `make` ou `make all` : Crée les répertoires de données et lance `docker compose -f srcs/docker-compose.yml up -d --build`[cite: 3].
* `make down` : Exécute `docker compose -f srcs/docker-compose.yml down` (arrête les conteneurs et détruit le réseau privé)[cite: 3, 4].
* `make clean` : Arrête et supprime les conteneurs ainsi que le réseau[cite: 3].
* `make fclean` : Exécute `docker compose -f srcs/docker-compose.yml down --volumes --rmi all` et supprime les fichiers dans `/home/nroussy/data/*`[cite: 3].
* `make re` : Exécute `fclean` puis `all` pour reconstruire l'infrastructure à neuf[cite: 3].

## 3. Commandes utiles et aide-mémoire (Correction / Gestion)
Voici les commandes essentielles pour inspecter et tester les conteneurs, le réseau et la base de données lors de l'évaluation :

* **Connaître l'IP** :
  ```bash
  ip a
