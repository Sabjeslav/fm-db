const { Client } = require('pg');
const { loadUsers } = require('./api');

const config = {
  user: 'postgres',
  password: 'postgres',
  host: 'localhost',
  port: 5432,
  database: 'fm_example',
};

const dbClient = new Client(config);

(async () => {
  await dbClient.connect();
  const users = await loadUsers();

  const result = await dbClient.query(
    `INSERT INTO "users" ("firstname", "lastname", "email", "is_male", "birthday")
     VALUES ${extractUsers(users)}
    `
  );

  console.log(extractUsers(users));
  console.log(result);

  await dbClient.end();
})();

function extractUsers (users) {
  return users
    .map(
      ({ name: { first, last }, email, dob: { date }, gender }) =>
        `('${first}', '${last}', '${email}', '${gender === 'male'}', '${date}')`
    )
    .join(',');
}
