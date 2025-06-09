const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'YOUR_RDS_ENDPOINT', // Replace via Jenkins or use env var
  user: 'admin',
  password: 'admin1234',
  database: 'appointments'
});
connection.connect();
module.exports = connection;