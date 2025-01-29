// import express from 'express';
// import models from '../../../models/index.js';

// const router = express.Router();
// const { bookings, tasks, employees, companies,users } = models;



// router.post('/create', async (req, res) => {
//   const {
//     customer_name,
//     mobile,
//     service,
//     payment_method,
//     status,
//     company_id,
//     booking_date,
//     problem_details,
//     problem_image,
//     user_id, // Ensure you are extracting user_id from req.body
//   } = req.body;

//   try {
//     // Validate company
//     const company = await companies.findByPk(company_id);
//     if (!company) {
//       return res.status(404).json({ message: 'Company not found' });
//     }

//     // Create the booking
//     const newBooking = await bookings.create({
//       customer_name,
//       mobile,
//       service,
//       payment_method,
//       status: 'Pending', // Default status
//       company_id,
//       booking_date,
//       problem_details: problem_details || null, // Allow null
//       problem_image: problem_image || null, // Allow null
//       user_id, // Corrected variable name
//     });

//     return res.status(201).json({
//       message: 'Booking created successfully',
//       booking: newBooking,
//     });
//   } catch (error) {
//     console.error('Error creating booking:', error);
//     return res.status(500).json({ message: 'Internal server error' });
//   }
// });

// // // Create a new booking
// // router.post('/create', async (req, res) => {
// //   const { customer_name, mobile, service, payment_method, company_id, booking_date } = req.body;

// //   try {
// //     // Validate company
// //     const company = await companies.findByPk(company_id);
// //     if (!company) {
// //       return res.status(404).json({ message: 'Company not found' });
// //     }

// //     // Create the booking
// //     const newBooking = await bookings.create({
// //       customer_name,
// //       mobile,
// //       service,
// //       payment_method,
// //       status: 'Pending', // Default status
// //       company_id,
// //       booking_date,
// //     });

// //     return res.status(201).json({ message: 'Booking created successfully', booking: newBooking });
// //   } catch (error) {
// //     console.error('Error creating booking:', error);
// //     return res.status(500).json({ message: 'Internal server error' });
// //   }
// // });

// // Fetch all bookings
// router.get('/', async (req, res) => {
//   try {
//     const allBookings = await bookings.findAll({
//       include: [
//         { model: companies, as: 'company' }, // Include company details
//       ],
//     });

//     return res.json(allBookings);
//   } catch (error) {
//     console.error('Error fetching bookings:', error);
//     return res.status(500).json({ message: 'Internal server error' });
//   }
// });

// // // Assign a booking to an employee as a task
// // router.post('/assign-to-task/:bookingId', async (req, res) => {
// //   const { bookingId } = req.params;
// //   const { employeeId, day } = req.body;

// //   try {
// //     // Validate booking
// //     const booking = await bookings.findByPk(bookingId);
// //     if (!booking) {
// //       return res.status(404).json({ message: 'Booking not found' });
// //     }

// //     // Validate employee
// //     const employee = await employees.findByPk(employeeId);
// //     if (!employee) {
// //       return res.status(404).json({ message: 'Employee not found' });
// //     }

// //     // Create a new task from the booking
// //     const newTask = await tasks.create({
// //       employee_id: employeeId,
// //       task: booking.service,
// //       day: day || 'Monday', // Default to Monday if no day is provided
// //       status: 'waiting', // Default status
// //     });

// //     return res.status(201).json({
// //       message: 'Booking assigned to task successfully',
// //       task: newTask,
// //     });
// //   } catch (error) {
// //     console.error('Error assigning booking to task:', error);
// //     return res.status(500).json({ message: 'Internal server error' });
// //   }
// // // });
// // router.post('/assign-to-task/:bookingId', async (req, res) => {
// //   const { bookingId } = req.params;
// //   const { employeeId, day, userId } = req.body; // Include userId in the request body

// //   try {
// //     // Validate booking
// //     const booking = await bookings.findByPk(bookingId);
// //     if (!booking) {
// //       return res.status(404).json({ message: 'Booking not found' });
// //     }

// //     // Validate employee
// //     const employee = await employees.findByPk(employeeId);
// //     if (!employee) {
// //       return res.status(404).json({ message: 'Employee not found' });
// //     }

// //     // Create a new task from the booking
// //     const newTask = await tasks.create({
// //       employee_id: employeeId,
// //       user_id: userId, // Assign userId to the task
// //       task: booking.service,
// //       day: day || 'Monday', // Default to Monday if no day is provided
// //       status: 'waiting', // Default status
// //     });

// //     return res.status(201).json({
// //       message: 'Booking assigned to task successfully',
// //       task: newTask,
// //     });
// //   } catch (error) {
// //     console.error('Error assigning booking to task:', error);
// //     return res.status(500).json({ message: 'Internal server error' });
// //   }
// // });



// router.post('/assign-to-task/:bookingId', async (req, res) => {
//   const { bookingId } = req.params;
//   const { employeeId, day, userId } = req.body; // Include userId in the request body

//   try {
//     // Validate booking
//     const booking = await bookings.findByPk(bookingId);
//     if (!booking) {
//       return res.status(404).json({ message: 'Booking not found' });
//     }

