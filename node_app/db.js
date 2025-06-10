const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'terraform-20250610115548896700000004.cngjj96fwynm.us-east-1.rds.amazonaws.com',
  user: 'admin',
  password: 'admin1234',
  database: 'appointments',
  port: 3306

});
connection.connect();
module.exports = connection;