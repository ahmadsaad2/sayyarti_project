import { Router } from 'express';
import models from '../../../models/index.js'; // Correct relative path to models
const router = Router();
const { companies, services } = models;

/**
 * GET /api/services
 * Fetch all services or optionally filter by company_id if desired
 */
router.get('/all/:id', async (req, res) => {
  try {
    // e.g., GET /api/services?company_id=1
    const { company_id } = req.params.id;
    const whereClause = {};

    if (company_id) whereClause.company_id = company_id;

    const allServices = await services.findAll({
      where: whereClause,
    });

    return res.status(200).json(allServices);
  } catch (error) {
    console.error('Error fetching services:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * GET /api/services/:id
 * Fetch a single service by ID
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const service = await services.findByPk(id);
    if (!service) {
      return res.status(404).json({ message: 'Service not found' });
    }
    return res.status(200).json(service);
  } catch (error) {
    console.error('Error fetching service:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * POST /api/services
 * Create a new service
 */
router.post('/', async (req, res) => {
  try {
    const { company_id, name, time, price, details } = req.body;

    if (!company_id || !name || !time || !price) {
      return res.status(400).json({ message: 'Required fields missing' });
    }

    // Optional: Check the company exists
    const company = await companies.findByPk(company_id);
    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    const newService = await services.create({
      company_id,
      name,
      time,
      price,
      details: details || '',
    });

    return res.status(201).json({ message: 'Service created', service: newService });
  } catch (error) {
    console.error('Error creating service:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * PUT /api/services/:id
 * Update an existing service
 */
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, time, price, details } = req.body;

    const existingService = await services.findByPk(id);
    if (!existingService) {
      return res.status(404).json({ message: 'Service not found' });
    }

    if (name !== undefined) existingService.name = name;
    if (time !== undefined) existingService.time = time;
    if (price !== undefined) existingService.price = price;
    if (details !== undefined) existingService.details = details;

    await existingService.save();
    return res.status(200).json({ message: 'Service updated', service: existingService });
  } catch (error) {
    console.error('Error updating service:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * DELETE /api/services/:id
 * Delete a service by ID
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const existingService = await services.findByPk(id);
    if (!existingService) {
      return res.status(404).json({ message: 'Service not found' });
    }

    await existingService.destroy();
    return res.status(200).json({ message: 'Service deleted' });
  } catch (error) {
    console.error('Error deleting service:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

export default router;
