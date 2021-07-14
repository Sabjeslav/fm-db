const { extractUsers } = require('../utils');

class User {
  static _client = null;
  static _tableName = 'users';

  static async createTableIfNotExist () {
    return await this._client.query(`
    CREATE TABLE IF NOT EXISTS ${this._tableName} (
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
    `);
  }

  static async findAll () {
    return await this._client.query(`SELECT * FROM ${this._tableName}`);
  }

  static async bulkCreate (users) {
    return await this._client.query(
      `INSERT INTO "${this._tableName}" ("firstname", "lastname", "email", "is_male", "birthday")
       VALUES ${extractUsers(users)}
      `
    );
  }

  static async deleteById (id) {
    return await this._client.query(
      `DELETE FROM "${this._tableName}"
       WHERE "id" = ${id}
       RETURNING *;
      `
    );
  }
}

module.exports = User;
