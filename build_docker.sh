#!/bin/bash

# Остановка службы my-node-js-app
sudo systemctl stop tot-maxim-site.service

# Очистка Docker-системы
docker system prune -f

# Остановка и удаление всех контейнеров, сетей, томов и образов проекта tot-maxim
docker compose --project-name tot-maxim down --rmi all

# Сборка контейнеров проекта tot-maxim
docker compose --project-name tot-maxim build

# Перезагрузка конфигурации systemd
sudo systemctl daemon-reload

# Запуск службы my-node-js-app
sudo systemctl start tot-maxim-site.service

echo "Сервис tot-maxim-site запущен."
## sudo systemctl disable postgresql.service
## sudo systemctl start postgresql.service
