// // lib/widgets/work_assignment_table.dart
// import 'package:flutter/material.dart';
// import '../class/work_assignment.dart';

// class WorkAssignmentTable extends StatelessWidget {
//   final List<WorkAssignment> workAssignments;

//   const WorkAssignmentTable({Key? key, required this.workAssignments})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Define the order of days
//     final List<String> daysOfWeek = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday'
//     ];

//     // Group assignments by day
//     Map<String, List<WorkAssignment>> assignmentsByDay = {};
//     for (var day in daysOfWeek) {
//       assignmentsByDay[day] = [];
//     }
//     for (var assignment in workAssignments) {
//       if (assignmentsByDay.containsKey(assignment.day)) {
//         assignmentsByDay[assignment.day]!.add(assignment);
//       }
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: DataTable(
//         columns: const [
//           DataColumn(label: Text('Day')),
//           DataColumn(label: Text('Work')),
//           DataColumn(label: Text('Status')),
//         ],
//         rows: daysOfWeek.map((day) {
//           final assignments = assignmentsByDay[day]!;

//           if (assignments.isEmpty) {
//             return DataRow(cells: [
//               DataCell(Text(day)),
//               DataCell(Text('-')),
//               DataCell(Text('Not Assigned')),
//             ]);
//           }

//           // Assuming multiple assignments per day
//           String workDescription = assignments.map((a) => a.work).join(', ');
//           bool isWorking = assignments.any((a) => a.worked == 1);

//           return DataRow(cells: [
//             DataCell(Text(day)),
//             DataCell(Text(workDescription)),
//             DataCell(
//               Row(
//                 children: [
//                   isWorking
//                       ? const Icon(Icons.check_circle,
//                           color: Colors.green, size: 16)
//                       : const Icon(Icons.cancel, color: Colors.red, size: 16),
//                   const SizedBox(width: 4),
//                   Text(isWorking ? 'Working' : 'Not Working'),
//                 ],
//               ),
//             ),
//           ]);
//         }).toList(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../class/work_assignment.dart'; // Import your WorkAssignment class

class WorkAssignmentTable extends StatelessWidget {
  final List<WorkAssignment> workAssignments; // Use the WorkAssignment class

  const WorkAssignmentTable({super.key, required this.workAssignments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(color: Colors.black26),
        columnWidths: const {
          0: FractionColumnWidth(0.1), // ID column
          1: FractionColumnWidth(0.2), // Day column
          2: FractionColumnWidth(0.4), // Task column
          3: FractionColumnWidth(0.3), // Worked column
        },
        children: [
          _buildHeaderRow(),
          ...workAssignments.map((assignment) => _buildDataRow(assignment)),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      decoration: BoxDecoration(color: Colors.blueGrey),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('ID',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Day',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Task',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Worked',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }

  // TableRow _buildDataRow(WorkAssignment assignment) {
  //   return TableRow(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(assignment.id.toString()),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(assignment.day),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(
  //             assignment.work.isEmpty ? 'No Task Assigned' : assignment.work),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Icon(
  //           assignment.worked ? Icons.check_circle : Icons.cancel,
  //           color: assignment.worked ? Colors.green : Colors.red,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  TableRow _buildDataRow(WorkAssignment assignment) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(assignment.id.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(assignment.day),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(assignment.task.isEmpty
              ? 'No Task Assigned'
              : assignment.task), // Use 'task'
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            assignment.worked ? Icons.check_circle : Icons.cancel,
            color: assignment.worked ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
