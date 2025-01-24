import { Router } from 'express';
import models from '../../../models/index.js'; // Adjust the path to your models

const router = Router();
const { companies } = models;

// Route to retrieve a single company by ID
router.get('/:id', async (req, res) => {
    const companyId = req.params.id;

    try {
        const company = await companies.findByPk(companyId);

        if (!company) {
            return res.status(404).json({ message: 'Company not found' });
        }

        return res.status(200).json({ company });
    } catch (error) {
        console.error('Error retrieving company:', error);
        return res.status(500).json({ message: 'Server error' });
    }
});
// Route to retrieve all companies
router.get('/', async (req, res) => {
  try {
      const allCompanies = await companies.findAll();

      if (allCompanies.length === 0) {
          return res.status(404).json({ message: 'No companies found' });
      }

      return res.status(200).json({ companies: allCompanies });
  } catch (error) {
      console.error('Error retrieving companies:', error);
      return res.status(500).json({ message: 'Server error' });
  }
});
// Route to get company by user_id
router.get('/user/:user_id', async (req, res) => {
  const { user_id } = req.params;

  try {
      // Find the company associated with the given user_id
      const company = await companies.findOne({
          where: { user_id },
      });

      // If no company is found, return a 404
      if (!company) {
          return res.status(404).json({ message: 'No company found for this user' });
      }

      // Return the company details
      return res.status(200).json({ company });
  } catch (error) {
      console.error('Error retrieving company:', error);
      return res.status(500).json({ message: 'Server error' });
  }
});

// Route to update or create company for a user
router.put('/user/:user_id', async (req, res) => {
    const { user_id } = req.params;
    const { name, address, contact, email } = req.body;
  
    try {
        let company = await companies.findOne({ where: { user_id } });
  
      if (company) {
        await company.update({ name, address, contact, email });
        return res.status(200).json({ message: 'Company updated successfully', company });
      }
  
      company = await companies.create({
        name,
        address,
        contact,
        email,
        userId: user_id,
      });
  
      return res.status(201).json({ message: 'Company created successfully', company });
    } catch (error) {
      console.error('Error updating or creating company:', error);
      return res.status(500).json({ message: 'Server error' });
    }
  });
export default router;
