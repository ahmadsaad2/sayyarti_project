const mysql = require('mysql2/promise');

const db = mysql.createPool({
    host: 'database-sayyarti.cn4w60ig0sw0.eu-north-1.rds.amazonaws.com',
    user: 'admin',
    password: 'admin12345',
    database: 'sayyarti',
    port: 3306,
    timezone: '+03:00'
});
module.exports = db;
