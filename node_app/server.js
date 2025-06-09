const express = require('express');
const bodyParser = require('body-parser');
const connection = require('./db');
const app = express();
 
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(__dirname));
 
// Create database and table if not exist
connection.query(`CREATE DATABASE IF NOT EXISTS appointments`, (err) => {
  if (err) throw err;
  connection.changeUser({ database: 'appointments' }, (err) => {
    if (err) throw err;
 
    const tableQuery = `
      CREATE TABLE IF NOT EXISTS appointments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        email VARCHAR(100),
        phone VARCHAR(15),
        date DATE
      )
    `;
    connection.query(tableQuery, (err) => {
      if (err) throw err;
      console.log("Database and table ready ✅");
    });
  });
});
 
app.post('/submit', (req, res) => {
  const { name, email, phone, date } = req.body;
  const sql = 'INSERT INTO appointments (name, email, phone, date) VALUES (?, ?, ?, ?)';
  connection.query(sql, [name, email, phone, date], (err, result) => {
    if (err) {
      console.error("Insert error: ", err);
      res.send("Error saving appointment.");
    } else {
      res.send("Appointment booked successfully!");
    }
  });
});
 
app.listen(3000, () => {
console.log('Server is running on http://localhost:3000');
});