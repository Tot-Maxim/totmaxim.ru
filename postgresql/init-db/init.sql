-- Проверка на существование базы данных и создание, если она не существует
DO
$$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_database
        WHERE datname = 'totdatabase') THEN
        EXECUTE 'CREATE DATABASE totdatabase';
    END IF;
END
$$;

-- Проверка и создание пользователя
DO
$$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_roles
        WHERE rolname = 'totuser') THEN
        EXECUTE 'CREATE USER totuser WITH PASSWORD ''5471721488''';
    END IF;
END
$$;

-- Подключение к базе данных totdatabase для создания таблицы
\connect totdatabase

-- Создание таблицы occasion, если она не существует
CREATE TABLE IF NOT EXISTS occasion (
    id SERIAL PRIMARY KEY,
    occasion_description TEXT NOT NULL
);

-- Изменение владельца таблицы на totuser, если необходимо
ALTER TABLE occasion OWNER TO totuser;

-- Предоставление прав на таблицу
GRANT ALL PRIVILEGES ON TABLE occasion TO totuser;

-- Создание последовательности и привязка ее к колонке id таблицы
DO
$$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_sequences
        WHERE sequencename = 'occasion_id_seq') THEN
        EXECUTE 'CREATE SEQUENCE occasion_id_seq OWNED BY occasion.id';
    END IF;
END
$$;

-- Установление значения по умолчанию для id
ALTER TABLE occasion ALTER COLUMN id SET DEFAULT nextval('occasion_id_seq');

-- Предоставление прав пользователю totuser на базу данных и последовательность
GRANT ALL PRIVILEGES ON DATABASE totdatabase TO totuser;
GRANT USAGE, SELECT ON SEQUENCE occasion_id_seq TO totuser;
GRANT INSERT ON TABLE occasion TO totuser;  -- Включите явное предоставление права на INSERT
