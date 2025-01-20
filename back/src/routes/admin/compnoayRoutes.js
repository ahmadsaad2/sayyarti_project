import { Router } from 'express';
import models from '../../../models/index.js';
import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAdmin } from '../../middleware/userVerification.js';

dotenv.config();
const { companies, users, employees } = models;
const router = Router();

// Nodemailer setup
const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD,
    }
});

// Define your routes here
router.post('/company/create', verifyTokenAndAdmin, async (req, res) => {
});

router.post('/company-admin/create', verifyTokenAndAdmin, async (req, res) => {
});

export default router;
