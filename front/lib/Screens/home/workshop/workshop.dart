// import 'package:flutter/material.dart';
// import 'workshopdetails.dart';

// class WorkshopPage extends StatefulWidget {
//   final String categoryName; // Add categoryName to constructor

//   const WorkshopPage({Key? key, required this.categoryName}) : super(key: key);

//   @override
//   _WorkshopPageState createState() => _WorkshopPageState();
// }

// class _WorkshopPageState extends State<WorkshopPage> {
//   int _selectedIndex = 0;

//   static const List<String> _categories = <String>[
//     'Electrical',
//     'Denting',
//     'Mechanics',
//     'Polishing',
//   ];

//   static const List<String> _categoryImages = <String>[
//     'assets/images/electrical.jpg',
//     'assets/images/denting.jpg',
//     'assets/images/mechanics.jpg',
//     'assets/images/polishing.jpg',
//   ];

//   static const List<List<Map<String, dynamic>>> _workshops =
//       <List<Map<String, dynamic>>>[
//     [
//       {
//         'name': 'Auto Electricians',
//         'description': 'Expert electrical repair services for all vehicles.',
//         'location': '123 Main St',
//         'image': 'assets/images/electrical.png',
//       },
//       {
//         'name': 'Battery Fix',
//         'description': 'Specialized in battery replacements and repairs.',
//         'location': '456 Elm St',
//         'image': 'assets/images/electrical.png',
//       },
//     ],
//     [
//       {
//         'name': 'DentFix',
//         'description': 'High-quality denting service for all vehicle types.',
//         'location': '789 Oak St',
//         'image': 'assets/images/denting.png',
//       },
//       {
//         'name': 'FixMyCar',
//         'description': 'Comprehensive denting repair services.',
//         'location': '101 Pine St',
//         'image': 'assets/images/denting.png',
//       },
//     ],
//     [
//       {
//         'name': 'Mechanics Pro',
//         'description': 'Expert mechanics providing all car repairs.',
//         'location': '202 Birch St',
//         'image': 'assets/images/mechanics.png',
//       },
//       {
//         'name': 'CarFix Mechanics',
//         'description': 'Full-service auto repair shop for various car models.',
//         'location': '303 Cedar St',
//         'image': 'assets/images/mechanics.png',
//       },
//     ],
//     [
//       {
//         'name': 'Polish Masters',
//         'description': 'Polishing and detailing services for vehicles.',
//         'location': '404 Maple St',
//         'image': 'assets/images/polishing.png',
//       },
//       {
//         'name': 'Shiny Wheels',
//         'description': 'Vehicle polishing for a perfect shine.',
//         'location': '505 Willow St',
//         'image': 'assets/images/polishing.png',
//       },
//     ],
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Find the selected index for the category
//     _selectedIndex = _categories.indexOf(widget.categoryName);
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // Go back to the previous page
//           },
//         ),
//         title: Text(widget.categoryName), // Use the category name here
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(_categories.length, (index) {
//                   return GestureDetector(
//                     onTap: () => _onItemTapped(index),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 40,
//                           backgroundColor: _selectedIndex == index
//                               ? const Color.fromARGB(255, 24, 17, 122)
//                               : Colors.grey[300],
//                           child: CircleAvatar(
//                             radius: 35,
//                             backgroundImage: AssetImage(_categoryImages[index]),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 16.0),
//                           child: Text(
//                             _categories[index],
//                             style: TextStyle(
//                               color: _selectedIndex == index
//                                   ? const Color.fromARGB(255, 25, 27, 158)
//                                   : Colors.grey[700],
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//           const Divider(),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: MediaQuery.of(context).size.width > 600
//                     ? 3
//                     : 2, // Responsive layout
//                 childAspectRatio: 0.7,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: _workshops[_selectedIndex].length,
//               itemBuilder: (context, index) {
//                 var workshop = _workshops[_selectedIndex][index];
//                 return GestureDetector(
//                   onTap: () {
//                     // Navigate to WorkshopDetailsPage and pass the workshop details
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WorkshopDetailsPage(
//                           workshop: workshop, // Pass the selected workshop here
//                         ),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: Image.asset(
//                             workshop['image'],
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: 120,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             workshop['name'],
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text(
//                             workshop['description'],
//                             style: const TextStyle(color: Colors.grey),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             workshop['location'],
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
