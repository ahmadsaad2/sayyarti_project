'use strict';

import { readdirSync } from 'fs';
import { basename as _basename, join } from 'path';
import Sequelize, { DataTypes } from 'sequelize';
import { env as _env } from 'process';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import configJson from '../config/config.json' assert { type: 'json' };

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const basename = _basename(__filename);
const env = _env.NODE_ENV || 'development';
const config =  configJson[env];//require(__dirname + '/../config/config.json')[env];
const db = {};

let sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(_env[config.use_env_variable], config);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config);
}

readdirSync(__dirname)
  .filter(file => {
    return (
      file.indexOf('.') !== 0 &&
      file !== basename &&
      file.slice(-3) === '.js' &&
      file.indexOf('.test.js') === -1
    );
  })
  .forEach(async file => {
    const model = (await import(join(__dirname, file))).default(sequelize, DataTypes);
    // const model = require(join(__dirname, file))(sequelize, DataTypes);
    // const model = await import(join(__dirname, file));
    // const modelInstance = model.default(sequelize, DataTypes);
    db[model.name] = model;
  });

Object.keys(db).forEach(modelName => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

sequelize.sync({force:false})
.then(() =>{
  console.log('Database sunced');
})
.catch((err) => {
  console.log('Error while syncing database: ', err);
});

db.sequelize = sequelize;
db.Sequelize = Sequelize;

export default db;
