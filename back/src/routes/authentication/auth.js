import { Router } from 'express';
import db from '../../../models/index.js';
import bcrypt from 'bcrypt';
import { where } from 'sequelize';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import {validateUser,validateResetPassword,validateEmail} from './validation/auth_validation.js';

dotenv.config();


const router = Router();
const { users, PasswordReset } = db;

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
            return res.status(400).json({ message: 'Email already exists' });
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
 * @method GET
 * @access public
 */
router.get('/signin', async (req, res) => {
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
                role: user.role
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
        const reset= await passwordReset.findOne({ where:{email: req.body.email}});
        if (reset){
            await reset.destroy();
        }
        const otp = Math.floor((99972 + 28) + Math.random() * 900000).toString();//generate a random 6 digit number as an otp 
        const newOTP = await PasswordReset.create({
            email: req.body.email,
            otp: otp
        });
        //use node mailer to send the otp to the user
        return res.status(200).json({
            message: 'Reset password email has been sent ',
            token: token
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
 * @access private
 */
router.post('/resetpass', async (req, res) => {
    const { error } = validateResetPassword(req.body);
    if (error) return res.status(400).json({ message: error.details[0].message });
    try {
        const reset = await passwordReset.findOne({ where: { email: req.body.email } });
        if (!reset) {
            return res.status(400).json({ message: 'No otp found please try again' });
        }
        const expirationTime = 10 * 60 * 1000;//10 minutes in milliseconds
        const currentTime = new Date();
        const timeDifference = currentTime - new Date(reset.createdAt);
        if (timeDifference > expirationTime) {
            return res.status(400).json({ message: 'otp has expired' });
        }
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(req.body.password, salt);
        const [update] = await users.update({ password: hashedPassword }, { where: { email: req.body.email } });
        if (!update) {
            await reset.destroy();
            return res.status(404).json({ message: 'User not found please register' });
        }else{
            await reset.destroy();
            return res.status(200).json({ message:'password updated successfully'});
        }

    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'server error' });
    }
})