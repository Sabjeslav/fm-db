DROP TABLE IF EXISTS users CASCADE;
/*
 Используя документацию добавьте поля birthday, isMale
 */
/*
 VARCHAR(3)
 "123"45
 "1"
 
 CHAR(3)
 "123"45
 "1  "
 
 */
/* */
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(64) NOT NULL CHECK(firstname != ''),
  lastname VARCHAR(64) NOT NULL CHECK(lastname != ''),
  email VARCHAR(256) NOT NULL CHECK(email != ''),
  is_male BOOLEAN NOT NULL,
  birthday DATE NOT NULL CHECK(birthday < CURRENT_DATE),
  height NUMERIC(3, 2) CHECK(
    height > 0.2
    AND height < 3
  )
);
/* */
ALTER TABLE "users"
ADD UNIQUE("email");
/* */
ALTER TABLE "users"
ADD CONSTRAINT "custom_check" CHECK("height" > 0.5);
/* */
ALTER TABLE "users" DROP CONSTRAINT "custom_check";
/* */
ALTER TABLE "users"
ADD "weight" NUMERIC(5, 2) CHECK(
    "weight" BETWEEN 1 AND 500
  );
/* */
INSERT INTO "users" (
    "firstname",
    "lastname",
    "email",
    "is_male",
    "birthday",
    "height",
    "weight"
  )
VALUES (
    'Test',
    'Testovich',
    'test1@mail.com',
    TRUE,
    '1980-01-01',
    2,
    15
  ),
  (
    'Test',
    'Testovich',
    'test2@mail.com',
    TRUE,
    '1980-01-01',
    1.5,
    150
  ),
  (
    'Test',
    'Testovich',
    'test3@mail.com',
    TRUE,
    '1980-01-01',
    1,
    200
  );
/* */
DROP TABLE IF EXISTS a;
/* */
CREATE TABLE a (b INT, c INT, PRIMARY KEY (b, c));
INSERT INTO a
VALUES (1, 1),
  (1, 2),
  (2, 1),
  (1, 3);
/* */
DROP TABLE IF EXISTS "products" CASCADE;
/* */
CREATE TABLE "products" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(256) NOT NULL CHECK("name" != ''),
  "category" VARCHAR(128) NOT NULL CHECK("category" != ''),
  "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
  UNIQUE ("name", "category")
);
/*
 samsung phones
 xiaomi  phones
 samsung laptops
 */
/* */
DROP TABLE IF EXISTS "orders" CASCADE;
CREATE TABLE "orders" (
  "id" BIGSERIAL PRIMARY KEY,
  "customer_id" INTEGER NOT NULL CHECK("customer_id" > 0) REFERENCES "users" ("id"),
  "is_done" BOOLEAN NOT NULL DEFAULT FALSE,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/* */
DROP TABLE IF EXISTS "products_to_orders";
/* */
CREATE TABLE "products_to_orders" (
  "order_id" BIGINT REFERENCES "orders" ("id"),
  "product_id" INTEGER REFERENCES "products" ("id"),
  "quantity" INTEGER CHECK("quantity" > 0),
  PRIMARY KEY ("order_id", "product_id")
);
/*
 chats:
 chat_name,
 description
 
 users,
 
 users_to_chats
 */
/* */
DROP TABLE IF EXISTS "chats" CASCADE;
/* */
CREATE TABLE "chats" (
  "id" BIGSERIAL PRIMARY KEY,
  "owner_id" INTEGER NOT NULL REFERENCES "users" ("id"),
  "name" VARCHAR(64) NOT NULL CHECK("name" != ''),
  "description" VARCHAR(512) CHECK("description" != '')
);
/* */
DROP TABLE IF EXISTS "users_to_chats" CASCADE;
/* */
CREATE TABLE "users_to_chats" (
  "chat_id" BIGINT REFERENCES "chats"("id"),
  "user_id" INTEGER REFERENCES "users"("id"),
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("chat_id", "user_id")
);
/* */
DROP TABLE IF EXISTS "messages";
/* */
CREATE TABLE "messages" (
  "id" BIGSERIAL PRIMARY KEY,
  "body" VARCHAR(2048) NOT NULL CHECK("body" != ''),
  "author_id" INTEGER NOT NULL,
  "chat_id" BIGINT NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "isRead" BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY ("chat_id", "author_id") REFERENCES "users_to_chats" ("chat_id", "user_id")
);
/*
 КОНТЕНТ: имя, описание,
 РЕАКЦИИ: isLiked
 */
DROP TABLE "content" CASCADE;
CREATE TABLE "content" (
  "id" SERIAL PRIMARY KEY,
  "owner_id" INTEGER NOT NULL REFERENCES "users"("id"),
  "name" VARCHAR(255) NOT NULL CHECK("name" != ''),
  "description" TEXT
);
/* */
DROP TABLE "reactions";
CREATE TABLE "reactions" (
  "content_id" INTEGER REFERENCES "content"("id"),
  "user_id" INTEGER REFERENCES "users"("id"),
  "is_liked" BOOLEAN,
  PRIMARY KEY ("content_id", "user_id")
);
/*1:1*/
CREATE TABLE "coach" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(128)
);
CREATE TABLE "teams" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(128),
  "coach_id" INTEGER NOT NULL REFERENCES "coach"("id")
);
ALTER TABLE "coach"
ADD COLUMN "team_id" INTEGER REFERENCES "teams"("id");
/*
 CRUD      SQL
 
 CREATE    INSERT - manipulation
 READ      SELECT - query
 UPDATE    UPDATE - manipulation 
 DELETE    DELETE - manipulation
 
 */
