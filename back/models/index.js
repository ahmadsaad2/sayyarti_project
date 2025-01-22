import { Sequelize } from 'sequelize';
import initModels from './init-models.js';
import dotenv from 'dotenv';

dotenv.config();

// Initialize Sequelize instance
const sequelize = new Sequelize(process.env.DATABASE_NAME, process.env.DATABASE_USER, process.env.DATABASE_PASSWORD, {
  host: process.env.DATABASE_URL,
  port: process.env.DATABASE_PORT,
  dialect: "mysql",
  dialectOptions:{
    ssl:{
      require: true,
      rejectUnauthorized: false
    }
  },
  logging: false, // enable when needed for debuging :
});

// Initialize all models
const models = initModels(sequelize);


export { sequelize };
export default models;
