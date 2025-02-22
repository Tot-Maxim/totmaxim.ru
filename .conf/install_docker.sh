#!/bin/bash

# Проверяем, запущен ли скрипт с правами суперпользователя
if [ "$(id -u)" -ne 0 ]; then
    echo "Необходимы права суперпользователя. Пожалуйста, выполните скрипт с использованием sudo."
    exit 1
fi

# Установка Docker
echo "Установка Docker..."
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Добавляем GPG ключ Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Добавляем репозиторий Docker
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Устанавливаем Docker
apt-get update
apt-get install -y docker-ce

# Проверка, что Docker устанавливался
if ! command -v docker &> /dev/null; then
    echo "Docker не был установлен успешно."
    exit 1
fi

# Установка Docker Compose
echo "Установка Docker Compose..."
DOCKER_COMPOSE_VERSION="1.29.2" # Замените на последнюю версию, если нужно
curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Присваиваем права на выполнение
chmod +x /usr/local/bin/docker-compose

# Проверка установки Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose не был установлен успешно."
    exit 1
fi

# Завершение установки
echo "Docker и Docker Compose установлены успешно."
docker --version
docker-compose --version
