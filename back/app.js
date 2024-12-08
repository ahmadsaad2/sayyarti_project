import express from 'express';
import {sequelize,dbConnect} from './database/connection.js';
import dotenv from 'dotenv';
import initModels from './models/init-models.js';
import { Sequelize } from 'sequelize';


dotenv.config();


//import routes
//TODO

//connection to database and sync the tables
dbConnect();

const models = initModels(sequelize);  

sequelize.sync({ alter: false }) // Use { force: true } if you want to recreate tables
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
// TODO when imported after done with the sequelizer


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`server is running on port :${PORT}`);
})