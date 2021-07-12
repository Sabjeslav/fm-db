module.exports.extractUsers = function (users) {
  return users
    .map(
      ({ name: { first, last }, email, dob: { date }, gender }) =>
        `('${first}', '${last}', '${email}', '${gender === 'male'}', '${date}')`
    )
    .join(',');
}
