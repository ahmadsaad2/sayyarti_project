import { Router } from 'express';
import models from '../../../models/index.js';

import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAuthorization } from '../../middleware/userVerification.js';
import { where } from 'sequelize';

dotenv.config();
const { users, address, brands, cars } = models;
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
        if (person === null) return res.status(404).json({ message: 'User not found' });
        await person.update(updates);
        return res.status(200).json({ message: 'User updated successfully', person });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Server error' });
    }
});
/**
 * @desc ADD an address 
 * @route /api/user/add-address/:id
 * @method POST
 * @access private
 */
router.post('/add-address/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
        const newAddress = await address.create({
            address: req.body.address,
            lat: req.body.lat,
            lng: req.body.lng,
            user_id: req.params.id,
        });
        return res.status(200).json({ message: 'address added successfully', newAddress });
    } catch (error) {
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc get all user addresses 
 * @route /api/user/get-address/:id
 * @method GET
 * @access private
 */
router.get('/get-address/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
        const addresses = await address.findAll({
            where: { user_id: req.params.id }
        });
        return res.status(200).json({ addresses });
    } catch (error) {

    }
});

/**
 * @desc get user info 
 * @route /api/user/get-address/:id
 * @method GET
 * @access private
 */
router.get('/get-info/:id', verifyTokenAndAuthorization, async (req, res) => {
    console.log('getting user info');
    try {
        const user = await users.findByPk(req.params.id);
        console.log('done');
        return res.status(200).json({ user });
    } catch (error) {
        console.log('done');
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc get all car brands  
 * @route /api/user/get-cars/
 * @method GET
 * @access public
 */
router.get('/get-brands', async (req, res) => {
    try {
        const brand = await brands.findAll();
        return res.status(200).json({ brand });
    } catch (error) {
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc add a new car
 * @router /api/user/add-car/:id
 * @method POST
 * @access private
 */
router.post('/add-car/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
        const newCar = await cars.create({
            user_id: req.params.id,
            brand: req.body.brand,
            model: req.body.model,
            year: req.body.year,
            wheel: req.body.wheel,
            fuel: req.body.fuel,
        });
        return res.status(201).json({ message: 'Car added successfully', newCar });
    } catch (error) {

    }
});

/**
 * @desc add a new car
 * @router /api/user/chat-conv/
 * @method GET
 * @access public
 */
router.get('/chat-conv', async (req, res) => {
    try {
        const conv = await users.findAll({
            where: {
                role: ['company_admin', 'service_provider'],
            },
        });
        return res.status(200).json({conv});
    } catch (error) {
        return res.status(500).json({message:'Server error'});
    }
});

export default router;