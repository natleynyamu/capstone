import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure this import is present

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace 'yourSlotId' with an actual slot ID you want to test
            testBookingQuery('yourSlotId');
          },
          child:const  Text('Test Booking Query'),
        ),
      ),
    );
  }
}


Future<void> testBookingQuery(String slotId) async {
  // Initialize Firestore
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Construct the query
  final Query query = db
      .collection('bookings')
      .where('space_id', isEqualTo: slotId)
      .where('startTime', isGreaterThan: Timestamp.now())
      .orderBy('startTime')
      .limit(1);

  // Execute the query
  final QuerySnapshot querySnapshot = await query.get();

  // Handle the results
  if (querySnapshot.docs.isNotEmpty) {
    // Get the data of the earliest booking
    final Map<String, dynamic> bookingData =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

    // Extract the start time from the booking data
    final Timestamp startTimeStamp = bookingData['startTime'] as Timestamp;
    final DateTime startTime = startTimeStamp.toDate();

    // Format the start time as a string
    final String formattedTime =
        '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';

    print('Next booking time: $formattedTime');
  } else {
    print('No future bookings found for slot $slotId');
  }
}






// Future<Map<String, dynamic>> getNextBookingInfo(String slotId) async {
//   // Get the current time
//   DateTime currentTime = DateTime.now();

//   // Query Firestore for bookings related to the slot that start before or at the current time
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('bookings')
//       .where('space_id', isEqualTo: slotId)
//       .orderBy(
//           'startTime') // Order by start time to get the earliest booking first
//       .orderBy('endTime')
//       .limit(1) // Limit to only one result, which will be the earliest booking
//       .get();

//   // Check if there is any booking
//   if (querySnapshot.docs.isNotEmpty) {
//     // Get the data of the earliest booking
//     Map<String, dynamic> bookingData =
//         querySnapshot.docs.first.data() as Map<String, dynamic>;

//     // Extract the start time from the booking data
//     Timestamp startTimeStamp = bookingData['startTime'] as Timestamp;
//     Timestamp endTimeStamp = bookingData['endTime'] as Timestamp;

//     DateTime startTime = startTimeStamp.toDate();
//     DateTime endTime = endTimeStamp.toDate();

//     // Format the start time as a string (you can customize the format based on your requirement)
//     String formattedStartTime =
//         DateFormat('yyyy-MM-dd HH:mm').format(startTime);
//     String formattedEndTime = DateFormat('yyyy-MM-dd HH:mm').format(endTime);

//     // Check if the current time is within the booking period
//     if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
//       // The current time is within the booking period, so the slot is booked
//       return {
//         'hasBooking': true,
//         'nextBookingStartTime': formattedStartTime,
//         'nextBookingEndTime': formattedEndTime,
//       };
//     } else if (currentTime.isBefore(startTime)) {
//       // The current time is before the booking period, so the slot is available
//       // until the start time of the next booking
//       return {
//         'hasBooking': true,
//         'nextBookingStartTime': formattedStartTime,
//         'nextBookingEndTime': formattedEndTime,
//       };
//     } else {
//       // The current time is after the booking period, so the slot is available
//       return {
//         'hasBooking': false,
//         'nextBookingStartTime': formattedStartTime,
//         'nextBookingEndTime': formattedEndTime,
//       };
//     }
//   } else {
//     // If there are no bookings, return null
//     return {'hasBooking': false};
//   }
// }





 // FutureBuilder<Map<String, dynamic>>(
                      //   future: getNextBookingInfo(slot.slotId),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const CircularProgressIndicator();
                      //     } else if (snapshot.hasError) {
                      //       // Handle the error state
                      //       return Text(
                      //         'Error: ${snapshot.error}',
                      //         style:
                      //             const TextStyle(color: AppColors.errorColor),
                      //       );
                      //     } else if (snapshot.hasData) {
                      //       // Get current time
                      //       DateTime currentTime = DateTime.now();
                      //       DateTime bookingStartTime =
                      //           DateFormat('yyyy-MM-dd HH:mm').parse(
                      //               snapshot.data!['nextBookingStartTime']);
                      //       DateTime bookingEndTime =
                      //           DateFormat('yyyy-MM-dd HH:mm').parse(
                      //               snapshot.data!['nextBookingEndTime']);

                      //       // Check if current time is between booking start time and end time
                      //       if (currentTime.isAfter(bookingStartTime) &&
                      //           currentTime.isBefore(bookingEndTime)) {
                      //         return Text(
                      //           'Booked until: ${snapshot.data!['nextBookingEndTime']}',
                      //           style: const TextStyle(
                      //             color: AppColors.secondaryColor,
                      //           ),
                      //         );
                      //       } else if (currentTime.isBefore(bookingStartTime)) {
                      //         // The current time is before the booking period, so the slot is available
                      //         // until the start time of the next booking
                      //         return Text(
                      //           'Available until: ${snapshot.data!['nextBookingStartTime']}',
                      //           style: const TextStyle(
                      //             color: AppColors.primaryLight,
                      //           ),
                      //         );
                      //       } else {
                      //         // The current time is after the booking period, so the slot is available
                      //         return const Text(
                      //           'Available',
                      //           style: TextStyle(
                      //             color: AppColors.primaryLight,
                      //           ),
                      //         );
                      //       }
                      //     } else {
                      //       // If there are no bookings, return null
                      //       return const Text(
                      //         'Available',
                      //         style: TextStyle(
                      //           color: AppColors.primaryLight,
                      //         ),
                      //       );
                      //     }
                      //   },
                      // )