SELECT *
FROM "users"
WHERE "is_male" = FALSE;
/* ВСЕ ЮЗЕРЫ С ЧЕТНЫМИ ID */
SELECT *
FROM "users"
WHERE "id" % 2 = 0;
/* ВСЕ ЮЗЕРЫ МУЖСКОГО ПОЛА С НЕЧЕТНЫМИ ID */
SELECT "id",
  "firstname",
  "lastname",
  "email"
FROM "users"
WHERE "is_male" = TRUE
  AND "id" % 2 = 1;
/* */
SELECT *
FROM "users"
WHERE "firstname" = 'Sophia';
/* */
UPDATE "users"
SET "height" = 1.75
WHERE "firstname" = 'Sophia'
RETURNING "id",
  "firstname",
  "height";
/* */
UPDATE "users"
SET "firstname" = 'Test',
  "lastname" = 'Testovich'
WHERE "id" = 2000;
/* */
SELECT *
FROM "users"
WHERE "id" = 2000;
/* */
DELETE FROM "users"
WHERE "id" = 2099
RETURNING *;

/*
 1. get all men
 2. get all women
 3. get all adult users (> 30 y)
 4. get all adult women (> 30 y)
 5. get all users age >= 20 & age <= 40
 6. get all users with age > 20 & height > 1.8
 7. get all users: were born September
 8. get all users: were born 1 November
 9. delete all with age < 30
 */
/* */
SELECT *
FROM "users"
WHERE AGE("birthday") < MAKE_INTERVAL(25);
/* */
SELECT *
FROM "users"
WHERE AGE("birthday") BETWEEN MAKE_INTERVAL(25) AND MAKE_INTERVAL(27);
/* */
SELECT *
FROM "users"
WHERE EXTRACT(
    MONTH
    FROM "birthday"
  ) = 9;
/* */
SELECT "id" AS "Порядковый номер",
  "firstname" AS "Имя",
  "lastname" AS "Фамилия",
  "email" AS "Почта"
FROM "users" AS "u"
WHERE "u"."id" = 1500;
/* PAGINATION */
SELECT "id",
  "firstname",
  "lastname",
  "email"
FROM "users"
LIMIT 15 OFFSET 45;
/*
  offset = limit * page index
  15 * 0 = 0  first page
  15 * 1 = 15 second page

*/
/* */
SELECT "id",
  CONCAT("firstname", ' ', "lastname") AS "fullname",
  "email"
FROM "users"

/* Получить всех пользователей с длиной fullname больше 15 символов */