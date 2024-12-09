import { Sequelize } from 'sequelize';
import initModels from './init-models.js'; 

// Initialize Sequelize instance
const sequelize = new Sequelize("sayyarati", 'root', '', {
  host: '127.0.0.1',
  dialect: "mysql",
  logging: false, // enable when needed for debuging :
});

// Initialize all models
const models = initModels(sequelize);


export { sequelize };
export default models;
