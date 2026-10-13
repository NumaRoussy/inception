*This project has been created as part of the 42 curriculum by nroussy.*

# Inception

## Description

### Project Overview
**Inception** is a system administration project at 42 that sets up a complete, containerized web infrastructure inside a Debian Virtual Machine using **Docker** and **Docker Compose**.

The stack is composed of three isolated services built from custom `Dockerfile` files based on `debian:bookworm` (the penultimate stable logic/no `:latest` tag):
- **NGINX**: Acts as the sole entry point to the infrastructure on port `443` using `TLSv1.2` and `TLSv1.3`.
- **WordPress + PHP-FPM**: Runs the CMS application on internal port `9000`, automatically configured using `wp-cli` with two distinct users (an administrator without "admin" in the username, and a regular user).
- **MariaDB**: Provides the relational database for WordPress on internal port `3306`.

### Design Choices & Technical Comparisons
The repository separates orchestration (`Makefile` at the root), sensitive credentials (`secrets/` ignored by Git), and service definitions (`srcs/docker-compose.yml`, `srcs/.env`, and `srcs/requirements/`). Each container runs its main daemon in the foreground (PID 1) and automatically restarts on failure (`restart: on-failure`).

- **Virtual Machines vs Docker**: A Virtual Machine emulates full hardware and runs a complete guest operating system with its own kernel, consuming heavy CPU and RAM resources. Docker containers share the host OS kernel and isolate only the application processes and dependencies, making them lightweight and fast to start.
- **Secrets vs Environment Variables**: Environment variables (stored in `srcs/.env`) are suited for non-sensitive configuration (domain name, database name, usernames) but remain visible in plain text inside the container environment. Docker Secrets mount sensitive files (passwords) inside `/run/secrets/` in RAM only for authorized containers, preventing credential leaks in `Dockerfile` layers or Git history.
- **Docker Network vs Host Network**: Using `network: host` (forbidden in this project) removes network isolation by binding containers directly to the host's network stack. A custom Docker `bridge` network (`inception`) isolates containers in a private virtual network with built-in DNS resolution by service name (`mariadb:3306`, `wordpress:9000`), exposing only port `443` on NGINX.
- **Docker Volumes vs Bind Mounts**: A bind mount directly maps an arbitrary host directory into a container, whereas a Docker Volume is managed by the Docker daemon. In this project, named Docker volumes (`mariadb_data` and `wordpress_data`) are configured with the local driver to persist data inside `/home/nroussy/data/` on the host machine.

## Instructions

1. **Clone the repository** inside the Virtual Machine:
   ```bash
   git clone git@github.com:NumaRoussy/inception.git
   cd inception
   ```
2. **Configure environment and secrets**:
   - Copy `srcs/.env.example` to `srcs/.env` and fill in the environment variables.
   - Ensure the `secrets/` directory at the root contains `db_password.txt`, `db_root_password.txt`, and `credentials.txt` (or `wp_admin_password.txt` / `wp_user_password.txt`).
3. **Build and launch the stack**:
   ```bash
   make
   ```
4. **Access the website**:
   - Open `https://nroussy.42.fr` in your browser.
5. **Stop or clean the project**:
   - Stop containers: `make down`
   - Full reset (including volumes and host data): `make fclean` or `make re`

## Resources

### Classic References
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [NGINX SSL/TLS & FastCGI Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)

### AI Usage
In accordance with the project guidelines, AI tools were used as a learning and troubleshooting assistant for the following tasks:
- Understanding core Docker concepts (PID 1 daemon execution, custom bridge networking, named volumes vs bind mounts, and Docker secrets).
- Debugging service initialization scripts (`mariadb-install-db`, `wp-cli` setup, and FastCGI communication between NGINX and PHP-FPM).
- Structuring and proofreading the documentation files (`README.md`, `USER_DOC.md`, and `DEV_DOC.md`).