//     // Validate employee
//     const employee = await employees.findByPk(employeeId);
//     if (!employee) {
//       return res.status(404).json({ message: 'Employee not found' });
//     }

//     // Validate user
//     const user = await users.findByPk(userId);
//     if (!user) {
//       return res.status(404).json({ message: 'User not found' });
//     }

//     // Create a new task from the booking
//     const newTask = await tasks.create({
//       employee_id: employeeId,
//       user_id: userId, // Assign userId to the task
//       task: booking.service,
//       day: day || 'Monday', // Default to Monday if no day is provided
//       status: 'waiting', // Default status
//     });

//     return res.status(201).json({
//       message: 'Booking assigned to task successfully',
//       task: newTask,
//     });
//   } catch (error) {
//     console.error('Error assigning booking to task:', error);
//     return res.status(500).json({ message: 'Internal server error' });
//   }
// });







// // Update booking status
// router.put('/update-status/:bookingId', async (req, res) => {
//   const { bookingId } = req.params;
//   const { status } = req.body;

//   try {
//     const booking = await bookings.findByPk(bookingId);

//     if (!booking) {
//       return res.status(404).json({ message: 'Booking not found' });
//     }

//     booking.status = status;
//     await booking.save();

//     return res.json({ message: 'Booking status updated successfully', booking });
//   } catch (error) {
//     console.error('Error updating booking status:', error);
//     return res.status(500).json({ message: 'Internal server error' });
//   }
// });

// // Delete a booking
// router.delete('/delete/:bookingId', async (req, res) => {
//   const { bookingId } = req.params;

//   try {
//     const booking = await bookings.findByPk(bookingId);

//     if (!booking) {
//       return res.status(404).json({ message: 'Booking not found' });
//     }

//     await booking.destroy();
//     return res.json({ message: 'Booking deleted successfully' });
//   } catch (error) {
//     console.error('Error deleting booking:', error);
//     return res.status(500).json({ message: 'Internal server error' });
//   }
// });

// export default router;
import express from 'express';
import models from '../../../models/index.js';
const router = express.Router();
const { bookings, tasks, employees, companies,users } = models;
router.post('/create', async (req, res) => {
  const {
    customer_name,
    mobile,
    service,
    payment_method,
    status,
    company_id,
    booking_date,
    problem_details,
    problem_image,
    user_id, // Ensure you are extracting user_id from req.body
  } = req.body;

  try {
    // Validate company
    const company = await companies.findByPk(company_id);
    if (!company) {
      return res.status(404).json({ message: 'Company not found' });
    }

    // Create the booking
    const newBooking = await bookings.create({
      customer_name,
      mobile,
      service,
      payment_method,
      status: 'Pending', // Default status
      company_id,
      booking_date,
      problem_details: problem_details || null, // Allow null
      problem_image: problem_image || null, // Allow null
      user_id:user_id// Corrected variable name
    });

    return res.status(201).json({
      message: 'Booking created successfully',
      booking: newBooking,
    });
  } catch (error) {
    console.error('Error creating booking:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Fetch all bookings
router.get('/', async (req, res) => {
  try {
    const allBookings = await bookings.findAll({
      include: [
        { model: companies, as: 'company' }, // Include company details
      ],
    });

    return res.json(allBookings);
  } catch (error) {
    console.error('Error fetching bookings:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

router.post('/assign-to-task/:bookingId', async (req, res) => {
  const { bookingId } = req.params;
  const { employeeId, day, userId } = req.body; // Include userId in the request body

  try {
    // Validate booking
    const booking = await bookings.findByPk(bookingId);
    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    // Validate employee
    const employee = await employees.findByPk(employeeId);
    if (!employee) {
      return res.status(404).json({ message: 'Employee not found' });
    }

    // Validate user
    const user = await users.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Create a new task from the booking
    const newTask = await tasks.create({
      employee_id: employeeId,
      user_id: userId, // Assign userId to the task
      task: booking.service,
      day: day || 'Monday', // Default to Monday if no day is provided
      status: 'waiting', // Default status
    });

    return res.status(201).json({
      message: 'Booking assigned to task successfully',
      task: newTask,
    });
  } catch (error) {
    console.error('Error assigning booking to task:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});







// Update booking status
router.put('/update-status/:bookingId', async (req, res) => {
  const { bookingId } = req.params;
  const { status } = req.body;

  try {
    const booking = await bookings.findByPk(bookingId);

    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    booking.status = status;
    await booking.save();

    return res.json({ message: 'Booking status updated successfully', booking });
  } catch (error) {
    console.error('Error updating booking status:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

// Delete a booking
router.delete('/delete/:bookingId', async (req, res) => {
  const { bookingId } = req.params;

  try {
    const booking = await bookings.findByPk(bookingId);

    if (!booking) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    await booking.destroy();
    return res.json({ message: 'Booking deleted successfully' });
  } catch (error) {
    console.error('Error deleting booking:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});


// Fetch bookings by user ID
router.get('/user/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const userBookings = await bookings.findAll({
      where: { user_id: userId },
      include: [
        { model: companies, as: 'company' }, // Include company details
      ],
    });

    return res.json(userBookings);
  } catch (error) {
    console.error('Error fetching user bookings:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
});
export default router;