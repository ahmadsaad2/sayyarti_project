// import 'package:flutter/material.dart';

// class WorkshopDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> workshop;

//   const WorkshopDetailsPage({Key? key, required this.workshop})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(workshop['name']),
//         backgroundColor: const Color.fromARGB(255, 16, 80, 177),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16.0),
//                 child: Image.asset(
//                   workshop['image'],
//                   fit: BoxFit.cover,
//                   height: 250,
//                   width: 250,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               workshop['name'],
//               style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               workshop['location'],
//               style: const TextStyle(
//                   fontSize: 22, color: Color.fromARGB(255, 29, 31, 139)),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               workshop['description'],
//               style: const TextStyle(
//                   fontSize: 16, color: Color.fromARGB(255, 182, 122, 122)),
//             ),
//             const Divider(height: 32, thickness: 2),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('${workshop['name']} added to favorites'),
//                   duration: const Duration(seconds: 2),
//                 ));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 7, 10, 163),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text(
//                 'Add to Favorites',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
