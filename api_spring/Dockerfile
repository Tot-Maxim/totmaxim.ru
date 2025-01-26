# Используем официальный образ Java
FROM openjdk:17 AS build

# Устанавливаем рабочую директорию
WORKDIR /home/node/api

# Копируем файл jar
COPY /target/Cow_and_Bull_API-1.0.1.jar api.jar

# Открываем порт, если необходимо (например, порт 8080)
EXPOSE 3030

# Команда для запуска приложения
CMD ["java", "-jar", "api.jar"]