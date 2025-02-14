#!/bin/bash

# Имя файла сервиса
SERVICE_FILE="/etc/systemd/system/tot-maxim-site.service"

# Проверяем, запущен ли скрипт с правами суперпользователя
if [ "$(id -u)" -ne 0 ]; then
    echo "Необходимы права суперпользователя. Пожалуйста, выполните скрипт с использованием sudo."
    exit 1
fi

# Создаем файл сервиса
cat <<EOF > $SERVICE_FILE
[Unit]
Description=Tot Node.js App from totmaxim github
Requires=docker.service
After=docker.service

[Service]
Restart=always
WorkingDirectory=/home/maxim/pet-proj/totmaxim.ru
ExecStart=/usr/bin/docker compose --project-name tot-maxim up --remove-orphans
ExecStop=/usr/bin/docker compose --project-name tot-maxim down
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Перезагружаем конфигурацию systemd
systemctl daemon-reload

# Включаем сервис на старте системы
systemctl enable tot-maxim-site.service

# Запускаем сервис
systemctl start tot-maxim-site.service

echo "Сервис tot-maxim-site установлен и запущен."
