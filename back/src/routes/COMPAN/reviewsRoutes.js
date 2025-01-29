import { Router } from 'express';
import models from '../../../models/index.js';

const router = Router();
const { reviews, companies, users } = models;

/**
 * GET /api/reviews?company_id=XYZ
 * Returns all reviews for a given company (optional).
 */
router.get('/:id', async (req, res) => {
  try {
    const { company_id } = req.params.id;
    const whereClause = {};

    if (company_id) {
      whereClause.company_id = company_id;
    }

    const allReviews = await reviews.findAll({
      where: whereClause,
      include: [
        { model: companies, as: 'company' },
        { model: users, as: 'user' },
      ],
      order: [['createdAt', 'DESC']],
    });

    return res.status(200).json(allReviews);
  } catch (error) {
    console.error('Error fetching reviews:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * GET /api/reviews/:id
 * Returns a single review by ID
 */
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const review = await reviews.findByPk(id, {
      include: [
        { model: companies, as: 'company' },
        { model: users, as: 'user' },
      ],
    });
    if (!review) {
      return res.status(404).json({ message: 'Review not found' });
    }
    return res.status(200).json(review);
  } catch (error) {
    console.error('Error fetching review:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * POST /api/reviews
 * Create a new review
 */
router.post('/', async (req, res) => {
  try {
    const { company_id, user_id, rating, comment } = req.body;

    if (!company_id || !user_id || !rating) {
      return res.status(400).json({ message: 'company_id, user_id, rating are required' });
    }

    // Optional: check if the company and user exist
    const newReview = await reviews.create({
      company_id,
      user_id,
      rating,
      comment: comment || '',
    });

    return res.status(201).json({ message: 'Review created', review: newReview });
  } catch (error) {
    console.error('Error creating review:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * PUT /api/reviews/:id
 * Update an existing review
 */
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { rating, comment } = req.body;

    const existingReview = await reviews.findByPk(id);
    if (!existingReview) {
      return res.status(404).json({ message: 'Review not found' });
    }

    if (rating !== undefined) existingReview.rating = rating;
    if (comment !== undefined) existingReview.comment = comment;

    await existingReview.save();
    return res.status(200).json({ message: 'Review updated', review: existingReview });
  } catch (error) {
    console.error('Error updating review:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

/**
 * DELETE /api/reviews/:id
 * Delete a review by ID
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const existingReview = await reviews.findByPk(id);
    if (!existingReview) {
      return res.status(404).json({ message: 'Review not found' });
    }

    await existingReview.destroy();
    return res.status(200).json({ message: 'Review deleted' });
  } catch (error) {
    console.error('Error deleting review:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

export default router;
