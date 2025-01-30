import { Router } from 'express';
import models from '../../../models/index.js';
const router = Router();
const { offers, companies } = models;

/**
 * GET /api/offers?company_id=XYZ
 * Fetch offers for a specific company (or all if no company_id).
 */
router.get('/offer/:id', async (req, res) => {
  try {
    const  company_id  = req.params.id;
    const whereClause = {};

    if (company_id) whereClause.company_id = company_id;

    const allOffers = await offers.findAll({ where: whereClause });
    return res.status(200).json(allOffers);
  } catch (error) {
    console.error('Error fetching offers:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * GET /api/offers/:id
 * Fetch one offer by ID
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const offer = await offers.findByPk(id);
    if (!offer) {
      return res.status(404).json({ message: 'Offer not found' });
    }
    return res.status(200).json(offer);
  } catch (error) {
    console.error('Error fetching offer:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * POST /api/offers
 * Create a new offer
 */
router.post('/', async (req, res) => {
  try {
    const {
      company_id,
      description,
      type,
      amount,
      minimum_spend,
      start_date,
      end_date,
    } = req.body;

    // Validate required fields
    if (
      !company_id ||
      !description ||
      !type ||
      !amount ||
      !minimum_spend ||
      !start_date ||
      !end_date
    ) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    // Optional: Validate company
    const company = await companies.findByPk(company_id);
    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    const newOffer = await offers.create({
      company_id,
      description,
      type,
      amount,
      minimum_spend,
      start_date,
      end_date,
    });

    return res.status(201).json({ message: 'Offer created', offer: newOffer });
  } catch (error) {
    console.error('Error creating offer:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * PUT /api/offers/:id
 * Update an existing offer
 */
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const {
      description,
      type,
      amount,
      minimum_spend,
      start_date,
      end_date,
    } = req.body;

    const existingOffer = await offers.findByPk(id);
    if (!existingOffer) {
      return res.status(404).json({ message: 'Offer not found' });
    }

    if (description !== undefined) existingOffer.description = description;
    if (type !== undefined) existingOffer.type = type;
    if (amount !== undefined) existingOffer.amount = amount;
    if (minimum_spend !== undefined) existingOffer.minimum_spend = minimum_spend;
    if (start_date !== undefined) existingOffer.start_date = start_date;
    if (end_date !== undefined) existingOffer.end_date = end_date;

    await existingOffer.save();
    return res.status(200).json({ message: 'Offer updated', offer: existingOffer });
  } catch (error) {
    console.error('Error updating offer:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * DELETE /api/offers/:id
 * Delete an offer by ID
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const existingOffer = await offers.findByPk(id);
    if (!existingOffer) {
      return res.status(404).json({ message: 'Offer not found' });
    }

    await existingOffer.destroy();
    return res.status(200).json({ message: 'Offer deleted' });
  } catch (error) {
    console.error('Error deleting offer:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

export default router;
