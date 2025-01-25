import express from 'express';
import models from '../../../models/index.js';
const router = express.Router();
const { employees, tasks, users ,companies, workassignment} = models; 


// router.get('/:employeeId/tasks', async (req, res) => {
//   const { employeeId } = req.params;
//   const { day, status } = req.query;

//   try {
//     const employeeTasks = await tasks.findAll({
//       where: {
//         employee_id: employeeId,
//         ...(day && { day }),
//         ...(status && { status }),
//       },
//     });

//     if (!employeeTasks || employeeTasks.length === 0) {
//       return res.status(404).json({ message: 'No tasks found' });
//     }

//     return res.json(employeeTasks);
//   } catch (error) {
//     console.error('Error fetching tasks:', error);
//     return res.status(500).json({ message: 'Error fetching tasks' });
//   }
// });


router.get('/:userId', async (req, res) => {
  try {
    const employee = await employees.findOne({
      where: { user_id: req.params.userId },
      include: [
        { model: tasks, as: 'tasks' },
        { model: users, as: 'user' },
        { model: companies, as: 'company' },
        { model: workassignment, as: 'workAssignments' }
      ]
    });

    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Extract necessary fields
    const employeeData = {
      id: employee.id,
      userId: employee.user_id,
      name: employee.name,
      email: employee.email,
      contact: employee.contact,
      role: employee.role,
      workAssignments: employee.workAssignments,
      tasks: employee.tasks,
      user: employee.user,
      company: employee.company
    };

    return res.json(employeeData);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Error fetching employee data' });
  }
});

// Get employees by company ID with role filtering from the users table
router.get('/by-company/:companyId', async (req, res) => {
  const { companyId } = req.params;

  try {
    // Validate company existence
    const company = await companies.findByPk(companyId);
    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    // Fetch employees where associated users have role 'service_provider'
    const serviceProviders = await employees.findAll({
      where: {
        company_id: companyId, // Match employees by company ID
      },
      include: [
        {
          model: users,
          as: 'user',
          where: { role: 'service_provider' }, // Filter by role in the users table
          attributes: ['id', 'name', 'email', 'role'], // Include only necessary fields from users
        },
        { model: tasks, as: 'tasks' }, // Include associated tasks
      ],
    });

    // Check if no employees found
    if (!serviceProviders || serviceProviders.length === 0) {
      return res.status(404).json({ message: 'No service providers found for this company' });
    }

    return res.json(serviceProviders);
  } catch (error) {
    console.error('Error fetching employees:', error);
    return res.status(500).json({ message: 'Error fetching employees' });
  }
});
router.put('/:employeeId', async (req, res) => {
  try {
    const { name, email, contact } = req.body;
    const { employeeId } = req.params;

    
    const employee = await employees.findByPk(employeeId);

    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Update fields if provided
    if (name !== undefined) employee.name = name;
    if (email !== undefined) employee.email = email;
    if (contact !== undefined) employee.contact = contact;

    // Save the updated employee
    await employee.save();

    // Optionally, fetch the updated employee with associations
    const updatedEmployee = await employees.findOne({
      where: { id: employeeId },
      include: [
        { model: tasks, as: 'tasks' },
        { model: users, as: 'user' },
        { model: companies, as: 'company' }
      ]
    });

    // Extract necessary fields
    const employeeData = {
      id: updatedEmployee.id,
      userId: updatedEmployee.user_id,
      name: updatedEmployee.name,
      email: updatedEmployee.email,
      contact: updatedEmployee.contact,
      role: updatedEmployee.role,
      workAssignments: updatedEmployee.workAssignments,
      tasks: updatedEmployee.tasks,
      user: updatedEmployee.user,
      company: updatedEmployee.company
    };

    return res.json({ message: 'Employee updated successfully', employee: employeeData });
  } catch (error) {
    console.error('Error updating employee:', error);
    return res.status(500).json({ message: 'Error updating employee data' });
  }
});




