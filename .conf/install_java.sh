#!/bin/bash

# Проверяем, запущен ли скрипт с правами суперпользователя
if [ "$(id -u)" -ne 0 ]; then
    echo "Необходимы права суперпользователя. Пожалуйста, выполните скрипт с использованием sudo."
    exit 1
fi

# Проверяем, установлена ли Java
if type -p java; then
    echo "Java уже установлена. Версия:"
    java -version
else
    echo "Java не установлена. Начинаем установку OpenJDK 17..."

    # Обновляем списки пакетов
    apt update

    # Устанавливаем OpenJDK 17
    apt install -y openjdk-17-jdk

    # Проверяем успешность установки
    if [ $? -eq 0 ]; then
        echo "OpenJDK 17 установлен успешно!"
        echo "Версия Java:"
        java -version
    else
        echo "Ошибка при установке OpenJDK 17."
        exit 1
    fi
fi
