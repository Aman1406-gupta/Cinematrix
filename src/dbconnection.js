const dotenv = require('dotenv');
const mysql = require('mysql2');
dotenv.config();

const mysqlConnection = mysql.createConnection({
    host: process.env.sql_host,
    user: process.env.sql_user,
    password: process.env.sql_pass,
    database: process.env.sql_name,
    port: process.env.sql_port,
    multipleStatements: true
  });

mysqlConnection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL database:', err.message);
        return;
    }
    console.log('Connected to the MySQL database');
});

module.exports = {
    mysqlConnection
};