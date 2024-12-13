import express from 'express';
import dbConnect from './database/connection.js';
import { sequelize } from './models/index.js';
import dotenv from 'dotenv';
import initModels from './models/init-models.js';


dotenv.config();


//import routes
import authentication from './src/routes/authentication/auth.js';


//connection to database and sync the tables
dbConnect();


sequelize.sync({ alter: true }) // Use { force: true } if you want to recreate tables
    .then(() => {
        console.log('All tables have been synchronized successfully.');
    })
    .catch((error) => {
        console.error('Error synchronizing tables:', error);
    });



//init app
const app = express();

app.use(express.json());
// Routes
app.use('/auth', authentication);


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`server is running on port :${PORT}`);
})