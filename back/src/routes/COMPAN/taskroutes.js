import express from 'express';
import models from '../../../models/index.js';

const router = express.Router();
const { tasks, employees, bookings } = models;

// Create a new task
router.post('/create', async (req, res) => {
  const { employeeId, task, day, status } = req.body;

  try {
    // Validate employee
    const employee = await employees.findByPk(employeeId);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Create the task
    const newTask = await tasks.create({
      employee_id: employeeId,
      task,
      day,
      status: status || 'waiting', // Default status to 'waiting'
    });

    return res.status(201).json({ message: 'Task created successfully', task: newTask });
  } catch (error) {
    console.error('Error creating task:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Fetch all tasks
router.get('/', async (req, res) => {
  try {
    const allTasks = await tasks.findAll({
      include: [
        { model: employees, as: 'employee' }, // Include employee details
      ],
    });

    return res.json(allTasks);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Fetch tasks by employee ID
router.get('/by-employee/:employeeId', async (req, res) => {
  const { employeeId } = req.params;

  try {
    const employeeTasks = await tasks.findAll({
      where: { employee_id: employeeId },
      include: [{ model: employees, as: 'employee' }],
    });

    if (employeeTasks.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this employee' });
    }

    return res.json(employeeTasks);
  } catch (error) {
    console.error('Error fetching tasks by employee:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Update task status
router.put('/update-status/:taskId', async (req, res) => {
  const { taskId } = req.params;
  const { status } = req.body;

  try {
    const task = await tasks.findByPk(taskId);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    task.status = status;
    await task.save();

    return res.json({ message: 'Task status updated successfully', task });
  } catch (error) {
    console.error('Error updating task status:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Delete a task
router.delete('/delete/:taskId', async (req, res) => {
  const { taskId } = req.params;

  try {
    const task = await tasks.findByPk(taskId);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    await task.destroy();
    return res.json({ message: 'Task deleted successfully' });
  } catch (error) {
    console.error('Error deleting task:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});





router.get('/by-user/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    // Fetch tasks for the given user_id
    const userTasks = await tasks.findAll({
      where: { user_id: userId }, // Filter by user_id
      include: [
        { model: employees, as: 'employee' }, // Include employee details if needed
      ],
    });

    // If no tasks are found, return a 404 error
    if (userTasks.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this user' });
    }

    // Return the tasks as JSON
    return res.json(userTasks);
  } catch (error) {
    console.error('Error fetching tasks by user:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});






export default router;
