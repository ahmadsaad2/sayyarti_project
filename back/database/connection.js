import {Sequelize} from 'sequelize';

const sequelize = new Sequelize("sayyarati", 'root', '', {
    host: '127.0.0.1',
    dialect: "mysql",
    logging: false, // enable when needed for debuging :p
});

const dbConnect =  async () => {
    try {
        await sequelize.authenticate();
        console.log("Connection has been established with the database successfully.");
    } catch (error) {
        console.error("Unable to connect to the database: ", error);
    } 
}



// export default dbConnect;
export { sequelize, dbConnect };