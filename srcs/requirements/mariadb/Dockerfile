FROM debian:bookworm

RUN apt update && apt install -y mariadb-server

COPY conf/server.cnf /etc/mysql/mariadb.conf.d/server.cnf
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]