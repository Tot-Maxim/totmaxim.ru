# Используем официальный образ Prometheus
FROM prom/prometheus:v2.34.0

# Копируем файл конфигурации Prometheus
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Экспонируем порт для Prometheus
EXPOSE 9090