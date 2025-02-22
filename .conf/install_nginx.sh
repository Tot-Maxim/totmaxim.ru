#!/bin/bash

# Проверка прав суперпользователя
if [ "$(id -u)" -ne 0 ]; then
    echo "Необходимы права суперпользователя. Пожалуйста, выполните скрипт с использованием sudo."
    exit 1
fi

# Установка необходимых пакетов
apt update
apt install -y curl gnupg2 ca-certificates lsb-release

# Добавление репозитория Nginx
echo "deb http://nginx.org/packages/ubuntu/ $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

# Установка Nginx версии 1.24.0
apt update
apt install -y nginx=1.24.0-1~$(lsb_release -cs)

# Создание конфигурационного файла nginx.conf
NGINX_CONF="/etc/nginx/nginx.conf"
cat <<EOF > $NGINX_CONF
worker_processes auto;

events {
    worker_connections 1024;
}

http {
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    limit_conn_zone \$binary_remote_addr zone=conn_limit:10m;

    server {
        if (\$host = totmaxim.ru) {
            return 301 https://\$host\$request_uri;
        } # managed by Certbot

        listen 80;
        server_name totmaxim.ru;
        return 301 https://\$host\$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name totmaxim.ru;
        
        ssl_certificate /etc/letsencrypt/live/tot-maxim.ru/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/tot-maxim.ru/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
        
        gzip on;
        gzip_vary on;
        gzip_disable "MSIE [4-6]\.";
        gzip_types text/plain 
                   text/css 
                   application/json 
                   application/x-javascript 
                   text/xml 
                   application/xml 
                   application/xml+rss 
                   text/javascript 
                   application/javascript;

        location / {
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
            proxy_pass http://localhost:9090;
            limit_conn conn_limit 10;
        }
    }
}
EOF

# Перезапуск Nginx для применения изменений
systemctl restart nginx

# Проверка статуса Nginx
systemctl status nginx

echo "Nginx установлен и конфигурация применена."
