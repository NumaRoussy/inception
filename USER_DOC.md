# User Documentation — Inception

## 1. Provided Services
This stack provides a complete WordPress website running across three containers:
- **NGINX**: Secure HTTPS web server acting as the single entry point on port `443` (`TLSv1.2` / `TLSv1.3`).
- **WordPress (PHP-FPM)**: Content Management System running the website on internal port `9000`.
- **MariaDB**: SQL database storing website content and user accounts on internal port `3306`.

## 2. Starting and Stopping the Project
Run the following commands from the root of the repository using the `Makefile`:
- **Start the project**: `make` (builds the images and starts all containers in the background).
- **Stop the project**: `make down` (stops and removes the containers while keeping the website data intact).
- **Restart from scratch**: `make re` (deletes containers, volumes, and persistent data, then rebuilds everything).

## 3. Accessing the Website and Administration Panel
If you do not have `sudo` rights on the host machine to edit `/etc/hosts`, use an SSH SOCKS5 proxy:
- **Check VM IP address (Connaître IP)**:
  ```bash
  ip a
  ```
- **Open SOCKS proxy (Ouvrir proxy SOCKS)**:
  ```bash
  ssh -D 9050 nroussy@192.168.56.101 -N
  ```
  *(Configure Firefox to use SOCKS v5 proxy `127.0.0.1` on port `9050` and check "Proxy DNS when using SOCKS v5").*
- **Website URL**: `https://nroussy.42.fr` (accept the self-signed certificate warning).
- **Administration Panel URL**: `https://nroussy.42.fr/wp-login.php`

## 4. Locating and Managing Credentials
All sensitive credentials are kept local and ignored by Git:
- **Environment variables (`srcs/.env`)**: Stores the domain name (`nroussy.42.fr`), database name (`wordpress`), database user, and the two WordPress usernames/emails.
- **Passwords (`secrets/`)**: Stored in plain text files inside the `secrets/` directory at the root of the repository (`db_password.txt`, `db_root_password.txt`, and WordPress password files).

## 5. Checking that Services are Running Correctly
- **Check container status (Test relou au lieu de `docker ps`)**:
  ```bash
  docker compose -p srcs ps
  ```
- **Test HTTPS connection (Tester connexion)**:
  ```bash
  curl -k [https://nroussy.42.fr](https://nroussy.42.fr)
  ```
- **Follow container logs**:
  ```bash
  make logs
  ```
