// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:slot_seek/app_colors.dart';
// import 'package:slot_seek/book_slot.dart';
// import 'package:slot_seek/custom_widgets.dart';
// import 'package:slot_seek/notifications.dart';
// import 'package:slot_seek/profile.dart';
// import 'dart:math' as math;

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             AppColors.primaryGradientStart,
//             AppColors.primaryGradientEnd,
//           ],
//         ),
//       ),
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(60),
//           child: AppBar(
//             title: Row(
//               children: const [
//                 Expanded(
//                   child: Text(
//                     'Home',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: AppColors.textLightorange),
//                   ),
//                 ),
//                 Icon(
//                   Icons.search,
//                   color: AppColors.textLightorange,
//                 ),
//               ],
//             ),
//             backgroundColor: AppColors.primaryColor,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//           ),
//         ),
//         body: const ParkingLot(),
//         bottomNavigationBar: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           child: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               color: AppColors.primaryColor,
//             ),
//             child: PreferredSize(
//               preferredSize: const Size.fromHeight(60),
//               child: BottomNavigationBar(
//                 backgroundColor: AppColors.primaryColor,
//                 currentIndex: 0,
//                 selectedItemColor: AppColors.secondaryColor,
//                 unselectedItemColor: AppColors.greyLight,
//                 onTap: (index) {
//                   if (index == 0) {
//                     // Navigate to profile page
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const HomePage()),
//                     );
//                   }
//                   if (index == 1) {
//                     // Navigate to notifications page
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const NotificationsPage()),
//                     );
//                   }
//                   // Implement navigation logic based on index
//                   if (index == 2) {
//                     // Navigate to profile page
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const ProfilePage()),
//                     );
//                   }
//                 },
//                 items: const <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home),
//                     label: 'Home',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.notifications),
//                     label: 'Notifications',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.person),
//                     label: 'Profile',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ParkingLot extends StatelessWidget {
//   const ParkingLot({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance.collection('Parking Slots').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: CircularProgressIndicator()); // Or any loading indicator
//           }

//           // Convert the QuerySnapshot into a list of ParkingSlots
//           final List<ParkingSlot> parkingSlots =
//               snapshot.data!.docs.map((DocumentSnapshot doc) {
//             final Map<String, dynamic> data =
//                 doc.data() as Map<String, dynamic>;
//             return ParkingSlot(
//                 slotId: data['space_id'] ?? '',
//                 //isOccupied: data['isOccupied'] ?? false,
//                 status: data['status'],
//                 type: data['type']);
//           }).toList();

//           // Split the parkingSlots list into two halves
//           int halfLength = parkingSlots.length ~/ 2;
//           List<ParkingSlot> firstHalf = parkingSlots.sublist(0, halfLength);
//           List<ParkingSlot> secondHalf = parkingSlots.sublist(halfLength);

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Center(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 30),
//                       const Text(
//                         'Choose a Slot',
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const SizedBox(
//                         width: 320,
//                         child: Text(
//                           'Visualize vacant parking slots on this Lot. Tap on a slot to book a slot',
//                           style: TextStyle(
//                             color: AppColors.textDark,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // Display the first half of parking slots in the first column
//                           Column(
//                             children: [
//                               for (var slot in firstHalf)
//                                 ParkingSpace(
//                                   slot: slot,
//                                   onTap: () {
//                                     _showSlotDetailsDialog(context, slot);
//                                   },
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(
//                             width: 40,
//                           ),
//                           // Display the second half of parking slots in the second column
//                           Column(
//                             children: [
//                               for (var slot in secondHalf)
//                                 ParkingSpace(
//                                   slot: slot,
//                                   onTap: () {
//                                     _showSlotDetailsDialog(context, slot);
//                                   },
//                                 ),
//                             ],
//                           ),
//                           //   // Stairs icon
//                           // Transform.rotate(
//                           //     angle: 90 * math.pi / 90,
//                           //   child: const Icon(
//                           //       Icons.stairs,
//                           //       color: AppColors.greyDark,
//                           //       size: 40,
//                           //     ),
//                           // ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(
//                             Icons.arrow_upward,
//                             color: AppColors.greyDark,
//                             size: 24,
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             'Entry',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.greyDark,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ]),
//               ),
//             ),
//           );
//         });
//   }
// }

// void _showSlotDetailsDialog(BuildContext context, ParkingSlot slot) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: const RadialGradient(
//             center: Alignment(0.30, 0.86),
//             radius: 0.06,
//             colors: [
//               AppColors.primaryGradientStart,
//               AppColors.primaryGradientEnd,
//             ],
//           ),
//         ),
//         child: AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Text(
//                 'Slot Details',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.topRight,
//                 child: CloseButton(
//                   color: AppColors.primaryColor,
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//           content: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     const Text('Slot:'),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       slot.slotId,
//                       style: TextStyle(
//                         color: slot.status == 'Available'
//                             ? AppColors
//                                 .primaryLight // Use primary color for available slots
//                             : AppColors.secondaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ), Row(
//                   children: [
//                     const Text('Type:'),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       slot.type,
//                       style: TextStyle(
//                         color: slot.status == 'Available'
//                             ? AppColors
//                                 .primaryLight // Use primary color for available slots
//                             : AppColors.secondaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,),
//                 Row(
//                   children: [
//                     const Text('Status:'),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       slot.status ,
//                       style: TextStyle(
//                         color: slot.status == 'Available'
//                             ? AppColors
//                                 .primaryLight // Use primary color for available slots
//                             : AppColors.secondaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 PrimaryElevatedButton(
//                   onPressed: slot.status == 'Available'
//                       ? () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => const BookSlotPage(),
//                             ),
//                           );
//                         }
//                       : null, // Disable button if not available
//                   text: 'Book Slot',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// class ParkingSpace extends StatelessWidget {
//   final ParkingSlot slot;
//   final VoidCallback onTap;

//   const ParkingSpace({
//     Key? key,
//     required this.slot,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Color slotColor = slot.status == 'Occupied'
//         ? AppColors.greyLight
//         : AppColors.textLightblue;
//     Color textColor = slot.status == 'Occupied'
//         ? AppColors.secondaryColor
//         : AppColors.primaryColor;
//     IconData iconData =
//         slot.status == 'Occupied' ? Icons.lock : Icons.lock_open;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 150,
//         height: 70,
//         decoration: BoxDecoration(
//           color: slotColor,
//           border: Border.all(
//             color: AppColors.greyMedium,
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       slot.slotId,
//                       style: TextStyle(
//                         color: textColor,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     Icon(
//                       iconData,
//                       color: textColor,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   slot.status ,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: textColor,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ParkingSlot {
//   // final String lotName;
//   final String slotId;
//   // final bool isOccupied;
//   final String status;
//   final String type;

//   ParkingSlot({
//     // required this.lotName,
//     required this.slotId,
//     // required this.isOccupied,
//     required this.status,
//     required this.type,
//   });
// }
