const express = require('express');
const cookieParser = require('cookie-parser');
const dotenv = require('dotenv');
const Path = require('path');
const { mysqlConnection} = require('./src/dbconnection');
dotenv.config();
const app=express();


app.use(cookieParser());
app.set('views', Path.join(__dirname, './src/views'));
app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: false }));
app.use(express.static(Path.join(__dirname, '/public')));
app.use('/', require('./src/routers/router'));


app.listen(process.env.app_port_no, () => {
    console.log('Server is running on port', process.env.app_port_no);
});