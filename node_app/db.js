const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'terraform-20250609070906694100000002.clvc3zyttfjo.us-east-1.rds.amazonaws.com:3306',
  user: 'admin',
  password: 'admin1234',
  database: 'appointments'
});
connection.connect();
module.exports = connection;