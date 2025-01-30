import express from 'express';
import cors from 'cors';
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
import servicesRoutes from './src/routes/COMPAN/servicesRoutes.js';
import offersRoutes from './src/routes/COMPAN/offerRoutes.js';
import reviewsRoutes from './src/routes/COMPAN/reviewsRoutes.js';
import employesRoutes from './src/routes/employee/employesRoutes.js';
import bookingroutes from './src/routes/COMPAN/bookingroutes.js';
import taskroutes from './src/routes/COMPAN/taskroutes.js';
dbConnect();


sequelize.sync({ alter: false, }) // Use { force: true } if you want to recreate tables
    .then(() => {
        console.log('All tables have been synchronized successfully.');
    })
    .catch((error) => {
        console.error('Error synchronizing tables:', error);
    });



//init app
const app = express();
app.use(cors());
app.use(express.json());
// Routes
app.use('/auth', authentication);
app.use('/admin', admin);
app.use('/user', user);
app.use('/api/company', companyRoutes);
app.use('/api/employees', employeesRoutes);
app.use('/api/workassignments', workAssignmentRoutes);
app.use('/api/services', servicesRoutes);
app.use('/api/offers', offersRoutes);
app.use('/api/reviews', reviewsRoutes);
app.use('/api/employee', employesRoutes);
app.use('/api/tasks', taskroutes);
app.use('/api/bookings', bookingroutes);
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`server is running on port :${PORT}`);
})
