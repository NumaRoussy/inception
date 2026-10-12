FROM debian:bookworm

RUN apt update && apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=CH/ST=Vaud/L=Lausanne/O=42Lausanne/OU=nroussy/CN=nroussy.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/html && \
    echo "<h1>Hello from NGINX Inception (nroussy)</h1>" > /var/www/html/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
