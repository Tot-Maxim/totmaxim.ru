# Используем официальный образ Java
FROM openjdk:17 AS build

# Устанавливаем рабочую директорию
WORKDIR /home/node/occasion

# Копируем файл jar
COPY target/occasion_api-1.0.1.jar occasion.jar

# Открываем порт
EXPOSE 3040

# Команда для запуска приложения
CMD ["java", "-jar", "occasion.jar"]