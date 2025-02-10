# Базовый образ с PostgreSQL
FROM postgres:latest

# Копируйте файлы инициализации базы данных в контейнер
COPY init-db/ /docker-entrypoint-initdb.d/
