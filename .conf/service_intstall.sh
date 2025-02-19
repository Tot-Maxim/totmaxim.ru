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
#Requires=docker.service
#After=docker.service

[Service]
User=totuser
Restart=always
WorkingDirectory=/home/totuser/totmaxim.ru
ExecStart=/snap/bin/docker-compose --project-name tot-maxim up --remove-orphans
ExecStop=/snap/bin/docker-compose --project-name tot-maxim down
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

# Проверка статуса сервиса
if systemctl is-active --quiet tot-maxim-site.service; then
    echo "Сервис tot-maxim-site установлен и запущен."
else
    echo "Не удалось запустить сервис tot-maxim-site. Проверьте журналы ошибок."
    systemctl status tot-maxim-site.service
    journalctl -xe
fi
