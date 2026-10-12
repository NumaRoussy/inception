FROM debian:bookworm

RUN apt update && apt install -y \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl \
    ca-certificates

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

RUN mkdir -p /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
