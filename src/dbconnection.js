const mongoose = require('mongoose');
const dotenv = require('dotenv');
const mysql = require('mysql2');
dotenv.config();

const mysqlConnection = mysql.createConnection({
    host: process.env.sql_host,
    user: process.env.sql_user,
    password: process.env.sql_pass,
    database: process.env.sql_name,
    port: process.env.sql_port,
  });

mysqlConnection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL database:', err.message);
        return;
    }
    console.log('Connected to the MySQL database');
});

const connectToMongoDB = async () => {
    try {
        await mongoose.connect(process.env.dburl, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
        console.log('Connected to the MongoDB database');
    } catch (error) {
        console.error('Error connecting to MongoDB:', error.message);
    }
};
connectToMongoDB();

module.exports = {
    mysqlConnection,
    mongoose, 
};