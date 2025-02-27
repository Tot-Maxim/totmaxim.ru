#!/bin/bash

# Убедитесь, что скрипт запускается с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)."
  exit
fi

# Установка необходимых пакетов
apt update
apt install -y python3.12-venv python3-pip

# Проверка существования requirements.txt
if [ ! -f requirements.txt ]; then
    echo "Файл requirements.txt не найден. Пожалуйста, создайте его."
    exit 1
fi

# Создание виртуального окружения
python3 -m venv .venv

sudo apt install pipx

pipx ensurepath

# Активируем виртуальное окружение
source .venv/bin/activate

# Установка зависимостей из requirements.txt
pip install --upgrade pip
pip install -r requirements.txt

# Деактивируем виртуальное окружение
deactivate

# Обновляем shell
source ~/.bashrc

# Снова активируем виртуальное окружение для проверки установки
source .venv/bin/activate

# Проверка установленного Ansible
ansible --version
