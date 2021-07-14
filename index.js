const { loadUsers } = require('./api');
const { User, client } = require('./models');

(async () => {
  await client.connect();

  await User.createTableIfNotExist();
  /*const users = await loadUsers();
  const result = await User.bulkCreate(users);

  console.log(result);*/

  const deletedUser = await User.deleteById(51);
  console.log(deletedUser);

  /*const foundUsers = await User.findAll();
  console.log(foundUsers);*/

  await client.end();
})();
