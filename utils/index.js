function getRandomArbitrary (min, max) {
  return Math.random() * (max - min) + min;
}
function extractUsers (users) {
  return users
    .map(
      ({ name: { first, last }, email, dob: { date }, gender }) =>
        `($$${first}$$, $$${last}$$, $$${email}$$, '${gender ===
          'male'}', '${date}', ${getRandomArbitrary(
          1,
          2.5
        )}, ${getRandomArbitrary(1, 500)} )`
    )
    .join(',');
}

module.exports = {
  getRandomArbitrary,
  extractUsers,
};
