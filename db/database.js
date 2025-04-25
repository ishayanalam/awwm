const { DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME } = process.env;
const mysql = require("mysql2");

const conn = mysql.createConnection({
  host: DB_HOST,
  user: DB_USERNAME,
  password: DB_PASSWORD,
  database: DB_NAME,
});

conn.connect((err) => {
  if (err) throw err;
  console.log("Database connected!");
});

module.exports = conn; // to use in other files
