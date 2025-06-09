const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'terraform-20250609085312416700000004.cib03qptj6yg.us-east-1.rds.amazonaws.com',
  user: 'admin',
  password: 'admin1234',
  database: 'appointments',
  port: 3306

});
connection.connect();
module.exports = connection;