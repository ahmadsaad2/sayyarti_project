import express from 'express';
import dbConnect from './database/connection.js';
import { sequelize } from './models/index.js';
import dotenv from 'dotenv';
import initModels from './models/init-models.js';


dotenv.config();


//import routes
import authentication from './src/routes/authentication/auth.js';
import admin from './src/routes/admin/admin.js';
import user from './src/routes/user/user.js';
import companyRoutes from './src/routes/COMPAN/companyroutes.js';
import employeesRoutes from './src/routes/COMPAN/employeeroutes.js';
import workAssignmentRoutes from './src/routes/COMPAN/workassigmentsroutes.js';

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
app.use('/admin', admin);
app.use('/user', user);
app.use('/api/company', companyRoutes);
app.use('/api/employees', employeesRoutes);
app.use('/api/workassignments', workAssignmentRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`server is running on port :${PORT}`);
})
