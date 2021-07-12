const { Client } = require('pg');
const User = require('./User');

const config = {
  user: 'postgres',
  password: 'postgres',
  host: 'localhost',
  port: 5432,
  database: 'fm_example',
};

const dbClient = new Client(config);

User._client = dbClient;

module.exports = {
  User,
  client: dbClient,
};
