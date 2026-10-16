#!/bin/bash
set -e

# 1. Lecture des Docker Secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

cd /var/www/html

# 2. Attente que MariaDB soit joignable sur le port 3306
echo "Attente de la disponibilité de MariaDB..."
while ! mariadb-admin ping -h mariadb -u "${MYSQL_USER}" -p"${DB_PASSWORD}" --silent; do
    sleep 2
done
echo "MariaDB est joignable !"

# 3. Installation et configuration au premier démarrage
if [ ! -f "wp-config.php" ]; then
    echo "Configuration initiale de WordPress..."

    wp core download --allow-root

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --allow-root

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception nroussy" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root

    echo "Installation de WordPress terminée avec succès !"
fi

# 4. Ajustement des droits
chown -R www-data:www-data /var/www/html

# 5. Démarrage de PHP-FPM au premier plan (PID 1)
mkdir -p /run/php
exec php-fpm8.2 -F
