# Developer Documentation — Inception

## 1. Setting Up the Environment from Scratch
### Prerequisites
- A Debian Virtual Machine with `docker`, `docker-compose-plugin` (v2), `make`, and `git` installed.
- Host storage directories created and owned by `nroussy`:
  ```bash
  mkdir -p /home/nroussy/data/mariadb /home/nroussy/data/wordpress
  ```

### Configuration Files & Secrets
1. **Environment File (`srcs/.env`)**: Copy the template and set your variables:
   ```bash
   cp srcs/.env.example srcs/.env
   ```
2. **Docker Secrets (`secrets/`)**: Create the `secrets/` directory at the root of the repository and populate the password files:
   - `secrets/db_password.txt`
   - `secrets/db_root_password.txt`
   - `secrets/credentials.txt` (or `wp_admin_password.txt` / `wp_user_password.txt`)

## 2. Building and Launching the Project
The `Makefile` orchestrates `srcs/docker-compose.yml`:
- `make` / `make all`: Creates `/home/nroussy/data/*` directories and runs `docker compose -f srcs/docker-compose.yml up -d --build`.
- `make down`: Stops and removes containers and the custom network (`docker compose -f srcs/docker-compose.yml down`).
- `make clean`: Alias for `down`.
- `make fclean`: Removes containers, networks, all built images (`--rmi all`), volumes (`--volumes`), and wipes `/home/nroussy/data/*`.
- `make re`: Runs `fclean` followed by `all`.

## 3. Useful Management & Evaluation Commands (Aide-mémoire correction)

- **Find VM IP (Connaître IP)**:
  ```bash
  ip a
  ```
- **Open SOCKS5 proxy from host (Ouvrir proxy SOCKS)**:
  ```bash
  ssh -D 9050 nroussy@192.168.56.101 -N
  ```
- **List project containers without `docker ps` (Test relou au lieu de `docker ps`)**:
  ```bash
  docker compose -p srcs ps
  ```
- **Inspect Docker network (Plus de détail sur un réseau Docker)**:
  ```bash
  docker network inspect srcs_inception
  ```
- **Test HTTPS response (Tester connexion)**:
  ```bash
  curl -k [https://nroussy.42.fr](https://nroussy.42.fr)
  ```
- **Access MariaDB and inspect tables (Accéder à MariaDB et afficher les tables)**:
  - Open MariaDB CLI (Accéder à MariaDB):
    ```bash
    docker exec -it mariadb mariadb -u root -p
    ```
  - List databases (Afficher les bases de données):
    ```sql
    SHOW DATABASES;
    ```
  - Select WordPress database (Choisir wordpress):
    ```sql
    USE wordpress;
    ```
  - List WordPress tables (Afficher les tables de wordpress):
    ```sql
    SHOW TABLES;
    ```

## 4. Data Storage and Persistence
- **Storage Location**: All persistent data is stored on the host VM under `/home/nroussy/data/`:
  - `/home/nroussy/data/mariadb`: Raw MariaDB database files (mounted to `/var/lib/mysql` in the `mariadb` container).
  - `/home/nroussy/data/wordpress`: WordPress core files, themes, plugins, and `wp-config.php` (mounted to `/var/www/html` in both `wordpress` and `nginx` containers).
- **Persistence Mechanism**: Configured in `srcs/docker-compose.yml` using named Docker volumes with `driver: local`, `o: bind`, and `type: none`. When containers are stopped (`make down`) or crash, all files and database records remain intact on the host disk.
