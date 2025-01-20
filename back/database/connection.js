import { sequelize } from '../models/index.js';




const dbConnect =  async () => {
    try {
        await sequelize.authenticate();
        console.log("Connection has been established with the database successfully.");
    } catch (error) {
        console.error("Unable to connect to the database: ", error);
    }
}



// export default dbConnect;
export default dbConnect ;