import express, { json, urlencoded } from 'express';
import axios from 'axios';
import cors from 'cors';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
const app = express();

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

app.use(cors({ 
    origin: 'http://localhost:3000',
    methods: ['GET', 'POST'],
    credentials: true
}));
app.use(json());

app.set('views', join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(express.static(join(__dirname, 'public')));
app.use(urlencoded({ extended: true }));

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
        console.error(error);
        res.render('error', { message: 'Ошибка при запуске игры.' });
    }
});

let gameState = {};

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
        console.error(error);
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
        console.error("Ошибка при обработке догадки:", error.response ? error.response.data : error.message);
        res.status(500).json({ message: 'Ошибка при обработке догадки.' });
    }
});


app.get('/win', (req, res) => {
    const secretNumber = req.query.secretNumber; // Получите номер секрета из запроса
    res.render('win', { secretNumber });
});


app.get('/lose', (req, res) => {
    const secretNumber = req.query.secretNumber;
    res.render('lose', { secretNumber });
});

// Маршрут для разработки
app.get('/dev', (req, res)  => {
    res.render('dev');
});

// Запуск сервера
app.listen(3000, () => {
    console.log('Сервер запущен на http://localhost:3000/');
});
