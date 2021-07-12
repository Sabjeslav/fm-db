DROP TABLE IF EXISTS users CASCADE;
/*
 Используя документацию добавьте поля birthday, isMale
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
    "weight" > 0
    AND "weight" < 500
  );
INSERT INTO users (
    firstname,
    lastname,
    email,
    is_male,
    birthday,
    height,
    weight
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