// Update task status (e.g., In Progress, Completed)
router.put('/tasks/:taskId', async (req, res) => {
  try {
    const task = await tasks.findByPk(req.params.taskId);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    task.status = req.body.status;
    await task.save();

    return res.json({ message: 'Task status updated', task });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Error updating task status' });
  }
});

// router.get('/', async (req, res) => {
//   try {
//     // Fetch all employees with the role of 'service provider' along with associated tasks, user, and company details
//     const allEmployees = await employees.findAll({
  
//       include: [
//         { model: tasks, as: 'tasks' },    // Include tasks related to the employee
//         { model: users, as: 'user' },     // Include user details related to the employee
//         { model: companies, as: 'company' } // Include company details
//       ]
//     });

//     // If no employees are found, return a 404 error
//     if (!allEmployees || allEmployees.length === 0) {
//       return res.status(404).json({ message: 'No service provider employees found in the system' });
//     }

//     // Return the list of service provider employees
//     return res.json(allEmployees);
//   } catch (error) {
//     console.error('Error fetching employees:', error);
//     return res.status(500).json({ message: 'Error fetching employees' });
//   }
// });

// Route to get all employees (filtered by role if needed)
router.get('/', async (req, res) => {
  try {
    // Fetch all employees with the role of 'service provider' along with associated tasks, user, and company details
    const allEmployees = await employees.findAll({
      where: {
        role: 'service provider'  // Filter employees by 'service provider' role
      },
      include: [
        { model: tasks, as: 'tasks' },    // Include tasks related to the employee
        { model: users, as: 'user' },     // Include user details related to the employee
        { model: companies, as: 'company' } // Include company details
      ]
    });

    // If no employees found, return a 404 error
    if (!allEmployees || allEmployees.length === 0) {
      return res.status(404).json({ message: 'No service provider employees found in the system' });
    }

    // Return the list of service provider employees
    return res.json(allEmployees);
  } catch (error) {
    console.error('Error fetching employees:', error);
    return res.status(500).json({ message: 'Error fetching employees' });
  }
});




router.get('/:employeeId/tasks', async (req, res) => {
  const { employeeId } = req.params; // Extract employeeId from the URL
  const { day, status } = req.query; // Extract optional query parameters

  try {
    // Validate employee existence
    const employee = await employees.findByPk(employeeId);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Build the query conditions
    const whereConditions = {
      employee_id: employeeId, // Filter by employeeId
    };

    // Add optional filters for day and status
    if (day) {
      whereConditions.day = day;
    }
    if (status) {
      whereConditions.status = status;
    }

    // Fetch tasks based on the conditions
    const employeeTasks = await tasks.findAll({
      where: whereConditions,
    });

    // Check if tasks were found
    if (!employeeTasks || employeeTasks.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this employee' });
    }

    // Return the tasks
    return res.json(employeeTasks);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    return res.status(500).json({ message: 'Error fetching tasks' });
  }
});














// Get tasks by user ID
router.get('/user/:userId/tasks', async (req, res) => {
  const { userId } = req.params; // Extract userId from the URL
  const { day, status } = req.query; // Extract optional query parameters

  try {
    // Validate user existence
    const user = await users.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Build the query conditions
    const whereConditions = {
      user_id: userId, // Filter by user_id
    };

    // Add optional filters for day and status
    if (day) {
      whereConditions.day = day;
    }
    if (status) {
      whereConditions.status = status;
    }

    // Fetch tasks based on the conditions
    const userTasks = await tasks.findAll({
      where: whereConditions,
    });

    // Check if tasks were found
    if (!userTasks || userTasks.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this user' });
    }

    // Return the tasks
    return res.json(userTasks);
  } catch (error) {
    console.error('Error fetching tasks:', error);
    return res.status(500).json({ message: 'Error fetching tasks' });
  }
});







export default router;