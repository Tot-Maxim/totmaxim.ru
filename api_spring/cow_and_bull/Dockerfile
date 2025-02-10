# Используем официальный образ с Maven для сборки
FROM maven:3.8.4-openjdk-17 AS build

# Устанавливаем рабочую директорию
WORKDIR /home/node/api

# Копируем pom.xml и файлы зависимостей 
COPY pom.xml ./
COPY src ./src

# Собираем проект
RUN mvn clean install -DskipTests

# Используем официальный образ Java для выполнения
FROM openjdk:17

# Устанавливаем рабочую директорию
WORKDIR /home/node/api

# Копируем файл jar из предыдущего этапа сборки
COPY --from=build /home/node/api/target/Cow_and_Bull_API-1.0.1.jar api.jar

# Открываем порт
EXPOSE 3030

# Команда для запуска приложения
CMD ["java", "-jar", "api.jar"]
