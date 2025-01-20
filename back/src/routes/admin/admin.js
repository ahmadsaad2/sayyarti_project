import { Router } from 'express';
import models from '../../../models/index.js';

import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAdmin } from '../../middleware/userVerification.js';

dotenv.config();
const { companies, users, employees } = models;
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
 * @desc Get all unverified users
 * @route /api/admin/company-admin/create
 * @method GET
 * @access private
 */
router.get('/unverified-users', async (req, res) => {
    try {
        const unverifiedUsers = await users.findAll({
            where: { verify_stat: 'pending' },
            attributes: ['id','name', 'img_uri', 'role']
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

export default router;