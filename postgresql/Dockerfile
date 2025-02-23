# Используем официальный образ PostgreSQL 17 в качестве базового
FROM postgres:17

# Устанавливаем необходимые пакеты
RUN apt-get update && \
    apt-get install -y wget curl && \
    curl -LO https://github.com/prometheus-community/postgres_exporter/releases/download/v0.16.0/postgres_exporter-0.16.0.linux-amd64.tar.gz && \
    tar -xzf postgres_exporter-0.16.0.linux-amd64.tar.gz && \
    mv postgres_exporter-0.16.0.linux-amd64/postgres_exporter /usr/local/bin/ && \
    chmod +x /usr/local/bin/postgres_exporter && \
    rm -rf postgres_exporter-0.16.0.linux-amd64.tar.gz postgres_exporter-0.16.0.linux-amd64

# Устанавливаем переменные окружения
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD
ARG POSTGRES_DB

# Копируем скрипты инициализации в директорию
COPY init-db/ /docker-entrypoint-initdb.d/

# Порты
EXPOSE 5432
EXPOSE 9187
