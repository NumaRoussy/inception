#!/bin/bash
set -e

# Lecture directe des secrets montés par Docker
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Préparation des dossiers système
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialisation au premier démarrage uniquement
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initialisation de la base de données MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mariadbd --user=mysql --skip-networking &
    pid="$!"

    until mariadb-admin ping --silent; do
        sleep 1
    done

    # Accès autorisés à la fois depuis le réseau Docker (%) et en local (localhost)
    mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    wait "$pid"

    echo "Base de données initialisée avec succès !"
fi

# Lancement de MariaDB en PID 1
exec mariadbd --user=mysql