import { Router } from 'express';
import models from '../../../models/index.js';

import bcrypt from 'bcrypt';
import { where } from 'sequelize';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import { validateUser, validateResetPassword, validateEmail } from './validation/auth_validation.js';
import nodemailer from 'nodemailer';

dotenv.config();
const { users, passwordreset } = models;
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
function body(code) {
    return `
  <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="width: 100%; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px; background-color: #f9f9f9;">
      <div style="text-align: center; margin-bottom: 20px;">
        <h1 style="color: #007bff;">Password Reset Request</h1>
      </div>
      <p>Dear User,</p>
      <p>We received a request to reset your password. Please use the following 6-digit code to reset your password:</p>
      <div style="font-size: 24px; font-weight: bold; text-align: center; margin: 20px 0; padding: 10px; background-color: #007bff; color: #fff; border-radius: 5px;">
        ${code}
      </div>
      <p>If you did not request this, you can safely ignore this email. The code will expire in 10 minutes.</p>
      <p>Thank you,</p>
      <p><strong>SAYYARTI Support Team</strong></p>
      <div style="text-align: center; margin-top: 20px; font-size: 12px; color: #888;">
        <p>If you have any questions, please contact our support team.</p>
      </div>
    </div>
  </body>
  `;
}



/**
 * @desc Register new user
 * @route /api/auth/register
 * @method POST
 * @access public
 */
router.post('/register', async (req, res) => {
    const { error } = validateUser(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });
    try {
        //check for alredy used email
        const user = await users.findOne({
            where: { email: req.body.email }
        });
        if (user) {
            return res.status(400).json({ message: 'Email already exists, try signing in' });
        }

        //hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);

        const newUser = await users.create({
            name: req.body.name,
            email: req.body.email,
            password: hashedPassword
        })
        return res.status(201).json({ message: 'User created successfully', newUser });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }

})

/**
 * @desc sign in
 * @route /api/auth/signin
 * @method POST
 * @access public
 */
router.post('/signin', async (req, res) => {
    console.log('here :)');
    const { error } = validateUser(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });
    try {
        const user = await users.findOne({
            where: { email: req.body.email }
        })
        if (!user) {
            return res.status(400).json({ message: 'email is not registered please register' });
        }
        const isMatch = await bcrypt.compare(req.body.password, user.password)
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid email or password' });
        } else {
            const token = jwt.sign(
                { userId: user.id, role: user.role },
                process.env.SECRET_KEY
            );
            return res.status(200).json({
                message: 'Authentication successful',
                token: token,
                role: user.role,
                id: user.id,
                username: user.name,
                phone: user.phone
            });//return the user role to navigate according to its role and the token for further auth
        }
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
})

/**
 * @desc send otp to use in password reset
 * @route /api/auth/reset
 * @method POST
 * @access public
 */
router.post('/reset', async (req, res) => {
    const { error } = validateEmail(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });
    try {
        const user = await users.findOne({
            where: { email: req.body.email }
        });
        if (!user) {
            return res.status(400).json({ message: 'email is not registered' });
        }
        const reset = await passwordreset.findOne({ where: { email: req.body.email } });
        if (reset) {
            await reset.destroy();
        }
        const otp = Math.floor((99972 + 28) + Math.random() * 900000).toString();//generate a random 6 digit number as an otp 
        await passwordreset.create({
            email: req.body.email,
            otp: otp
        });
        const mailOptions = {
            from: process.env.EMAIL_USER,
            to: req.body.email,
            subject: 'Password Reset Sayyarti',
            html: body(otp),
        };

        // transporter.sendMail(mailOptions, (err, info) => {
        //     if (err) {
        //         return res.status(500).json({message:'Something went wrong, please try again later'});
        //     }

        // });
        await transporter.sendMail(mailOptions);
        return res.status(200).json({
            message: 'Reset password email has been sent ',
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }

});

/**
 * @desc reset password
 * @route /api/auth/resetpass
 * @method POST
 * @access private (accessed only using OTP)
 */
router.post('/resetpass', async (req, res) => {
    const { error } = validateResetPassword(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });
    try {
        const reset = await passwordreset.findOne({ where: { email: req.body.email } });
        if (!reset) {
            return res.status(400).json({ message: 'No recovery claim found please try again' });
        }
        const expirationTime = 10 * 60 * 1000;//10 minutes in milliseconds
        const currentTime = new Date();
        const timeDifference = currentTime - new Date(reset.createdAt);
        if (timeDifference > expirationTime) {
            return res.status(400).json({ message: 'otp has expired' });
        }
        if (reset.otp != req.body.otp) {
            return res.status(400).json({ message: 'Invalid otp' });
        }
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);
        const [update] = await users.update({ password: hashedPassword }, { where: { email: req.body.email } });
        if (!update) {
            await reset.destroy();
            return res.status(404).json({ message: 'User not found please register' });
        }
        await reset.destroy();
        return res.status(200).json({ message: 'password updated successfully' });

    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'server error' });
    }
})

export default router;