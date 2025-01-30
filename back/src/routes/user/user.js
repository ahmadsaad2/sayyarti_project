import { Router } from 'express';
import models from '../../../models/index.js';

import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';
import { verifyTokenAndAuthorization, verifyToken } from '../../middleware/userVerification.js';
import { where } from 'sequelize';

dotenv.config();
const { users, address, brands, cars, parts, cart, partorders } = models;
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
 * @desc get my  car
 * @router /api/user/mycars/:id
 * @method GET
 * @access private
 */
router.get('/mycars/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
        const mycars = await cars.findAll({
            where: {
                user_id: req.params.id,
            }
        });
        if (mycars.length === 0) {
            return res.status(404).json();
        }
        else {
            return res.status(200).json(mycars);
        }
    } catch (error) {
        return res.status(500).json({ message: 'server error' });
    }
})

/**
 * @desc get all chat conversations
 * @router /api/user/chat-conv/
 * @method GET
 * @access public
 */
router.get('/chat-conv', async (req, res) => {
    try {
        const conv = await users.findAll({
            where: {
                role: ['company_admin'],
            },
        });
        return res.status(200).json({ conv });
    } catch (error) {
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc get all chat conversations for company admin
 * @router /api/user/chat-conv/
 * @method GET
 * @access public
 */
router.get('/chat-conv/company', async (req, res) => {
    try {
        const conv = await users.findAll({
            where: {
                role: ['user'],
            },
        });
        return res.status(200).json({ conv });
    } catch (error) {
        return res.status(500).json({ message: 'Server error' });
    }
});

/**
 * @desc get all products
 * @router /api/user/products/
 * @method GET
 * @access private
 */

router.get('/products', verifyToken, async (req, res) => {
    try {
        const products = await parts.findAll();
        return res.status(200).json({ products });
    } catch (error) {
        return res.status(500).json({ message: 'server error' })

    }
});

/**
 * @desc Add to cart
 * @router /api/user/add-cart/:id
 * @method POST
 * @access private
 */
router.post('/add-cart/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
        console.log('here');

        const exist = await cart.findOne({
            where: {
                user_id: req.params.id,
                part_id: req.body.part_id
            }
        });
        if (exist === null) {
            await cart.create({
                user_id: req.params.id,
                part_id: req.body.part_id,
                quantity: req.body.quantity
            });

            console.log('create');
            return res.status(200);
        } else {
            console.log('increment');

            await exist.update({ quantity: exist.quantity + req.body.quantity });
            return res.status(200);
        }
    } catch (error) {
        return res.status(500);
    }
});

/**
 * @desc get all cart items
 * @router /api/user/get-cart/:id
 * @method GET
 * @access private
 */
router.get('/get-cart/:id', verifyTokenAndAuthorization, async (req, res) => {


    try {

        const cartItems = await cart.findAll({
            where: { user_id: req.params.id },
            include: [
                {
                    model: parts,
                    as: 'part',
                    attributes: ['part_name', 'description', 'price', 'image_url']
                }
            ]
        });


        if (!cartItems || cartItems.length === 0) {
            return res.status(404).json({ message: 'No items founded in cart' });
        }

        const formatedItems = cartItems.map(item => {
            const part = item.part ? item.part.get({ plain: true }) : {};
            return {
                id: item.id,
                part_id: item.part_id,
                name: part.part_name,
                quantity: item.quantity,
                price: part.price,
                totalPrice: item.quantity * part.price,
                image: part.image_url,
                description: part.description,
            };
        });

        // const formatedItems = cartItems.map(item => ({
        //     part_id: item.part_id,
        //     name: item.part?.part_name,
        //     quantity: item.quantity,
        //     price: item.part?.price,
        //     totalPrice: item.quantity * item.parts.price,
        //     image: item.part?.image_url
        // }));
        return res.status(200).json(formatedItems);
    } catch (error) {
        return res.status(500).json({ message: 'server error' });

    }
});
/**
 * @desc delete an item from te cart
 * @router /api/user/delete-cart/:id
 * @method DELETE
 * @access private
 */
router.delete('/delete-cart/:id', verifyToken, async (req, res) => {
    try {
        const result = await cart.destroy({
            where: {
                id: req.params.id,
            }
        });
        if (result === 0) {
            return res.status(404).json({ message: 'no item founded' });
        }
        else {
            return res.status(200).json({ message: 'Item removed from cart successfuly' });
        }

    } catch (error) {
        return res.status(500).json({ message: 'server error' })
    }
});

/**
 * @desc place order
 * @router /api/user/check-out/:id
 * @method POST
 * @access private
 */
router.post('/check-out/:id', verifyTokenAndAuthorization, async (req, res) => {
    try {
        const result = await cart.destroy({
            where: {
                user_id: req.params.id,
            }
        });
        console.log('1');

        await partorders.create({
            user_id: req.params.id,
            total_price: req.body.totalPrice,
        });
        console.log('2');

        return res.status(200);

    } catch (error) {
        return res.status(500).json({ message: 'server error' });
    }
})


export default router;