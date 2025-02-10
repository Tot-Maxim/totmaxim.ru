# Используем официальный образ PostgreSQL 17 в качестве базового
FROM postgres:17

# Устанавливаем переменные окружения
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB

# Копируем скрипты инициализации в директорию
COPY init-db/ /docker-entrypoint-initdb.d/

# Порты
EXPOSE 5432
