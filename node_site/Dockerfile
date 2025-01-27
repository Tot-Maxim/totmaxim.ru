# Используем официальный образ Node.js
FROM node:14.21.3

# Создание каталога приложения
RUN mkdir -p /home/my_node_js/app

# Устанавливаем рабочую директорию
WORKDIR /home/my_node_js/app

# Копируем файл package*.json
COPY package*.json ./

# Установка зависимостей
RUN npm install

# Копируем все остальные файлы в контейнер
COPY --chown=node:node . .

# Открываем порт, если необходимо (например, порт 3000)
EXPOSE 3000

# Изменение пользователя
USER node

# Команда для запуска приложения
CMD ["npm", "start"]
