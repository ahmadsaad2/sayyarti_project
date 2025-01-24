import { Router } from 'express';
import models from '../../../models/index.js'; // Adjust path if necessary

const router = Router();
const { employees, workassignment } = models; 
// "employees" and "workassignment" are the model references 
// from initModels (notice lowercase)

router.post('/assign', async (req, res) => {
  const { employee_id, day, task } = req.body;

  if (!employee_id || !day || !task) {
    return res
      .status(400)
      .json({ message: 'Employee ID, day, and task are required' });
  }

  try {
    // Check if the employee exists (use employees, not Employee)
    const employee = await employees.findByPk(employee_id);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Create a new work assignment
    const newWorkAssignment = await workassignment.create({
      employee_id,
      day,
      task,
      worked: false, // Default value
    });

    return res.status(201).json({
      message: 'Task assigned successfully',
      workassignment: newWorkAssignment,
    });
  } catch (error) {
    console.error('Error assigning work:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// GET: Fetch all work assignments for a specific employee
router.get('/employee/:employee_id', async (req, res) => {
  const { employee_id } = req.params;

  try {
    const employee = await employees.findByPk(employee_id, {
      include: [
        {
          model: workassignment,
          as: 'workAssignments', // MUST match the alias in initModels
        },
      ],
    });

    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    return res.status(200).json({
      employee: {
        id: employee.id,
        name: employee.name, // Adjust fields as needed
        email: employee.email,
        workAssignments: employee.workAssignments, // must match the include alias
      },
    });
  } catch (error) {
    console.error('Error fetching work assignments:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});
router.put('/assign/:assignment_id', async (req, res) => {
  try {
    const { assignment_id } = req.params;
    const { day, task, worked } = req.body;

    // Find the assignment by primary key
    const existingAssignment = await workassignment.findByPk(assignment_id);
    if (!existingAssignment) {
      return res.status(404).json({ message: 'Work assignment not found' });
    }

    // Update the assignment
    if (day !== undefined) existingAssignment.day = day;
    if (task !== undefined) existingAssignment.task = task;
    if (worked !== undefined) existingAssignment.worked = worked;

    await existingAssignment.save();

    return res.status(200).json({
      message: 'Work assignment updated successfully',
      workassignment: existingAssignment,
    });
  } catch (error) {
    console.error('Error updating work assignment:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});


router.put('/assign/:employee_id/:day', async (req, res) => {
  try {
    const { employee_id, day } = req.params;
    const { task, worked } = req.body;

    // 1. Check if the employee exists.
    const employee = await employees.findByPk(employee_id);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // 2. Find a work assignment by employee_id and day.
    //    This assumes only one assignment per employee per day.
    let existingAssignment = await workassignment.findOne({
      where: {
        employee_id,
        day,
      },
    });

    // 3. If no assignment is found, decide whether to:
    //    (a) return a 404, or
    //    (b) create a new assignment. 
    //    Here, we'll create one if it doesn't exist:
    if (!existingAssignment) {
      existingAssignment = await workassignment.create({
        employee_id,
        day,
        task: task || '',
        worked: worked ?? false,
      });
      return res.status(201).json({
        message: 'A new assignment was created because none existed',
        workassignment: existingAssignment,
      });
    }

    if (typeof task !== 'undefined') {
      existingAssignment.task = task;
    }
    if (typeof worked !== 'undefined') {
      existingAssignment.worked = worked;
    }

    await existingAssignment.save();

    return res.status(200).json({
      message: 'Work assignment updated successfully',
      workassignment: existingAssignment,
    });
  } catch (error) {
    console.error('Error updating work assignment:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});
export default router;
