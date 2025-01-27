import { Router } from 'express';
import models from '../../../models/index.js';

import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAdmin } from '../../middleware/userVerification.js';
import { Sequelize } from 'sequelize';

dotenv.config();
const { companies, users, employees, brands, partorders, serviceorders, parts, services, reviews } = models;
const router = Router();

//nodemailer set up
const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD,
    }
});

/**
 * @desc Register new user
 * @route /api/admin/company/create
 * @method POST
 * @access private
 */
router.post('/company/create', verifyTokenAndAdmin, async (req, res) => {
    try {
        const company = await companies.findOne({
            where: { email: req.body.email }
        });
        if (company) {
            return res.status(400).json({ message: 'Email already exists, try signing in' });
        }
        const newCompany = await companies.create({
            name: req.body.name,
            email: req.body.email,
            address: req.body.address,
        });
        return res.status(201).json({ message: 'company add successfully', newCompany });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }

});

/**
 * @desc Get All Companies
 * @route /api/admin/company
 * @method GET
 * @access private
 */
router.get('/company', verifyTokenAndAdmin, async (req, res) => {
    try {
        const companiesNames = await companies.findAll({
            attributes: ['name'],
        });
        if (companiesNames.length === 0) {
            return res.status(207).json({ message: 'No companies found' });
        }
        return res.status(200).json({ companiesNames });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc Create company admin
 * @route /api/admin/company-admin/create
 * @method POST
 * @access private
 */

router.post('/company-admin/create', verifyTokenAndAdmin, async (req, res) => {
    try {
        console.log('creating the company admin');
        const user = await users.findOne({
            where: { email: req.body.email }
        });
        if (user) {
            return res.status(400).json({ message: 'Email already exists, try another' });
        }
        console.log('stage 1 done');
        const company = await companies.findOne({
            where: { name: req.body.company }
        });
        if (!company) {
            return res.status(400).json({ message: 'company is not found' })
        }

        const companyId = company.id;
        console.log('stage 2 done');
        //hash password
        const salt = await bcrypt.genSalt(10);
        console.log('salt generated')
        const hashedPassword = await bcrypt.hash(req.body.password, salt);
        console.log('password hashed successfuly');
        const newUser = await users.create({
            name: req.body.name,
            email: req.body.email,
            role: 'company_admin',
            password: hashedPassword
        })
        console.log('stage 3 done');
        const userId = newUser.id;
        console.log('user id saved');
        const newEmployee = await employees.create({
            company_id: companyId,
            user_id: userId,
            role: 'admin',
        })
        console.log('stage 4 done');

        return res.status(201).json({ message: 'company admin created successfully', newUser, newEmployee });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc Get allpending verification users
 * @route /api/admin/unverified-users
 * @method GET
 * @access private
 */
router.get('/unverified-users', async (req, res) => {
    try {
        const unverifiedUsers = await users.findAll({
            where: { verify_stat: 'pending' },
            attributes: ['id', 'name', 'phone', 'img_uri']
        });
        if (unverifiedUsers.length === 0) {
            return res.status(207).json({ message: 'No  users found' });
        }
        return res.status(200).json({ unverifiedUsers });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc Add a new car brand
 * @route /api/admin/new-brand
 * @method POST
 * @access private
 */
router.post('/new-brand', verifyTokenAndAdmin, async (req, res) => {
    try {
        const brand = await brands.findOne({
            where: { brand: req.body.brand }
        })
        if (brand) {
            return res.status(400).json({ message: 'Brand already exists, try adding a new model' });
        }
        const newBrand = await brands.create({
            brand: req.body.brand,
            models: req.body.models
        });
        res.status(201).json({ message: 'Brand added successfully', newBrand });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }

});

/**
 * @desc get all data for the statistics
 * @route /api/admin/stat
 * @method GET
 * @access private
 */
router.get('/stat', verifyTokenAndAdmin, async (req, res) => {
    try {
        //user stat
        const totalUsers = await users.count();
        const verifiedUsers = await users.count({ where: { verify_stat: 'verified' } });
        const unverifiedUsers = await users.count({ where: { verify_stat: 'unverified' } });
        const pendingUsers = await users.count({ where: { verify_stat: 'pending' } });
        //company stat
        const totalComp = await companies.count();
        const yearlySub = totalComp * 100;
        //employee stat
        const totalEmp = await employees.count();
        const drivers = await employees.count({ where: { role: 'driver' } });
        const mechanics = await employees.count({ where: { role: 'mechanic' } });
        const admins = await employees.count({ where: { role: 'admin' } });
        //order stat
        const totalPart = await partorders.count();
        const totalPartRev = await partorders.sum('total_price');
        const totalService = await serviceorders.count();
        const totalServiceRev = await serviceorders.sum('price');
        //review stat
        const totalReviews = await reviews.count();
        const averageRat = await reviews.findAll({
            attributes: [[Sequelize.fn('AVG', Sequelize.col('rating')), 'avgRating']],
            raw: true,
        });

        res.status(200).json({
            userStatistics: {
                totalUsers,
                verifiedUsers,
                unverifiedUsers,
                pendingUsers,
            },
            companyStatistics: {
                totalComp,
                yearlySub,
            },
            employeeStatistics: {
                totalEmp,
                drivers,
                mechanics,
                admins,
            },
            orderStatistics: {
                totalPart,
                totalPartRev: totalPartRev || 0,
                totalService,
                totalServiceRev: totalServiceRev || 0,
            },
            reviewStatistics: {
                totalReviews,
                averageRat: averageRat[0].avgRating || 0,
            }
        });
    } catch (error) {
        console.error('Error fetching statistics:', error);
        res.status(500).json({ error: 'Failed to fetch statistics' });
    }
});


/**
 * @desc Add apart to the parts store
 * @route /api/admin/part
 * @method POST
 * @access private
 */
router.post('/part', verifyTokenAndAdmin, async (req, res) => {


    try {
        const newPart = await parts.create({
            company_id: 0,
            part_name: req.body.part_name,
            compatible_cars: req.body.compatible_cars,
            description: req.body.description,
            price: req.body.price,
            image_url: req.body.image_url,
            byAdmin: true,
        });
        res.status(201).json({ 'Part added to the shop success fuly': newPart });
    } catch (error) {
        res.status(500).json({ Error: 'Server Error:' });

    }
});



export default router;