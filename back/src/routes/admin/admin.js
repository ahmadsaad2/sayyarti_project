import { Router } from 'express';
import models from '../../../models/index.js';

import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAdmin } from '../../middleware/userVerification.js';

dotenv.config();
const { companies } = models;
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
            attributes:['name'],
        });
        if(companiesNames.length ===0){
            return res.status(207).json({message: 'No companies found'});
        }
        return res.status(200).json({companiesNames});
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
});
export default router;