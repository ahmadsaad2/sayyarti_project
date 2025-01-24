import { Router } from 'express';
import models from '../../../models/index.js'; // Correct relative path to models

const router = Router();
const { employees, companies, users, workassignment } = models; // Destructure the required models

router.post('/', async (req, res) => {
  const { company_id, name, email, password, role } = req.body;

  try {
    const company = await companies.findByPk(company_id);
    if (!company) {
      return res.status(404).json({ message: 'Company not found.' });
    }

    const existingUser = await users.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'A user with this email already exists.' });
    }

    const newUser = await users.create({
      name,
      email,
      password,
      role: 'service_provider',
    });

    const newEmployee = await employees.create({
      company_id,
      user_id: newUser.id,
      role,
    });

    return res.status(201).json({
      message: 'Employee account created successfully.',
      user: newUser,
      employee: newEmployee,
    });
  } catch (error) {
    console.error('Error adding employee:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});

// DELETE: Remove an employee by ID
router.delete('/:employeeId', async (req, res) => {
  const { employeeId } = req.params;
  try {
    const employee = await employees.findByPk(employeeId);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    await employee.destroy();
    return res.status(200).json({ message: 'Employee deleted successfully' });
  } catch (error) {
    console.error('Error deleting employee:', error);
    return res.status(500).json({ message: 'Server error', error: error.message });
  }
});
router.get('/company/:companyId', async (req, res) => {
  const { companyId } = req.params;
  try {
    const employeesList = await employees.findAll({
      where: { company_id: companyId },
      include: [
        {
          model: workassignment,
          as: 'workAssignments',
        },
        {
          model: users,
          as: 'user',
          attributes: ['name', 'email', 'role'],
          where: { role: 'service_provider' },
        },
      ],
    });
    if (!employeesList || employeesList.length === 0) {
      return res.status(404).json({ message: 'No employees found' });
    }
    return res.status(200).json({ employees: employeesList });
  } catch (error) {
    console.error('Error fetching employees:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

export default router;
