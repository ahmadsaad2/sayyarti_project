import { Router } from 'express';
import models from '../../../models/index.js';

import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAuthorization } from '../../middleware/userVerification.js';

dotenv.config();
const { companies, users, employees } = models;
const router = Router();


/**
 * @desc Update user info 
 * @route /api/user/info-update/:id
 * @method PUT
 * @access private
 */
router.put('/info-update/:id', verifyTokenAndAuthorization, async (req, res) => {
    const userId = req.params.id;
    const updates = req.body; 
    try {
        const person = await users.findByPk(userId);
        if(person === null) return res.status(404).json({ message: 'User not found' });
        await person.update(updates);
        return res.status(200).json({ message: 'User updated successfully', person });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
})

export default router;