import express, { json, urlencoded } from 'express';
import axios from 'axios';
import cors from 'cors';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import pkg from 'pg';
const { Client } = pkg;
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Настройки порта
const port = 3000;

// Конфигурация CORS
app.use(cors({ 
    origin: 'http://localhost:3000',
    methods: ['GET', 'POST'],
    credentials: true
}));

// Парсинг JSON и URL-кодированных данных
app.use(json());
app.use(urlencoded({ extended: true }));

// Настройки шаблонов
app.set('views', join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Статика
app.use(express.static(join(__dirname, 'public')));

// Подключение к базе данных PostgreSQL
const client = new Client({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT,
});

client.connect()
    .then(() => console.log('Подключено к PostgreSQL'))
    .catch(err => console.error('Ошибка подключения к PostgreSQL', err));

// Корневой маршрут для главной страницы
app.get('/', (req, res) => {
    res.render('index');
});

// Начать новую игру
app.get('/start_game', async (req, res) => {
    try {
        await axios.post('http://java-api:3030/api/game/start');
        res.redirect('/game');
    } catch (error) {
        console.error('Ошибка при запуске игры:', error);
        res.render('error', { message: 'Ошибка при запуске игры.' });
    }
});

// Получить статус игры
app.get('/game', async (req, res) => {
    try {
        const response = await axios.get('http://java-api:3030/api/game/status');
        res.render('game', {
            secretNumber: response.data.secretNumber,
            trying: response.data.trying,
            attemptsLeft: response.data.attemptsLeft
        });
    } catch (error) {
        console.error('Ошибка при получении статуса игры:', error);
        res.render('error', { message: 'Ошибка при получении статуса игры.' });
    }
});

// Сделать догадку
app.post('/guess', async (req, res) => {
    const guess = req.body.guess;
    try {
        const response = await axios.get('http://java-api:3030/api/game/guess', { params: { guess } });
        const gameResponse = response.data;

        if (gameResponse.status === 'win') {
            return res.json({ status: 'win', secretNumber: gameResponse.secretNumber });
        } else if (gameResponse.status === 'lose') {
            return res.json({ status: 'lose', secretNumber: gameResponse.secretNumber });
        } else if (gameResponse.status === 'continue') {
            const result = {
                cows: gameResponse.cows,
                bulls: gameResponse.bulls,
                attemptsLeft: gameResponse.attemptsLeft,
                trying: gameResponse.trying
            };
            return res.json({ status: 'continue', ...result });
        }
    } catch (error) {
        console.error('Ошибка при обработке догадки:', error);
        res.status(500).json({ message: 'Ошибка при обработке догадки.' });
    }

    return res.status(400).json({ message: 'Некорректная догадка.' });
});

// Эндпоинт для заполнения базы данных
app.post('/api/populate', async (req, res) => {
    try {
        const tasks = Array.from({ length: 1000 }, (_, index) => `вы выбрали ${index + 1} задачу`);
        const queries = tasks.map(task => {
            return client.query('INSERT INTO occasion (occasion_description) VALUES ($1)', [task]);
        });

        await Promise.all(queries);
        res.send('1000 задач добавлено!');
    } catch (error) {
        console.error('Ошибка при заполнении базы данных:', error);
        res.status(500).send('Ошибка при обращении к базе данных');
    }
});

// Эндпоинт для очистки таблицы
app.post('/api/clear', async (req, res) => {
    try {
        await client.query('DELETE FROM occasion');
        await client.query('ALTER SEQUENCE occasion_id_seq RESTART WITH 1');
        res.send('Все строки удалены и последовательность сброшена!');
    } catch (error) {
        console.error('Ошибка при удалении строк:', error);
        res.status(500).send('Ошибка при обращении к базе данных');
    }
});

// Дополнительные маршруты для выигрыша и поражения
app.get('/win', (req, res) => {
    const secretNumber = req.query.secretNumber;
    res.render('win', { secretNumber });
});

app.get('/lose', (req, res) => {
    const secretNumber = req.query.secretNumber;
    res.render('lose', { secretNumber });
});

// Маршрут для загрузки случайного числа
app.get('/api/random/:number', async (req, res) => {
    const number = req.params.number;

    try {
        const response = await axios.get(`http://java-occasion:3040/random/${number}`);
        res.send(response.data);
    } catch (error) {
        console.error('Ошибка при запросе к Java API:', error);
        res.status(500).send('Пока что, нечего тут смотреть');
    }
});

// Маршрут для разработки
app.get('/dev', (req, res) => {
    res.render('dev', {
        posts: [
            "Пост 1: Это пример рыбы текста, который заполняет контент поста. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            "Пост 2: Второй пост следует той же теме, добавляя больше рыбы текста. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            "Пост 3: Третий пост продолжает тему с рифмами. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        ]
    });
});

// Маршрут для случайной страницы
app.get('/random', (req, res) => {
    res.render('random');
});

// Запуск сервера
app.listen(port, () => {
    console.log(`Сервер запущен на http://localhost:${port}`);
});
