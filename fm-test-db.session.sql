DROP TABLE users;
/*
 Используя документацию добавьте поля birthday, isMale
 */
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(64) NOT NULL CHECK(firstname != ''),
  lastname VARCHAR(64) NOT NULL CHECK(lastname != ''),
  email VARCHAR(256) NOT NULL UNIQUE CHECK(email != ''),
  is_male BOOLEAN NOT NULL,
  birthday DATE NOT NULL CHECK(birthday < CURRENT_DATE),
  height NUMERIC(3, 2) NOT NULL CHECK(
    height > 0.2
    AND height < 3
  )
);
INSERT INTO users (
    firstname,
    lastname,
    email,
    is_male,
    birthday,
    height
  )
VALUES (
    'Test',
    'Testovich',
    'test1@mail.com',
    TRUE,
    '1980-01-01',
    2
  ),
  (
    'Test',
    'Testovich',
    'test2@mail.com',
    TRUE,
    '1980-01-01',
    1.5
  ),
  (
    'Test',
    'Testovich',
    'test3@mail.com',
    TRUE,
    '1980-01-01',
    1
  );
/*
 Создать таблицу messages
 id,
 body - текстовый тип,
 author - текстовый тип
 createdAt - timestamp
 isRead - логическое значение
 */
DROP TABLE "messages";
CREATE TABLE "messages" (
  "id" BIGSERIAL PRIMARY KEY,
  "body" VARCHAR(2048) NOT NULL CHECK("body" != ''),
  "author" VARCHAR(64) NOT NULL CHECK("author" != ''),
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "isRead" BOOLEAN NOT NULL DEFAULT FALSE
);
INSERT INTO "messages" ("body", "author")
VALUES ('Fisrt message', 'test'),
  ('Hello', 'John');
DROP TABLE a;
CREATE TABLE a (b INT, c INT, PRIMARY KEY (b, c));
INSERT INTO a
VALUES (1, 1),
  (1, 2),
  (2, 1),
  (1, 3);